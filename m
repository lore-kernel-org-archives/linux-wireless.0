Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:38899 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbaAVK5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 05:57:13 -0500
From: "Liu, Bopeng" <Bopeng.Liu@windriver.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: RE: [PATCH] mac80211_hwsim: add channel switch support
Date: Wed, 22 Jan 2014 10:57:09 +0000
Message-ID: <DE84205DFC6FCF4A904A2F75D822FABA558C33C2@ALA-MBB.corp.ad.wrs.com> (sfid-20140122_115715_533449_5BF0480D)
References: <1390387899-28972-1-git-send-email-johannes@sipsolutions.net>,<DE84205DFC6FCF4A904A2F75D822FABA558C3396@ALA-MBB.corp.ad.wrs.com>,<DE84205DFC6FCF4A904A2F75D822FABA558C33AE@ALA-MBB.corp.ad.wrs.com>
In-Reply-To: <DE84205DFC6FCF4A904A2F75D822FABA558C33AE@ALA-MBB.corp.ad.wrs.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AP Mode:

hw_mode can't be supported, have you ever met such problem?


 hostapd -B /etc/hostapd.conf
Configuration file: /etc/hostapd.conf
channel [9] (104) is disabled for use in AP mode, flags: 0x1
wlan0: IEEE 802.11 Configured channel (104) not found from the channel list of current mode (2) IEEE 802.11a
wlan0: IEEE 802.11 Hardware does not support configured channel
Could not select hw_mode and channel. (-4)
wlan0: Unable to setup interface.


Best Regards.
--------------------------------------
Bopeng Liu
WIND RIVER | China Development Center
Phone: 8610-6483-5012



________________________________________
From: Liu, Bopeng
Sent: Wednesday, January 22, 2014 6:56 PM
To: Johannes Berg; linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski
Subject: RE: [PATCH] mac80211_hwsim: add channel switch support

It will show :


Best Regards.
--------------------------------------
Bopeng Liu
WIND RIVER | China Development Center
Phone: 8610-6483-5012



________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] on behalf of Liu, Bopeng [Bopeng.Liu@windriver.com]
Sent: Wednesday, January 22, 2014 6:54 PM
To: Johannes Berg; linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski
Subject: RE: [PATCH] mac80211_hwsim: add channel switch support

Hi, Johannes:

Very glad to mail you , and I just found the latest kernel version can't support the wifi Mode A by AP Mode.

Our chip is:

01:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 [Taylor Peak] (rev 34)
        Subsystem: Intel Corporation Centrino Advanced-N 6205 AGN

iwconfig wlan0
wlan0     IEEE 802.11abg  ESSID:off/any
          Mode:Managed  Access Point: Not-Associated   Tx-Power=15 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off

Have you ever met such problem?




Best Regards.
--------------------------------------
Bopeng Liu
WIND RIVER | China Development Center
Phone: 8610-6483-5012



________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] on behalf of Johannes Berg [johannes@sipsolutions.net]
Sent: Wednesday, January 22, 2014 6:51 PM
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski
Subject: [PATCH] mac80211_hwsim: add channel switch support

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Advertise to mac80211 that we can do channel switch both
for STA and AP/GO.
After each beacon transmission check if CSA is done and
call ieee80211_csa_finish if needed.

Change-Id: I1cb34c04f533275522236381ae14b624bec35418
Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4950359..5268ede 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1307,6 +1307,9 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,

        mac80211_hwsim_tx_frame(hw, skb,
                                rcu_dereference(vif->chanctx_conf)->def.chan);
+
+       if (vif->csa_active && ieee80211_csa_is_complete(vif))
+               ieee80211_csa_finish(vif);
 }

 static enum hrtimer_restart
@@ -2109,13 +2112,15 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
                    IEEE80211_HW_AMPDU_AGGREGATION |
                    IEEE80211_HW_WANT_MONITOR_VIF |
                    IEEE80211_HW_QUEUE_CONTROL |
-                   IEEE80211_HW_SUPPORTS_HT_CCK_RATES;
+                   IEEE80211_HW_SUPPORTS_HT_CCK_RATES |
+                   IEEE80211_HW_CHANCTX_STA_CSA;
        if (rctbl)
                hw->flags |= IEEE80211_HW_SUPPORTS_RC_TABLE;

        hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
                            WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
-                           WIPHY_FLAG_AP_UAPSD;
+                           WIPHY_FLAG_AP_UAPSD |
+                           WIPHY_FLAG_HAS_CHANNEL_SWITCH;
        hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;

        /* ask mac80211 to reserve space for magic */
--
1.8.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
