Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59186 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab3CENGA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 08:06:00 -0500
Message-ID: <5135EDB3.7060300@openwrt.org> (sfid-20130305_140605_468721_07C7178E)
Date: Tue, 05 Mar 2013 14:05:55 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 1/2] mac80211/minstrel_ht: increase sampling frequency
 of some slower rates
References: <1362311392-83648-1-git-send-email-nbd@openwrt.org> <alpine.DEB.2.02.1303051432550.23906@icf.org.ru> <5135DBB4.5090407@openwrt.org> <alpine.DEB.2.02.1303051607490.6047@icf.org.ru> <5135E48E.8080604@openwrt.org> <alpine.DEB.2.02.1303051651030.16654@icf.org.ru>
In-Reply-To: <alpine.DEB.2.02.1303051651030.16654@icf.org.ru>
Content-Type: text/plain; charset=KOI8-R
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-05 1:55 PM, Georgiewskiy Yuriy wrote:
> On 2013-03-05 13:26 +0100, Felix Fietkau wrote Georgiewskiy Yuriy:
> 
> 
> FF>Please test if this patch helps:
> FF>---
> FF>--- a/net/mac80211/rc80211_minstrel_ht.c
> FF>+++ b/net/mac80211/rc80211_minstrel_ht.c
> FF>@@ -480,7 +480,7 @@ minstrel_ht_tx_status(void *priv, struct
> FF> 
> FF> 	if (!mi->sample_wait && !mi->sample_tries && mi->sample_count > 0) {
> FF> 		mi->sample_wait = 16 + 2 * MINSTREL_TRUNC(mi->avg_ampdu_len);
> FF>-		mi->sample_tries = 2;
> FF>+		mi->sample_tries = 1;
> FF> 		mi->sample_count--;
> FF> 	}
> 
> Seems this helps, with this patch throughput is near as without this two patches applied.
OK, thanks for testing. I will submit it now.

- Felix

