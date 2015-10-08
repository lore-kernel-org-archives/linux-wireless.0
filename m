Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47555 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403AbbJHJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 05:36:17 -0400
Message-ID: <1444296973.2131.14.camel@sipsolutions.net> (sfid-20151008_113621_854694_61BA7BD3)
Subject: Re: [PATCH] iw: Display-interface-generation-if-available
From: Johannes Berg <johannes@sipsolutions.net>
To: "Olsson, Ola" <Ola.Olsson@sonymobile.com>
Cc: "'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>
Date: Thu, 08 Oct 2015 11:36:13 +0200
In-Reply-To: <E9A9E8106200C64AB9ECC8CAE21CE73A05AB61FECAA4@seldmbx02.corpusers.net>
References: <E9A9E8106200C64AB9ECC8CAE21CE73A05AB61FECAA4@seldmbx02.corpusers.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-09-29 at 12:30 +0200, Olsson, Ola wrote:
[attached patch]

That email didn't make it to the list, perhaps due to the attachment.

> +	if (tb_msg[NL80211_ATTR_GENERATION])
> +> 	> 	> printf("%s\tgeneration %d\n", indent, nla_get_u32(tb_msg[NL80211_ATTR_GENERATION]));

That said, I don't really think this makes sense.

The generation field is really only useful for applications that go re
-dump if they detect a change in generation between messages, but
clearly that's not the case in iw and I don't want to encourage anyone
to script iw to the point of doing this.

johannes

