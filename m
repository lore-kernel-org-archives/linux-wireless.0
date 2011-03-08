Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36803 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab1CHXyq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 18:54:46 -0500
Received: by iyb26 with SMTP id 26so5318132iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2011 15:54:46 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 8 Mar 2011 15:54:46 -0800
Message-ID: <AANLkTikwjgKeMPo3UGL=0R2Qxa5DMYC7YejBSSLdqjKd@mail.gmail.com>
Subject: Delay enabling power save until 4-way Handshake completes
From: Jason Young <a.young.jason@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

ieee80211_recalc_ps is enabling power save before the 4-way Handshake
completes in station mode. This can potentially delay when the station
is authorized to send/receive traffic. Specifically, this is a problem
when dynamic power save is disabled and the station must therefore
send PS-Polls (or U-APSD trigger frames) for retrieve downlink EAPOL
frames. This may result in a failed 4-way Handshake if the AP's (or
authenticators) timing requirements are strict and/or dependent on the
beacon interval etc. It also increases total roaming time, which
becomes an issue if the station is part of a VoIP solution.

I've also found at least one AP (Cisco1252) whose's U-APSD
implementation is broken if power save is enabled before the 4-way
Handshake completes; it will not deliver the buffered downlink EAPOL
frames to the station in response to U-APSD trigger frames, despite
the fact that the AP is advertising traffic in the TIM.

Something like the following prevents powersave from being enabled
before the 4-way handshake completes, but we still need to call
ieee80211_recalc_ps again after WLAN_STA_AUTHORIZED is set and I'm not
sure the best place for that. Any ideas or alternate approaches that
may solve this problem?

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cc984bd..64d92d5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -613,6 +613,37 @@ static void ieee80211_change_ps(struct
ieee80211_local *local)
        }
 }

+static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
+{
+       struct ieee80211_if_managed *mgd = &sdata->u.mgd;
+       struct sta_info *sta = NULL;
+       u32 sta_flags = 0;
+
+       if (!mgd->powersave)
+               return false;
+
+       if (!mgd->associated)
+               return false;
+
+       if (!mgd->associated->beacon_ies)
+               return false;
+
+       if (mgd->flags & (IEEE80211_STA_BEACON_POLL |
+                         IEEE80211_STA_CONNECTION_POLL))
+               return false;
+
+       rcu_read_lock();
+       sta = sta_info_get(sdata, mgd->bssid);
+       if (sta)
+               sta_flags = get_sta_flags(sta);
+       rcu_read_unlock();
+
+       if (!(sta_flags & WLAN_STA_AUTHORIZED))
+               return false;
+
+       return true;
+}
+
 /* need to hold RTNL or interface lock */
 void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 {
@@ -647,11 +678,7 @@ void ieee80211_recalc_ps(struct ieee80211_local
*local, s32 late
                count++;
        }

-       if (count == 1 && found->u.mgd.powersave &&
-           found->u.mgd.associated &&
-           found->u.mgd.associated->beacon_ies &&
-           !(found->u.mgd.flags & (IEEE80211_STA_BEACON_POLL |
-                                   IEEE80211_STA_CONNECTION_POLL))) {
+       if (count == 1 && ieee80211_powersave_allowed(found)) {
                struct ieee80211_conf *conf = &local->hw.conf;
                s32 beaconint_us;

--
Jason Young
