Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40605 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab1EEVDc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 17:03:32 -0400
Message-ID: <4DC3109F.6080601@openwrt.org> (sfid-20110505_230336_430308_CE269AA0)
Date: Thu, 05 May 2011 23:03:27 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Bisected:  ath9k: fix powersave frame filtering/buffering in
 AP mode broke STA association.
References: <4DC30C42.6070402@candelatech.com>
In-Reply-To: <4DC30C42.6070402@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-05-05 10:44 PM, Ben Greear wrote:
> I bisected the problem I was having with ath9k STA configured for WPA
> not being able to authenticate.  I'm using nohwcrypt=1, which may
> be why no one else sees it.
> 
> According to bisect, this is the first bad commit:
> 
> commit 5519541d5a5f19893546883547e2f0f2e5934df7
> Author: Felix Fietkau<nbd@openwrt.org>
> Date:   Sun Apr 17 23:28:09 2011 +0200
> 
>       ath9k: fix powersave frame filtering/buffering in AP mode
> 
>       This patch fixes a long standing issue of pending packets in the queue being
>       sent (and retransmitted many times) to sleeping stations.
>       This was made worse by aggregation through driver-internal retransmitting
>       of A-MDPU subframes.
>       Previously the hardware tx filter was cleared unconditionally for every
>       single packet - with this patch it uses the IEEE80211_TX_CTL_CLEAR_PS_FILT
>       for unaggregated frames.
>       A sta_notify driver op is added to stop aggregation for stations when they
>       enter powersave mode. Subframes stay buffered inside the driver, to ensure
>       that the BlockAck window keeps a sane state.
>       Since the driver uses software aggregation, the clearing of the tx filter
>       needs to be handled by the driver instead of mac80211 for aggregated frames.
> 
>       Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>       Signed-off-by: John W. Linville<linville@tuxdriver.com>
> 
> 
> I'll be happy to test patches, it seems very easy to reproduce on
> my setup.
How about this?

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1270,6 +1270,9 @@ ieee80211_tx_prepare(struct ieee80211_su
 		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 	else if (test_and_clear_sta_flags(tx->sta, WLAN_STA_CLEAR_PS_FILT))
 		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
+	else if (sdata->vif.type != NL80211_IFTYPE_AP &&
+	         sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
+		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	if (skb->len > hdrlen + sizeof(rfc1042_header) + 2) {
