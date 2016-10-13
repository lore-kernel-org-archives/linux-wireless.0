Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49034 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750926AbcJMHOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 03:14:17 -0400
Message-ID: <1476341781.4904.4.camel@sipsolutions.net> (sfid-20161013_091420_929256_1922F7B4)
Subject: Re: [PATCHv4] mac80211: fix A-MSDU outer SA/DA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        Felix Fietkau <nbd@openwrt.org>
Date: Thu, 13 Oct 2016 08:56:21 +0200
In-Reply-To: <1476337315-26845-1-git-send-email-michael-dev@fami-braun.de> (sfid-20161013_074406_501207_29437AE6)
References: <1476337315-26845-1-git-send-email-michael-dev@fami-braun.de>
         (sfid-20161013_074406_501207_29437AE6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I think this looks good now. I'd prefer, however, doing the reorg that
gets rid of the memcpy() separately, that's now more or less orthogonal
to the changes you're making. I suspect it's due to you having just
edited the original, rather than starting from scratch, but I think it
makes sense to split it.

> +	memcpy(amsdu_hdr->h_source, h_80211_src, ETH_ALEN);
> +	memcpy(amsdu_hdr->h_dest, h_80211_dst, ETH_ALEN);

ether_addr_copy()? Alignment should be OK here.

johannes
