Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:59154 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760AbZKMWfD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 17:35:03 -0500
Message-ID: <4AFDDF19.8060202@irobot.com>
Date: Fri, 13 Nov 2009 14:35:05 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	Derek Smithies <derek@indranet.co.nz>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
Subject: Re: compat-wireless and minstrel
References: <4AF0D54D.4090303@irobot.com>	 <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com> <1258097352.3899.75.camel@johannes.local>
In-Reply-To: <1258097352.3899.75.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> it would help if you used diff -u
> johannes
>   
Will do.

I think the patch below is most correct.  However, I still have problems 
when a third station joins the ad-hoc network.
When the third station joins, it doesn't always show a complete set of 
bitrates in the rc_stats files for the other two stations.  For one (I 
assume this is the beacon OR whoever sent a probe response) it shows 
all, but for the other, it shows only one or two.  This is remarkably 
similar to the failure mode I was seeing before, so much so that there 
were probably cases where I confused the two issues.
I've traced it down to this bit in rx.c in prepare_for_handlers():

        case NL80211_IFTYPE_ADHOC:
                [ stuff deleted ]
                } else if (!rx->sta) {
                        int rate_idx;
                        if (rx->status->flag & RX_FLAG_HT)
                                rate_idx = 0; /* TODO: HT rates */
                        else
                                rate_idx = rx->status->rate_idx;

                        rx->sta = ieee80211_ibss_add_sta(sdata, bssid, 
hdr->addr2,
                                BIT(rate_idx));
                }
                break;

I don't think this is right.  I know the issue is here, because if I 
change to "BIT(rate_idx) | 0xfff" the problem corrects.  Either we need 
to (a) set it properly here or (b) make sure something else happens 
before or after.  I'm not sure we have enough context here to do (a).

Thoughts?

patch for ibss.c :

--- compat-wireless-2009-11-09/net/mac80211/ibss.c    2009-11-08 
21:15:06.000000000 -0800
+++ compat-wireless-2009-11-09d/net/mac80211/ibss.c    2009-11-13 
14:17:37.935556965 -0800
@@ -246,9 +246,13 @@ static void ieee80211_rx_bss_info(struct
     if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
         return;
 
+    supp_rates = ieee80211_sta_get_rates(local, elems, band);
+
+    /* make sure mandatory rates are always added */
+    supp_rates |= ieee80211_mandatory_rates(local, band);
+
     if (sdata->vif.type == NL80211_IFTYPE_ADHOC && elems->supp_rates &&
         memcmp(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0) {
-        supp_rates = ieee80211_sta_get_rates(local, elems, band);
 
         rcu_read_lock();
 
@@ -257,12 +261,10 @@ static void ieee80211_rx_bss_info(struct
             u32 prev_rates;
 
             prev_rates = sta->sta.supp_rates[band];
-            /* make sure mandatory rates are always added */
-            sta->sta.supp_rates[band] = supp_rates |
-                ieee80211_mandatory_rates(local, band);
+            sta->sta.supp_rates[band] = supp_rates;
 
+            if (sta->sta.supp_rates[band] != prev_rates) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
-            if (sta->sta.supp_rates[band] != prev_rates)
                 printk(KERN_DEBUG "%s: updated supp_rates set "
                     "for %pM based on beacon info (0x%llx | "
                     "0x%llx -> 0x%llx)\n",
@@ -272,6 +274,8 @@ static void ieee80211_rx_bss_info(struct
                     (unsigned long long) supp_rates,
                     (unsigned long long) sta->sta.supp_rates[band]);
 #endif
+                rate_control_rate_init(sta);
+            }
         } else
             ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, 
supp_rates);
 
@@ -415,6 +419,15 @@ struct sta_info *ieee80211_ibss_add_sta(
     sta->sta.supp_rates[band] = supp_rates |
             ieee80211_mandatory_rates(local, band);
 
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+    printk(KERN_DEBUG "%s: initialized supp_rates set "
+        "for %pM (0x%llx) (band %d)\n",
+        sdata->dev->name,
+        sta->sta.addr,
+        (unsigned long long) sta->sta.supp_rates[band],
+        band);
+#endif
+
     rate_control_rate_init(sta);
 
     if (sta_info_insert(sta))


