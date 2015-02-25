Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:56375 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbbBYJlr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 04:41:47 -0500
From: Sven Eckelmann <sven@narfation.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: simon@open-mesh.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, marek@open-mesh.com,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [PATCH v6 2/3] mac80211/minstrel_ht: use the new rate control API
Date: Wed, 25 Feb 2015 10:35:05 +0100
Message-ID: <8006741.C7YlhOg3U7@bentobox> (sfid-20150225_104153_601408_755C830E)
In-Reply-To: <2670025.E9NWYu3f4D@bentobox>
References: <1366640083-1054-1-git-send-email-nbd@openwrt.org> <1366640083-1054-2-git-send-email-nbd@openwrt.org> <2670025.E9NWYu3f4D@bentobox>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

On Friday 20 February 2015 15:12:10 Sven Eckelmann wrote:
> >  static void
> > 
> > @@ -846,6 +857,8 @@ minstrel_ht_update_caps(void *priv, struct
> > ieee80211_supported_band *sband,
> > 
> >  	msp->is_ht = true;
> >  	memset(mi, 0, sizeof(*mi));
> > 
> > +
> > +	mi->sta = sta;
> > 
> >  	mi->stats_update = jiffies;
> 
> minstrel_ht_update_caps can be called on init and on different other changes
> (rate_control_rate_update).
> 
> Which lock protects mi from following scenario?
> 
> context 1: memset(mi, 0, sizeof(*mi)); // mi->sta is now NULL
> context 2: minstrel_ht_update_rates -> rate_control_set_rates(mp->hw,
>            mi->sta, rates)
> context 2: rate_control_set_rates dereferences
>            pubsta->rates (mi->sta + 0x48) -> Kernel Oops
> context 1: mi->sta = sta
> 
> The first context is from one of the many rate_control_rate_update in
> mac80211 and the second context is from ieee80211_tx_status.
> 
> The question came up when discovering the OpenWrt bug report
>  https://dev.openwrt.org/ticket/18388 (minstrel_ht_update_caps
> the thing most likely behind minstrel_remove_sta_debugfs+0xe8c/0x1674 - at
> least EPC is pointing inside this function for a build from this revision)

I have someone here who says that he can reproduce this problem with a current 
mac80211 from OpenWrt in ~40 min in a mesh setup with a lot of multicast. I 
gave them following test patch to check if it could be related to the scenario 
explained earlier:

--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1126,7 +1126,8 @@ minstrel_ht_update_caps(void *priv, stru
 	use_vht = 0;
 
 	msp->is_ht = true;
-	memset(mi, 0, sizeof(*mi));
+	/* don't reset the first entry of mi which is the sta pointer */
+	memset(((u8 *)mi) + sizeof(mi->sta), 0, sizeof(*mi) - sizeof(mi->sta));
 
 	mi->sta = sta;
 	mi->stats_update = jiffies;


He reported back that the mesh nodes were now running fine since 7 hours. It 
is also tested in another network which now runs since 1 1/2 days and were not 
able to run stable for more then 20 hours at max before applying that patch.

These numbers are no definitive proof but at least suggest that there could be 
a connection. Maybe you already had some concept how to protect from this 
problem and have not fully implemented it. Would be nice to hear back from 
you.

Kind regards,
	Sven
