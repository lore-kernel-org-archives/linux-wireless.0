Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:32842 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139AbcBZR7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 12:59:31 -0500
Date: Fri, 26 Feb 2016 19:59:25 +0200
From: Jouni Malinen <j@w1.fi>
To: =?utf-8?B?Sm/Do28=?= Paulo Rechi Vita <jprvita@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?utf-8?B?Sm/Do28=?= Paulo Rechi Vita <jprvita@endlessm.com>
Subject: Re: [PATCHv2 08/10] rfkill: Use switch to demux userspace operations
Message-ID: <20160226175925.GA9331@w1.fi> (sfid-20160226_185934_763194_D15F0423)
References: <1456159001-20307-1-git-send-email-jprvita@endlessm.com>
 <1456159001-20307-9-git-send-email-jprvita@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1456159001-20307-9-git-send-email-jprvita@endlessm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 22, 2016 at 11:36:39AM -0500, João Paulo Rechi Vita wrote:
> Using a switch to handle different ev.op values in rfkill_fop_write()
> makes the code easier to extend, as out-of-range values can always be
> handled by the default case.

This breaks rfkill.. There are automated test scripts for testing this
area (and most of Wi-Fi for that matter. It would be nice if these were
used for changes before they get contributed upstream..

http://buildbot.w1.fi/hwsim/

This specific commit broke all the rfkill_* test cases because of
following:

> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> @@ -1199,29 +1200,32 @@ static ssize_t rfkill_fop_write(struct file *file, const char __user *buf,
> -	list_for_each_entry(rfkill, &rfkill_list, node) {
> -		if (rfkill->idx != ev.idx && ev.op != RFKILL_OP_CHANGE_ALL)
> -			continue;
> -
> -		if (rfkill->type != ev.type && ev.type != RFKILL_TYPE_ALL)
> -			continue;

Note that RFKILL_TYPE_ALL here..

> +		list_for_each_entry(rfkill, &rfkill_list, node)
> +			if (rfkill->type == ev.type ||
> +			    ev.type == RFKILL_TYPE_ALL)
> +				rfkill_set_block(rfkill, ev.soft);

It was included for RFKILL_OP_CHANGE_ALL.

> +	case RFKILL_OP_CHANGE:
> +		list_for_each_entry(rfkill, &rfkill_list, node)
> +			if (rfkill->idx == ev.idx && rfkill->type == ev.type)
> +				rfkill_set_block(rfkill, ev.soft);

but not for RFKILL_OP_CHANGE..

This needs following to work:


diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 59ff92d..c4bbd19 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -1239,7 +1239,9 @@ static ssize_t rfkill_fop_write(struct file *file, const char __user *buf,
 		break;
 	case RFKILL_OP_CHANGE:
 		list_for_each_entry(rfkill, &rfkill_list, node)
-			if (rfkill->idx == ev.idx && rfkill->type == ev.type)
+			if (rfkill->idx == ev.idx &&
+			    (rfkill->type == ev.type ||
+			     ev.type == RFKILL_TYPE_ALL))
 				rfkill_set_block(rfkill, ev.soft);
 		ret = 0;
 		break;
 
-- 
Jouni Malinen                                            PGP id EFC895FA
