Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:46556 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab0LIJb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 04:31:26 -0500
Received: by fxm18 with SMTP id 18so2118257fxm.2
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 01:31:25 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: add auto-arp support
Date: Thu,  9 Dec 2010 11:31:27 +0200
Message-Id: <1291887087-3329-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The auto-arp feature of wl12xx allows the firmware to automatically
response to arp requests asking for its ip.

in order to use it, we configure the arp response template and
enable the corresponding bit in wl1271_acx_arp_filter (along with
passing its ip)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c          |    4 +-
 drivers/net/wireless/wl12xx/acx.h          |    9 +++++-
 drivers/net/wireless/wl12xx/cmd.c          |   41 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/cmd.h          |    2 +
 drivers/net/wireless/wl12xx/init.c         |    7 +++++
 drivers/net/wireless/wl12xx/main.c         |   24 +++++++++++++---
 drivers/net/wireless/wl12xx/wl12xx_80211.h |   14 +++++++++
 7 files changed, 93 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 7cbaeb6..cc4068d 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1041,7 +1041,7 @@ out:
 	return ret;
 }
 
-int wl1271_acx_arp_ip_filter(struct wl1271 *wl, bool enable, __be32 address)
+int wl1271_acx_arp_ip_filter(struct wl1271 *wl, u8 enable, __be32 address)
 {
 	struct wl1271_acx_arp_filter *acx;
 	int ret;
@@ -1057,7 +1057,7 @@ int wl1271_acx_arp_ip_filter(struct wl1271 *wl, bool enable, __be32 address)
 	acx->version = ACX_IPV4_VERSION;
 	acx->enable = enable;
 
-	if (enable == true)
+	if (enable)
 		memcpy(acx->address, &address, ACX_IPV4_ADDR_SIZE);
 
 	ret = wl1271_cmd_configure(wl, ACX_ARP_IP_FILTER,
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 75a6306..9cbc3f4 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -868,10 +868,15 @@ struct wl1271_acx_bet_enable {
 #define ACX_IPV4_VERSION 4
 #define ACX_IPV6_VERSION 6
 #define ACX_IPV4_ADDR_SIZE 4
+
+/* bitmap of enabled arp_filter features */
+#define ACX_ARP_FILTER_ARP_FILTERING	BIT(0)
+#define ACX_ARP_FILTER_AUTO_ARP		BIT(1)
+
 struct wl1271_acx_arp_filter {
 	struct acx_header header;
 	u8 version;         /* ACX_IPV4_VERSION, ACX_IPV6_VERSION */
-	u8 enable;          /* 1 to enable ARP filtering, 0 to disable */
+	u8 enable;          /* bitmap of enabled ARP filtering features */
 	u8 padding[2];
 	u8 address[16];     /* The configured device IP address - all ARP
 			       requests directed to this IP address will pass
@@ -1168,7 +1173,7 @@ int wl1271_acx_init_mem_config(struct wl1271 *wl);
 int wl1271_acx_init_rx_interrupt(struct wl1271 *wl);
 int wl1271_acx_smart_reflex(struct wl1271 *wl);
 int wl1271_acx_bet_enable(struct wl1271 *wl, bool enable);
-int wl1271_acx_arp_ip_filter(struct wl1271 *wl, bool enable, __be32 address);
+int wl1271_acx_arp_ip_filter(struct wl1271 *wl, u8 enable, __be32 address);
 int wl1271_acx_pm_config(struct wl1271 *wl);
 int wl1271_acx_keep_alive_mode(struct wl1271 *wl, bool enable);
 int wl1271_acx_keep_alive_config(struct wl1271 *wl, u8 index, u8 tpl_valid);
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 8e438e2..0106628 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -639,6 +639,47 @@ out:
 	return skb;
 }
 
+int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, __be32 ip_addr)
+{
+	int ret;
+	struct wl12xx_arp_rsp_template tmpl;
+	struct ieee80211_hdr_3addr *hdr;
+	struct arphdr *arp_hdr;
+
+	memset(&tmpl, 0, sizeof(tmpl));
+
+	/* mac80211 header */
+	hdr = &tmpl.hdr;
+	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
+					 IEEE80211_STYPE_DATA |
+					 IEEE80211_FCTL_TODS);
+	memcpy(hdr->addr1, wl->vif->bss_conf.bssid, ETH_ALEN);
+	memcpy(hdr->addr2, wl->vif->addr, ETH_ALEN);
+	memset(hdr->addr3, 0xff, ETH_ALEN);
+
+	/* llc layer */
+	memcpy(tmpl.llc_hdr, rfc1042_header, sizeof(rfc1042_header));
+	tmpl.llc_type = htons(ETH_P_ARP);
+
+	/* arp header */
+	arp_hdr = &tmpl.arp_hdr;
+	arp_hdr->ar_hrd = htons(ARPHRD_ETHER);
+	arp_hdr->ar_pro = htons(ETH_P_IP);
+	arp_hdr->ar_hln = ETH_ALEN;
+	arp_hdr->ar_pln = 4;
+	arp_hdr->ar_op = htons(ARPOP_REPLY);
+
+	/* arp payload */
+	memcpy(tmpl.sender_hw, wl->vif->addr, ETH_ALEN);
+	tmpl.sender_ip = ip_addr;
+
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_ARP_RSP,
+				      &tmpl, sizeof(tmpl), 0,
+				      wl->basic_rate);
+
+	return ret;
+}
+
 int wl1271_build_qos_null_data(struct wl1271 *wl)
 {
 	struct ieee80211_qos_hdr template;
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 111d112..2a1d9db 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -51,6 +51,7 @@ int wl1271_cmd_build_probe_req(struct wl1271 *wl,
 			       const u8 *ie, size_t ie_len, u8 band);
 struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
 					      struct sk_buff *skb);
+int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, __be32 ip_addr);
 int wl1271_build_qos_null_data(struct wl1271 *wl);
 int wl1271_cmd_build_klv_null_data(struct wl1271 *wl);
 int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id);
@@ -124,6 +125,7 @@ enum cmd_templ {
 	CMD_TEMPL_CTS,           /*
 				  * For CTS-to-self (FastCTS) mechanism
 				  * for BT/WLAN coexistence (SoftGemini). */
+	CMD_TEMPL_ARP_RSP,
 	CMD_TEMPL_MAX = 0xff
 };
 
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 7949d34..0392e37 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -102,6 +102,13 @@ int wl1271_init_templates_config(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_ARP_RSP, NULL,
+				      sizeof
+				      (struct wl12xx_arp_rsp_template),
+				      0, WL1271_RATE_AUTOMATIC);
+	if (ret < 0)
+		return ret;
+
 	for (i = 0; i < CMD_TEMPL_KLV_IDX_MAX; i++) {
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_KLV, NULL,
 					      WL1271_CMD_TEMPL_MAX_SIZE, i,
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dc3a093..98e6b7b 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2106,10 +2106,26 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 		__be32 addr = bss_conf->arp_addr_list[0];
 		WARN_ON(wl->bss_type != BSS_TYPE_STA_BSS);
 
-		if (bss_conf->arp_addr_cnt == 1 && bss_conf->arp_filter_enabled)
-			ret = wl1271_acx_arp_ip_filter(wl, true, addr);
-		else
-			ret = wl1271_acx_arp_ip_filter(wl, false, addr);
+		if (bss_conf->arp_addr_cnt == 1 &&
+		    bss_conf->arp_filter_enabled) {
+			/*
+			 * The template should have been configured only upon
+			 * association. however, it seems that the correct ip
+			 * isn't being set (when sending), so we have to
+			 * reconfigure the template upon every ip change.
+			 */
+			ret = wl1271_cmd_build_arp_rsp(wl, addr);
+			if (ret < 0) {
+				wl1271_warning("build arp rsp failed: %d", ret);
+				goto out_sleep;
+			}
+
+			ret = wl1271_acx_arp_ip_filter(wl,
+				(ACX_ARP_FILTER_ARP_FILTERING |
+				 ACX_ARP_FILTER_AUTO_ARP),
+				addr);
+		} else
+			ret = wl1271_acx_arp_ip_filter(wl, 0, addr);
 
 		if (ret < 0)
 			goto out_sleep;
diff --git a/drivers/net/wireless/wl12xx/wl12xx_80211.h b/drivers/net/wireless/wl12xx/wl12xx_80211.h
index 1846280..8ee0d3a 100644
--- a/drivers/net/wireless/wl12xx/wl12xx_80211.h
+++ b/drivers/net/wireless/wl12xx/wl12xx_80211.h
@@ -2,6 +2,7 @@
 #define __WL12XX_80211_H__
 
 #include <linux/if_ether.h>	/* ETH_ALEN */
+#include <linux/if_arp.h>
 
 /* RATES */
 #define IEEE80211_CCK_RATE_1MB		        0x02
@@ -140,6 +141,19 @@ struct wl12xx_probe_req_template {
 	struct wl12xx_ie_rates ext_rates;
 } __packed;
 
+struct wl12xx_arp_rsp_template {
+	struct ieee80211_hdr_3addr hdr;
+
+	u8 llc_hdr[sizeof(rfc1042_header)];
+	u16 llc_type;
+
+	struct arphdr arp_hdr;
+	u8 sender_hw[ETH_ALEN];
+	u32 sender_ip;
+	u8 target_hw[ETH_ALEN];
+	u32 target_ip;
+} __packed;
+
 
 struct wl12xx_probe_resp_template {
 	struct ieee80211_header header;
-- 
1.7.0.4

