Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:40681 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaJ1N6J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 09:58:09 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 03/16] brcmfmac: Add wowl patterns support.
Date: Tue, 28 Oct 2014 14:56:06 +0100
Message-ID: <1414504579-12562-4-git-send-email-arend@broadcom.com> (sfid-20141028_145814_002470_37015331)
In-Reply-To: <1414504579-12562-1-git-send-email-arend@broadcom.com>
References: <1414504579-12562-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   | 89 +++++++++++++++-------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 66 ++++++++++++++--
 2 files changed, 120 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
index 5ff5cd0..ba64b29 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
@@ -55,59 +55,63 @@
 
 /* WOWL bits */
 /* Wakeup on Magic packet: */
-#define WL_WOWL_MAGIC			(1 << 0)
+#define BRCMF_WOWL_MAGIC		(1 << 0)
 /* Wakeup on Netpattern */
-#define WL_WOWL_NET			(1 << 1)
+#define BRCMF_WOWL_NET			(1 << 1)
 /* Wakeup on loss-of-link due to Disassoc/Deauth: */
-#define WL_WOWL_DIS			(1 << 2)
+#define BRCMF_WOWL_DIS			(1 << 2)
 /* Wakeup on retrograde TSF: */
-#define WL_WOWL_RETR			(1 << 3)
+#define BRCMF_WOWL_RETR			(1 << 3)
 /* Wakeup on loss of beacon: */
-#define WL_WOWL_BCN			(1 << 4)
+#define BRCMF_WOWL_BCN			(1 << 4)
 /* Wakeup after test: */
-#define WL_WOWL_TST			(1 << 5)
+#define BRCMF_WOWL_TST			(1 << 5)
 /* Wakeup after PTK refresh: */
-#define WL_WOWL_M1			(1 << 6)
+#define BRCMF_WOWL_M1			(1 << 6)
 /* Wakeup after receipt of EAP-Identity Req: */
-#define WL_WOWL_EAPID			(1 << 7)
+#define BRCMF_WOWL_EAPID		(1 << 7)
 /* Wakeind via PME(0) or GPIO(1): */
-#define WL_WOWL_PME_GPIO		(1 << 8)
+#define BRCMF_WOWL_PME_GPIO		(1 << 8)
 /* need tkip phase 1 key to be updated by the driver: */
-#define WL_WOWL_NEEDTKIP1		(1 << 9)
+#define BRCMF_WOWL_NEEDTKIP1		(1 << 9)
 /* enable wakeup if GTK fails: */
-#define WL_WOWL_GTK_FAILURE		(1 << 10)
+#define BRCMF_WOWL_GTK_FAILURE		(1 << 10)
 /* support extended magic packets: */
-#define WL_WOWL_EXTMAGPAT		(1 << 11)
+#define BRCMF_WOWL_EXTMAGPAT		(1 << 11)
 /* support ARP/NS/keepalive offloading: */
-#define WL_WOWL_ARPOFFLOAD		(1 << 12)
+#define BRCMF_WOWL_ARPOFFLOAD		(1 << 12)
 /* read protocol version for EAPOL frames: */
-#define WL_WOWL_WPA2			(1 << 13)
+#define BRCMF_WOWL_WPA2			(1 << 13)
 /* If the bit is set, use key rotaton: */
-#define WL_WOWL_KEYROT			(1 << 14)
+#define BRCMF_WOWL_KEYROT		(1 << 14)
 /* If the bit is set, frm received was bcast frame: */
-#define WL_WOWL_BCAST			(1 << 15)
+#define BRCMF_WOWL_BCAST		(1 << 15)
 /* If the bit is set, scan offload is enabled: */
-#define WL_WOWL_SCANOL			(1 << 16)
+#define BRCMF_WOWL_SCANOL		(1 << 16)
 /* Wakeup on tcpkeep alive timeout: */
-#define WL_WOWL_TCPKEEP_TIME		(1 << 17)
+#define BRCMF_WOWL_TCPKEEP_TIME		(1 << 17)
 /* Wakeup on mDNS Conflict Resolution: */
-#define WL_WOWL_MDNS_CONFLICT		(1 << 18)
+#define BRCMF_WOWL_MDNS_CONFLICT	(1 << 18)
 /* Wakeup on mDNS Service Connect: */
-#define WL_WOWL_MDNS_SERVICE		(1 << 19)
+#define BRCMF_WOWL_MDNS_SERVICE		(1 << 19)
 /* tcp keepalive got data: */
-#define WL_WOWL_TCPKEEP_DATA		(1 << 20)
+#define BRCMF_WOWL_TCPKEEP_DATA		(1 << 20)
 /* Firmware died in wowl mode: */
-#define WL_WOWL_FW_HALT			(1 << 21)
+#define BRCMF_WOWL_FW_HALT		(1 << 21)
 /* Enable detection of radio button changes: */
-#define WL_WOWL_ENAB_HWRADIO		(1 << 22)
+#define BRCMF_WOWL_ENAB_HWRADIO		(1 << 22)
 /* Offloads detected MIC failure(s): */
-#define WL_WOWL_MIC_FAIL		(1 << 23)
+#define BRCMF_WOWL_MIC_FAIL		(1 << 23)
 /* Wakeup in Unassociated state (Net/Magic Pattern): */
-#define WL_WOWL_UNASSOC			(1 << 24)
+#define BRCMF_WOWL_UNASSOC		(1 << 24)
 /* Wakeup if received matched secured pattern: */
-#define WL_WOWL_SECURE			(1 << 25)
+#define BRCMF_WOWL_SECURE		(1 << 25)
 /* Link Down indication in WoWL mode: */
-#define WL_WOWL_LINKDOWN		(1 << 31)
+#define BRCMF_WOWL_LINKDOWN		(1 << 31)
+
+#define BRCMF_WOWL_MAXPATTERNS		8
+#define BRCMF_WOWL_MAXPATTERNSIZE	128
+
 
 /* join preference types for join_pref iovar */
 enum brcmf_join_pref_types {
@@ -124,6 +128,12 @@ enum brcmf_fil_p2p_if_types {
 	BRCMF_FIL_P2P_IF_DEV,
 };
 
+enum brcmf_wowl_pattern_type {
+	BRCMF_WOWL_PATTERN_TYPE_BITMAP = 0,
+	BRCMF_WOWL_PATTERN_TYPE_ARP,
+	BRCMF_WOWL_PATTERN_TYPE_NA
+};
+
 struct brcmf_fil_p2p_if_le {
 	u8 addr[ETH_ALEN];
 	__le16 type;
@@ -484,4 +494,29 @@ struct brcmf_rx_mgmt_data {
 	__be32	rate;
 };
 
+/**
+ * struct brcmf_fil_wowl_pattern_le - wowl pattern configuration struct.
+ *
+ * @cmd: "add", "del" or "clr".
+ * @masksize: Size of the mask in #of bytes
+ * @offset: Pattern byte offset in packet
+ * @patternoffset: Offset of start of pattern. Starting from field masksize.
+ * @patternsize: Size of the pattern itself in #of bytes
+ * @id: id
+ * @reasonsize: Size of the wakeup reason code
+ * @type: Type of pattern (enum brcmf_wowl_pattern_type)
+ */
+struct brcmf_fil_wowl_pattern_le {
+	u8	cmd[4];
+	__le32	masksize;
+	__le32	offset;
+	__le32	patternoffset;
+	__le32	patternsize;
+	__le32	id;
+	__le32	reasonsize;
+	__le32	type;
+	/* u8 mask[] - Mask follows the structure above */
+	/* u8 pattern[] - Pattern follows the mask is at 'patternoffset' */
+};
+
 #endif /* FWIL_TYPES_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 28fa25b..fcadbe3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2779,6 +2779,44 @@ static __always_inline void brcmf_delay(u32 ms)
 	}
 }
 
+static s32 brcmf_config_wowl_pattern(struct brcmf_if *ifp, u8 cmd[4],
+				     u8 *pattern, u32 patternsize, u8 *mask,
+				     u32 packet_offset)
+{
+	struct brcmf_fil_wowl_pattern_le *filter;
+	u32 masksize;
+	u32 patternoffset;
+	u8 *buf;
+	u32 bufsize;
+	s32 ret;
+
+	masksize = (patternsize + 7) / 8;
+	patternoffset = sizeof(*filter) - sizeof(filter->cmd) + masksize;
+
+	bufsize = sizeof(*filter) + patternsize + masksize;
+	buf = kzalloc(bufsize, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	filter = (struct brcmf_fil_wowl_pattern_le *)buf;
+
+	memcpy(filter->cmd, cmd, 4);
+	filter->masksize = cpu_to_le32(masksize);
+	filter->offset = cpu_to_le32(packet_offset);
+	filter->patternoffset = cpu_to_le32(patternoffset);
+	filter->patternsize = cpu_to_le32(patternsize);
+	filter->type = cpu_to_le32(BRCMF_WOWL_PATTERN_TYPE_BITMAP);
+
+	if ((mask) && (masksize))
+		memcpy(buf + sizeof(*filter), mask, masksize);
+	if ((pattern) && (patternsize))
+		memcpy(buf + sizeof(*filter) + masksize, pattern, patternsize);
+
+	ret = brcmf_fil_iovar_data_set(ifp, "wowl_pattern", buf, bufsize);
+
+	kfree(buf);
+	return ret;
+}
+
 static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
@@ -2788,10 +2826,11 @@ static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (cfg->wowl_enabled) {
+		brcmf_configure_arp_offload(ifp, true);
 		brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM,
 				      cfg->pre_wowl_pmmode);
-		brcmf_fil_iovar_data_set(ifp, "wowl_pattern", "clr", 4);
 		brcmf_fil_iovar_int_set(ifp, "wowl_clear", 0);
+		brcmf_config_wowl_pattern(ifp, "clr", NULL, 0, NULL, 0);
 		cfg->wowl_enabled = false;
 	}
 	return 0;
@@ -2802,21 +2841,29 @@ static void brcmf_configure_wowl(struct brcmf_cfg80211_info *cfg,
 				 struct cfg80211_wowlan *wowl)
 {
 	u32 wowl_config;
+	u32 i;
 
 	brcmf_dbg(TRACE, "Suspend, wowl config.\n");
 
+	brcmf_configure_arp_offload(ifp, false);
 	brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_PM, &cfg->pre_wowl_pmmode);
 	brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM, PM_MAX);
 
 	wowl_config = 0;
 	if (wowl->disconnect)
-		wowl_config |= WL_WOWL_DIS | WL_WOWL_BCN | WL_WOWL_RETR;
-		/* Note: if "wowl" target and not "wowlpf" then wowl_bcn_loss
-		 * should be configured. This paramater is not supported by
-		 * wowlpf.
-		 */
+		wowl_config = BRCMF_WOWL_DIS | BRCMF_WOWL_BCN | BRCMF_WOWL_RETR;
 	if (wowl->magic_pkt)
-		wowl_config |= WL_WOWL_MAGIC;
+		wowl_config |= BRCMF_WOWL_MAGIC;
+	if ((wowl->patterns) && (wowl->n_patterns)) {
+		wowl_config |= BRCMF_WOWL_NET;
+		for (i = 0; i < wowl->n_patterns; i++) {
+			brcmf_config_wowl_pattern(ifp, "add",
+				(u8 *)wowl->patterns[i].pattern,
+				wowl->patterns[i].pattern_len,
+				(u8 *)wowl->patterns[i].mask,
+				wowl->patterns[i].pkt_offset);
+		}
+	}
 	brcmf_fil_iovar_int_set(ifp, "wowl", wowl_config);
 	brcmf_fil_iovar_int_set(ifp, "wowl_activate", 1);
 	brcmf_bus_wowl_config(cfg->pub->bus_if, true);
@@ -5440,10 +5487,13 @@ static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
 	wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
 }
 
-
 #ifdef CONFIG_PM
 static const struct wiphy_wowlan_support brcmf_wowlan_support = {
 	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT,
+	.n_patterns = BRCMF_WOWL_MAXPATTERNS,
+	.pattern_max_len = BRCMF_WOWL_MAXPATTERNSIZE,
+	.pattern_min_len = 1,
+	.max_pkt_offset = 1500,
 };
 #endif
 
-- 
1.9.1

