Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:19803 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751535Ab0JAFP5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 01:15:57 -0400
Received: from vs3005.wh2.ocn.ne.jp (125.206.180.233)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-034543154
	for <linux-wireless@vger.kernel.org>; Fri,  1 Oct 2010 14:15:56 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Add WME information element for IBSS
Date: Fri, 1 Oct 2010 14:15:33 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20100916083431.14175.90366.stgit@tt-desk> <1284629853.3731.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1284629853.3731.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010011415.33117.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu September 16 2010 18:37:33 Johannes Berg wrote:
> On Thu, 2010-09-16 at 17:34 +0900, Bruno Randolf wrote:
> > Enable WME QoS in IBSS mode by adding a WME information element to
> > beacons and probe respones and by checking for it and marking stations
> > as WME capable if it is present.
> > 
> >  			rcu_read_unlock();
> > 
> > -			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
> > -					       supp_rates, GFP_KERNEL);
> > +
> > +			sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
> > +					mgmt->sa, supp_rates, GFP_KERNEL);
> > 
> >  		}
> > 
> > +		if (sta && elems->wmm_info)
> > +			set_sta_flags(sta, WLAN_STA_WME);
> 
> NACK, this is obviously racy.

sorry for the late reply.

better like this?

@@ -291,11 +304,16 @@ static void ieee80211_rx_bss_info(struct 
ieee80211_sub_if_data *sdata,
 #endif
                                rate_control_rate_init(sta);
                        }
+                       if (elems->wmm_info)
+                               set_sta_flags(sta, WLAN_STA_WME);
                        rcu_read_unlock();
                } else {
                        rcu_read_unlock();
-                       ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
-                                              supp_rates, GFP_KERNEL);
+
+                       sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
+                                       mgmt->sa, supp_rates, GFP_KERNEL);
+                       if (sta && elems->wmm_info)
+                               set_sta_flags(sta, WLAN_STA_WME);
                }
        }

if not, i don't get it... could you explain how it should be done properly?

thanks,
bruno
