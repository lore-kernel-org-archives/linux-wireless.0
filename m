Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:43533 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3IHXQa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Sep 2013 19:16:30 -0400
Received: by mail-ob0-f170.google.com with SMTP id eh20so5424389obb.29
        for <linux-wireless@vger.kernel.org>; Sun, 08 Sep 2013 16:16:29 -0700 (PDT)
Message-ID: <522D054B.5060205@lwfinger.net> (sfid-20130909_011634_421925_3D1807C4)
Date: Sun, 08 Sep 2013 18:16:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Timothy Rundle <tgrundlesr@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8192CU continually reconnecting
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com>
In-Reply-To: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070103060309090907070009"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070103060309090907070009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 09/08/2013 06:53 AM, Timothy Rundle wrote:
> My TL-WN821N with a RTL8192CU chipsets fails to stay connected. It
> appears to be disconnecting every 5-10 seconds. Since the issue
> happens with the mainline kernel, the downstream maintainer ask me to
> post here. Here is a section of my kernel log:

This problem has been reported before; however, I cannot duplicate it on my 
openSUSE KDE system that controls the wireless using NetworkManager.

When taking another look at the code, I realized that rtl8192cu has duplicated a 
routine that is found in rtlwifi. The attached patch implements that change. 
Please try it and report back. I don't expect it to do much good as your problem 
appears to be a bad interaction with the Ubuntu front-end to wireless.

As I am not a Ubuntu user, please provide a full description of the software 
that you use to control your wifi connection.

Larry



--------------070103060309090907070009
Content-Type: text/x-patch;
 name="0001-rtlwifi-rtl8192cu-Convert-driver-to-use-rtl_process_.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-rtlwifi-rtl8192cu-Convert-driver-to-use-rtl_process_.pa";
 filename*1="tch"

>From 007a0e9862a6ee518eaad98a78e9d51dfe6a0ff5 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 8 Sep 2013 13:41:28 -0500
Subject: [PATCH] rtlwifi: rtl8192cu: Convert driver to use
 rtl_process_phyinfo()
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org

Remove routine _rtl92c_process_phyinfo() by using the equivalent routine
in driver rtlwifi.

This change also allows the removal of 5 additional routines from rtl8192cu.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c | 187 +--------------------------
 1 file changed, 2 insertions(+), 185 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
index da4f587..3936853 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -32,6 +32,7 @@
 #include "../usb.h"
 #include "../ps.h"
 #include "../cam.h"
+#include "../stats.h"
 #include "reg.h"
 #include "def.h"
 #include "phy.h"
@@ -738,16 +739,6 @@ static u8 _rtl92c_evm_db_to_percentage(char value)
 	return ret_val;
 }
 
-static long _rtl92c_translate_todbm(struct ieee80211_hw *hw,
-				     u8 signal_strength_index)
-{
-	long signal_power;
-
-	signal_power = (long)((signal_strength_index + 1) >> 1);
-	signal_power -= 95;
-	return signal_power;
-}
-
 static long _rtl92c_signal_scale_mapping(struct ieee80211_hw *hw,
 		long currsig)
 {
@@ -913,180 +904,6 @@ static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 			  (hw, total_rssi /= rf_rx_num));
 }
 
-static void _rtl92c_process_ui_rssi(struct ieee80211_hw *hw,
-		struct rtl_stats *pstats)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_phy *rtlphy = &(rtlpriv->phy);
-	u8 rfpath;
-	u32 last_rssi, tmpval;
-
-	if (pstats->packet_toself || pstats->packet_beacon) {
-		rtlpriv->stats.rssi_calculate_cnt++;
-		if (rtlpriv->stats.ui_rssi.total_num++ >=
-		    PHY_RSSI_SLID_WIN_MAX) {
-			rtlpriv->stats.ui_rssi.total_num =
-			    PHY_RSSI_SLID_WIN_MAX;
-			last_rssi =
-			    rtlpriv->stats.ui_rssi.elements[rtlpriv->
-							   stats.ui_rssi.index];
-			rtlpriv->stats.ui_rssi.total_val -= last_rssi;
-		}
-		rtlpriv->stats.ui_rssi.total_val += pstats->signalstrength;
-		rtlpriv->stats.ui_rssi.elements[rtlpriv->stats.ui_rssi.
-					index++] = pstats->signalstrength;
-		if (rtlpriv->stats.ui_rssi.index >= PHY_RSSI_SLID_WIN_MAX)
-			rtlpriv->stats.ui_rssi.index = 0;
-		tmpval = rtlpriv->stats.ui_rssi.total_val /
-		    rtlpriv->stats.ui_rssi.total_num;
-		rtlpriv->stats.signal_strength =
-		    _rtl92c_translate_todbm(hw, (u8) tmpval);
-		pstats->rssi = rtlpriv->stats.signal_strength;
-	}
-	if (!pstats->is_cck && pstats->packet_toself) {
-		for (rfpath = RF90_PATH_A; rfpath < rtlphy->num_total_rfpath;
-		     rfpath++) {
-			if (!rtl8192_phy_check_is_legal_rfpath(hw, rfpath))
-				continue;
-			if (rtlpriv->stats.rx_rssi_percentage[rfpath] == 0) {
-				rtlpriv->stats.rx_rssi_percentage[rfpath] =
-				    pstats->rx_mimo_signalstrength[rfpath];
-			}
-			if (pstats->rx_mimo_signalstrength[rfpath] >
-			    rtlpriv->stats.rx_rssi_percentage[rfpath]) {
-				rtlpriv->stats.rx_rssi_percentage[rfpath] =
-				    ((rtlpriv->stats.
-				      rx_rssi_percentage[rfpath] *
-				      (RX_SMOOTH_FACTOR - 1)) +
-				     (pstats->rx_mimo_signalstrength[rfpath])) /
-				    (RX_SMOOTH_FACTOR);
-
-				rtlpriv->stats.rx_rssi_percentage[rfpath] =
-				    rtlpriv->stats.rx_rssi_percentage[rfpath] +
-				    1;
-			} else {
-				rtlpriv->stats.rx_rssi_percentage[rfpath] =
-				    ((rtlpriv->stats.
-				      rx_rssi_percentage[rfpath] *
-				      (RX_SMOOTH_FACTOR - 1)) +
-				     (pstats->rx_mimo_signalstrength[rfpath])) /
-				    (RX_SMOOTH_FACTOR);
-			}
-		}
-	}
-}
-
-static void _rtl92c_update_rxsignalstatistics(struct ieee80211_hw *hw,
-					       struct rtl_stats *pstats)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	int weighting = 0;
-
-	if (rtlpriv->stats.recv_signal_power == 0)
-		rtlpriv->stats.recv_signal_power = pstats->recvsignalpower;
-	if (pstats->recvsignalpower > rtlpriv->stats.recv_signal_power)
-		weighting = 5;
-	else if (pstats->recvsignalpower < rtlpriv->stats.recv_signal_power)
-		weighting = (-5);
-	rtlpriv->stats.recv_signal_power =
-	    (rtlpriv->stats.recv_signal_power * 5 +
-	     pstats->recvsignalpower + weighting) / 6;
-}
-
-static void _rtl92c_process_pwdb(struct ieee80211_hw *hw,
-		struct rtl_stats *pstats)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	long undec_sm_pwdb = 0;
-
-	if (mac->opmode == NL80211_IFTYPE_ADHOC) {
-		return;
-	} else {
-		undec_sm_pwdb = rtlpriv->dm.undec_sm_pwdb;
-	}
-	if (pstats->packet_toself || pstats->packet_beacon) {
-		if (undec_sm_pwdb < 0)
-			undec_sm_pwdb = pstats->rx_pwdb_all;
-		if (pstats->rx_pwdb_all > (u32) undec_sm_pwdb) {
-			undec_sm_pwdb = (((undec_sm_pwdb) *
-			      (RX_SMOOTH_FACTOR - 1)) +
-			     (pstats->rx_pwdb_all)) / (RX_SMOOTH_FACTOR);
-			undec_sm_pwdb += 1;
-		} else {
-			undec_sm_pwdb = (((undec_sm_pwdb) *
-			      (RX_SMOOTH_FACTOR - 1)) +
-			     (pstats->rx_pwdb_all)) / (RX_SMOOTH_FACTOR);
-		}
-		rtlpriv->dm.undec_sm_pwdb = undec_sm_pwdb;
-		_rtl92c_update_rxsignalstatistics(hw, pstats);
-	}
-}
-
-static void _rtl92c_process_LINK_Q(struct ieee80211_hw *hw,
-					     struct rtl_stats *pstats)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 last_evm = 0, n_stream, tmpval;
-
-	if (pstats->signalquality != 0) {
-		if (pstats->packet_toself || pstats->packet_beacon) {
-			if (rtlpriv->stats.LINK_Q.total_num++ >=
-			    PHY_LINKQUALITY_SLID_WIN_MAX) {
-				rtlpriv->stats.LINK_Q.total_num =
-				    PHY_LINKQUALITY_SLID_WIN_MAX;
-				last_evm =
-				    rtlpriv->stats.LINK_Q.elements
-				    [rtlpriv->stats.LINK_Q.index];
-				rtlpriv->stats.LINK_Q.total_val -=
-				    last_evm;
-			}
-			rtlpriv->stats.LINK_Q.total_val +=
-			    pstats->signalquality;
-			rtlpriv->stats.LINK_Q.elements
-			   [rtlpriv->stats.LINK_Q.index++] =
-			    pstats->signalquality;
-			if (rtlpriv->stats.LINK_Q.index >=
-			    PHY_LINKQUALITY_SLID_WIN_MAX)
-				rtlpriv->stats.LINK_Q.index = 0;
-			tmpval = rtlpriv->stats.LINK_Q.total_val /
-			    rtlpriv->stats.LINK_Q.total_num;
-			rtlpriv->stats.signal_quality = tmpval;
-			rtlpriv->stats.last_sigstrength_inpercent = tmpval;
-			for (n_stream = 0; n_stream < 2;
-			     n_stream++) {
-				if (pstats->RX_SIGQ[n_stream] != -1) {
-					if (!rtlpriv->stats.RX_EVM[n_stream]) {
-						rtlpriv->stats.RX_EVM[n_stream]
-						 = pstats->RX_SIGQ[n_stream];
-					}
-					rtlpriv->stats.RX_EVM[n_stream] =
-					    ((rtlpriv->stats.RX_EVM
-					    [n_stream] *
-					    (RX_SMOOTH_FACTOR - 1)) +
-					    (pstats->RX_SIGQ
-					    [n_stream] * 1)) /
-					    (RX_SMOOTH_FACTOR);
-				}
-			}
-		}
-	} else {
-		;
-	}
-}
-
-static void _rtl92c_process_phyinfo(struct ieee80211_hw *hw,
-				     u8 *buffer,
-				     struct rtl_stats *pcurrent_stats)
-{
-	if (!pcurrent_stats->packet_matchbssid &&
-	    !pcurrent_stats->packet_beacon)
-		return;
-	_rtl92c_process_ui_rssi(hw, pcurrent_stats);
-	_rtl92c_process_pwdb(hw, pcurrent_stats);
-	_rtl92c_process_LINK_Q(hw, pcurrent_stats);
-}
-
 void rtl92c_translate_rx_signal_stuff(struct ieee80211_hw *hw,
 					       struct sk_buff *skb,
 					       struct rtl_stats *pstats,
@@ -1123,5 +940,5 @@ void rtl92c_translate_rx_signal_stuff(struct ieee80211_hw *hw,
 	_rtl92c_query_rxphystatus(hw, pstats, pdesc, p_drvinfo,
 				   packet_matchbssid, packet_toself,
 				   packet_beacon);
-	_rtl92c_process_phyinfo(hw, tmp_buf, pstats);
+	rtl_process_phyinfo(hw, tmp_buf, pstats);
 }
-- 
1.8.1.4


--------------070103060309090907070009--
