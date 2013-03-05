Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58116 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab3CEM04 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 07:26:56 -0500
Message-ID: <5135E48E.8080604@openwrt.org> (sfid-20130305_132700_158213_35EDBF4E)
Date: Tue, 05 Mar 2013 13:26:54 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 1/2] mac80211/minstrel_ht: increase sampling frequency
 of some slower rates
References: <1362311392-83648-1-git-send-email-nbd@openwrt.org> <alpine.DEB.2.02.1303051432550.23906@icf.org.ru> <5135DBB4.5090407@openwrt.org> <alpine.DEB.2.02.1303051607490.6047@icf.org.ru>
In-Reply-To: <alpine.DEB.2.02.1303051607490.6047@icf.org.ru>
Content-Type: text/plain; charset=KOI8-R
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-05 1:08 PM, Georgiewskiy Yuriy wrote:
> On 2013-03-05 12:49 +0100, Felix Fietkau wrote Georgiewskiy Yuriy:
> 
> FF>On 2013-03-05 11:35 AM, Georgiewskiy Yuriy wrote:
> FF>> On 2013-03-03 12:49 +0100, Felix Fietkau wrote linux-wireless@vger.kernel.org:
> FF>> 
> FF>> Hi, in my case this two patches cause throughput drop, withous it i have 50-55Mbs
> FF>> with it applied only 35-40.
> FF>Please show me the rate control statistics from debugfs.
> 
> in attachment
Please test if this patch helps:
---
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -480,7 +480,7 @@ minstrel_ht_tx_status(void *priv, struct
 
 	if (!mi->sample_wait && !mi->sample_tries && mi->sample_count > 0) {
 		mi->sample_wait = 16 + 2 * MINSTREL_TRUNC(mi->avg_ampdu_len);
-		mi->sample_tries = 2;
+		mi->sample_tries = 1;
 		mi->sample_count--;
 	}
 


