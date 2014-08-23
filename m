Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([193.35.52.29]:59120 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaHWV2d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 17:28:33 -0400
Received: from pannekake.samfundet.no ([2001:67c:29f4::50] ident=unknown)
	by cassarossa.samfundet.no with esmtps (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1XLIrL-0000gd-Ge
	for linux-wireless@vger.kernel.org; Sat, 23 Aug 2014 23:28:28 +0200
Received: from sesse by pannekake.samfundet.no with local (Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1XLIrL-00046K-5v
	for linux-wireless@vger.kernel.org; Sat, 23 Aug 2014 23:28:27 +0200
Date: Sat, 23 Aug 2014 23:28:27 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] Support Cisco DTPC IE to reduce transmit power
Message-ID: <20140823212827.GB15466@sesse.net> (sfid-20140823_233225_303466_F926181D)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="B4IIlcmfBL/1gGOG"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--B4IIlcmfBL/1gGOG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

I noticed the other day that Linux and Cisco don't always seem to speak the
same language when it comes to reducing the client transmit power. I've
written a quick patch to try to remedy it; please consider applying to
the wireless tree.

/* Steinar */
-- 
Homepage: http://www.sesse.net/

--B4IIlcmfBL/1gGOG
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-Support-DTPC-IE-from-Cisco-Client-eXtensions.patch"

>From d8fc81539016ae8663b0f479ad95cc42f286ec0b Mon Sep 17 00:00:00 2001
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Date: Sat, 23 Aug 2014 23:22:08 +0200
Subject: [PATCH] Support DTPC IE (from Cisco Client eXtensions)

Linux already supports 802.11h, where the access point can tell the
client to reduce its transmission power. However, 802.11h is only
defined for 5 GHz, where the need for this is much smaller than on
2.4 GHz.

Cisco has their own solution, called DTPC (Dynamic Transmit Power
Control).  Cisco APs on a controller sometimes but not always send
802.11h; they always send DTPC, even on 2.4 GHz. This patch adds support
for parsing and honoring the DTPC IE if there is no 802.11h element;
the format is not documented, but very simple.

Tested (on top of wireless.git and on 3.16.1) against a Cisco Aironet
1142 joined to a Cisco 2504 WLC, by setting various transmit power
levels for the given access points and observing the results.
The Wireshark 802.11 dissector agrees with the interpretation of the
element, except for negative numbers, which we guard against to be
conservative.

Signed-Off-By: Steinar H. Gunderson <sgunderson@bigfoot.com>
---
 include/linux/ieee80211.h  |    3 ++-
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   27 +++++++++++++++++++++++++++
 net/mac80211/util.c        |   19 +++++++++++++++++++
 4 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 63ab3873..d0ec287 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1806,7 +1806,8 @@ enum ieee80211_eid {
 	WLAN_EID_DMG_TSPEC = 146,
 	WLAN_EID_DMG_AT = 147,
 	WLAN_EID_DMG_CAP = 148,
-	/* 149-150 reserved for Cisco */
+	/* 149 reserved for Cisco */
+	WLAN_EID_CISCO_VENDOR_SPECIFIC = 150,
 	WLAN_EID_DMG_OPERATION = 151,
 	WLAN_EID_DMG_BSS_PARAM_CHANGE = 152,
 	WLAN_EID_DMG_BEAM_REFINEMENT = 153,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ef7a089..e995556 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1367,6 +1367,7 @@ struct ieee802_11_elems {
 	const struct ieee80211_wide_bw_chansw_ie *wide_bw_chansw_ie;
 	const u8 *country_elem;
 	const u8 *pwr_constr_elem;
+	const u8 *cisco_dtpc_elem;
 	const struct ieee80211_timeout_interval_ie *timeout_int;
 	const u8 *opmode_notif;
 	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 31a8afa..1c8c0a3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1227,6 +1227,30 @@ static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
+static u32 ieee80211_handle_cisco_dtpc(struct ieee80211_sub_if_data *sdata,
+				       struct ieee80211_channel *channel,
+				       const u8 *cisco_dtpc_elem)
+{
+	/* From practical testing, the two data bytes of the DTPC element
+	 * seem to contain the requested dBm level in little-endian.
+	 * It never seems to go negative even if -1 dBm is requested
+	 * (capped at zero), but just to be sure, we do it ourselves.
+	 */
+	__s16 new_ap_level = (__s16) le16_to_cpup((__le16 *)(cisco_dtpc_elem + 4));
+	new_ap_level = max_t(__s16, 0, new_ap_level);
+
+	if (sdata->ap_power_level == new_ap_level)
+		return 0;
+
+	sdata_info(sdata,
+		   "Limiting TX power to %d dBm as advertised by %pM\n",
+		   new_ap_level, sdata->u.mgd.bssid);
+	sdata->ap_power_level = new_ap_level;
+	if (__ieee80211_recalc_txpower(sdata))
+		return BSS_CHANGED_TXPOWER;
+	return 0;
+}
+
 /* powersave */
 static void ieee80211_enable_ps(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata)
@@ -3197,6 +3221,9 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 						       elems.country_elem,
 						       elems.country_elem_len,
 						       elems.pwr_constr_elem);
+	else if (elems.cisco_dtpc_elem) 
+		changed |= ieee80211_handle_cisco_dtpc(sdata, chan,
+						       elems.cisco_dtpc_elem);
 
 	ieee80211_bss_info_change_notify(sdata, changed);
 }
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 725af7a..a253487 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1014,6 +1014,25 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			}
 			elems->pwr_constr_elem = pos;
 			break;
+		case WLAN_EID_CISCO_VENDOR_SPECIFIC:
+			/* Lots of different options exist, but we only care about the
+			 * Dynamic Transmit Power Control element. First check
+			 * for the Cisco OUI, then for the DTPC tag (0x00).
+			 */
+			if (elen < 4) {
+				elem_parse_failed = true;
+				break;
+			}
+			if (pos[0] != 0x00 || pos[1] != 0x40 ||
+			    pos[2] != 0x96 || pos[3] != 0x00) {
+				break;
+			}
+			if (elen != 6) {
+				elem_parse_failed = true;
+				break;
+			}
+			elems->cisco_dtpc_elem = pos;
+			break;
 		case WLAN_EID_TIMEOUT_INTERVAL:
 			if (elen >= sizeof(struct ieee80211_timeout_interval_ie))
 				elems->timeout_int = (void *)pos;
-- 
1.7.10.4


--B4IIlcmfBL/1gGOG--
