Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3472 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab1IPT20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:26 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 19/19] staging: brcm80211: sparse endianness warnings on
 fullmac bss info
Date: Fri, 16 Sep 2011 12:28:08 -0700
Message-ID: <1316201288-29635-20-git-send-email-frankyl@broadcom.com> (sfid-20110916_212858_972553_A1E26D39)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Structure that is received from dongle has been annotated.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |   27 +++++++++++----------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   10 ++++----
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index de3f914..da53dd0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -366,36 +366,37 @@ struct brcmf_pkt_filter_enable {
  * next bss_info structure in a vector (in struct brcmf_scan_results)
  */
 struct brcmf_bss_info {
-	u32 version;		/* version field */
-	u32 length;		/* byte length of data in this record,
+	__le32 version;		/* version field */
+	__le32 length;		/* byte length of data in this record,
 				 * starting at version and including IEs
 				 */
 	u8 BSSID[ETH_ALEN];
-	u16 beacon_period;	/* units are Kusec */
-	u16 capability;	/* Capability information */
+	__le16 beacon_period;	/* units are Kusec */
+	__le16 capability;	/* Capability information */
 	u8 SSID_len;
 	u8 SSID[32];
 	struct {
-		uint count;   /* # rates in this set */
+		__le32 count;   /* # rates in this set */
 		u8 rates[16]; /* rates in 500kbps units w/hi bit set if basic */
 	} rateset;		/* supported rates */
-	u16 chanspec;	/* chanspec for bss */
-	u16 atim_window;	/* units are Kusec */
+	__le16 chanspec;	/* chanspec for bss */
+	__le16 atim_window;	/* units are Kusec */
 	u8 dtim_period;	/* DTIM period */
-	s16 RSSI;		/* receive signal strength (in dBm) */
+	__le16 RSSI;		/* receive signal strength (in dBm) */
 	s8 phy_noise;		/* noise (in dBm) */
 
 	u8 n_cap;		/* BSS is 802.11N Capable */
-	u32 nbss_cap;	/* 802.11N BSS Capabilities (based on HT_CAP_*) */
+	/* 802.11N BSS Capabilities (based on HT_CAP_*): */
+	__le32 nbss_cap;
 	u8 ctl_ch;		/* 802.11N BSS control channel number */
-	u32 reserved32[1];	/* Reserved for expansion of BSS properties */
+	__le32 reserved32[1];	/* Reserved for expansion of BSS properties */
 	u8 flags;		/* flags */
 	u8 reserved[3];	/* Reserved for expansion of BSS properties */
 	u8 basic_mcs[MCSSET_LEN];	/* 802.11N BSS required MCS set */
 
-	u16 ie_offset;	/* offset at which IEs start, from beginning */
-	u32 ie_length;	/* byte length of Information Elements */
-	s16 SNR;		/* average SNR of during frame reception */
+	__le16 ie_offset;	/* offset at which IEs start, from beginning */
+	__le32 ie_length;	/* byte length of Information Elements */
+	__le16 SNR;		/* average SNR of during frame reception */
 	/* Add new fields here */
 	/* variable length Information Elements */
 };
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 4f3e8b8..9e07f77 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1955,7 +1955,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_priv *cfg_priv,
 	notify_capability = le16_to_cpu(bi->capability);
 	notify_interval = le16_to_cpu(bi->beacon_period);
 	notify_ie = (u8 *)bi + le16_to_cpu(bi->ie_offset);
-	notify_ielen = le16_to_cpu(bi->ie_length);
+	notify_ielen = le32_to_cpu(bi->ie_length);
 	notify_signal = (s16)le16_to_cpu(bi->RSSI) * 100;
 
 	WL_CONN("bssid: %2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
@@ -2054,7 +2054,7 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_priv *cfg_priv,
 	notify_capability = le16_to_cpu(bi->capability);
 	notify_interval = le16_to_cpu(bi->beacon_period);
 	notify_ie = (u8 *)bi + le16_to_cpu(bi->ie_offset);
-	notify_ielen = le16_to_cpu(bi->ie_length);
+	notify_ielen = le32_to_cpu(bi->ie_length);
 	notify_signal = (s16)le16_to_cpu(bi->RSSI) * 100;
 
 	WL_CONN("channel: %d(%d)\n", channel, freq);
@@ -2111,9 +2111,9 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
 	if (unlikely(err))
 		goto update_bss_info_out;
 
-	ie = ((u8 *)bi) + bi->ie_offset;
-	ie_len = bi->ie_length;
-	beacon_interval = cpu_to_le16(bi->beacon_period);
+	ie = ((u8 *)bi) + le16_to_cpu(bi->ie_offset);
+	ie_len = le32_to_cpu(bi->ie_length);
+	beacon_interval = le16_to_cpu(bi->beacon_period);
 
 	tim = brcmu_parse_tlvs(ie, ie_len, WLAN_EID_TIM);
 	if (tim)
-- 
1.7.1


