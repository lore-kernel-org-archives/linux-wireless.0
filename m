Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:35538 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYIYXDe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 19:03:34 -0400
Received: by nf-out-0910.google.com with SMTP id d3so275277nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 16:03:32 -0700 (PDT)
Message-ID: <48DC18C2.1020705@gmail.com> (sfid-20080926_010339_549326_D482D1BA)
Date: Fri, 26 Sep 2008 00:03:30 +0100
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless: consolidate on a single escape_essid implementation
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com> <20080924232453.GG9187@tesla>
In-Reply-To: <20080924232453.GG9187@tesla>
Content-Type: text/plain; charset=us-ascii; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Which reminds me, net/ieee80211/ should be ipw'ized now that the
> old softmac drivers are gone.
> 
> mcgrof@tesla ~/wireless-testing/drivers/net/wireless (git::v2.6.27-rc6)$ grep -nHr "#include <net/ieee80211.h>" *
> orinoco.c:88:#include <net/ieee80211.h>
> 
> Whatever these suckers are using can probably be slapped in there as
> well. But yea -- we just need to get it done huh.

Almost all of what orinoco uses can now be sourced from <linux/ieee80211.h> instead. However there are the following constants:

Missing:
MAX_WPA_IE_LEN (64)
WEP_KEYS (4)

Possible alternative, but change in value:
IEEE80211_FRAME_LEN (2334) != IEEE80211_MAX_FRAME_LEN (2352)

Obviously these can be defined locally if we're not sure if they should be global, or where they belong.



Regards,

Dave.
