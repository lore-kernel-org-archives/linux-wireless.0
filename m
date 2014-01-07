Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57987 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaAGMG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 07:06:26 -0500
Date: Tue, 7 Jan 2014 13:06:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 03/13] wl1251: implement hardware ARP filtering
Message-ID: <20140107120624.GC10836@amd.pavel.ucw.cz> (sfid-20140107_130629_159502_0E787A02)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Gnedt <david.gnedt@davizone.at>

Update hardware ARP filter configuration on BSS_CHANGED_ARP_FILTER
notification from mac80211.
Ported from wl1271 driver.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/net/wireless/ti/wl1251/acx.c  |   26 ++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl1251/acx.h  |   15 +++++++++++++++
 drivers/net/wireless/ti/wl1251/main.c |   12 ++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/drivers/net/wireless/ti/wl1251/acx.c b/drivers/net/wireless/ti/wl1251/acx.c
index cce50e2..5f4a552 100644
--- a/drivers/net/wireless/ti/wl1251/acx.c
+++ b/drivers/net/wireless/ti/wl1251/acx.c
@@ -1062,6 +1062,32 @@ out:
 	return ret;
 }
 
+int wl1251_acx_arp_ip_filter(struct wl1251 *wl, bool enable, __be32 address)
+{
+	struct wl1251_acx_arp_filter *acx;
+	int ret;
+
+	wl1251_debug(DEBUG_ACX, "acx arp ip filter, enable: %d", enable);
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx)
+		return -ENOMEM;
+
+	acx->version = ACX_IPV4_VERSION;
+	acx->enable = enable;
+
+	if (enable)
+		memcpy(acx->address, &address, ACX_IPV4_ADDR_SIZE);
+
+	ret = wl1251_cmd_configure(wl, ACX_ARP_IP_FILTER,
+				   acx, sizeof(*acx));
+	if (ret < 0)
+		wl1251_warning("failed to set arp ip filter: %d", ret);
+
+	kfree(acx);
+	return ret;
+}
+
 int wl1251_acx_ac_cfg(struct wl1251 *wl, u8 ac, u8 cw_min, u16 cw_max,
 		      u8 aifs, u16 txop)
 {
diff --git a/drivers/net/wireless/ti/wl1251/acx.h b/drivers/net/wireless/ti/wl1251/acx.h
index 99ea80e..4444cd0 100644
--- a/drivers/net/wireless/ti/wl1251/acx.h
+++ b/drivers/net/wireless/ti/wl1251/acx.h
@@ -1233,6 +1233,20 @@ struct wl1251_acx_bet_enable {
 	u8 padding[2];
 } __packed;
 
+#define ACX_IPV4_VERSION 4
+#define ACX_IPV6_VERSION 6
+#define ACX_IPV4_ADDR_SIZE 4
+struct wl1251_acx_arp_filter {
+	struct acx_header header;
+	u8 version;	/* The IP version: 4 - IPv4, 6 - IPv6.*/
+	u8 enable;	/* 1 - ARP filtering is enabled, 0 - disabled */
+	u8 padding[2];
+	u8 address[16];	/* The IP address used to filter ARP packets.
+			   ARP packets that do not match this address are
+			   dropped. When the IP Version is 4, the last 12
+			   bytes of the the address are ignored. */
+} __attribute__((packed));
+
 struct wl1251_acx_ac_cfg {
 	struct acx_header header;
 
@@ -1475,6 +1489,7 @@ int wl1251_acx_mem_cfg(struct wl1251 *wl);
 int wl1251_acx_wr_tbtt_and_dtim(struct wl1251 *wl, u16 tbtt, u8 dtim);
 int wl1251_acx_bet_enable(struct wl1251 *wl, enum wl1251_acx_bet_mode mode,
 			  u8 max_consecutive);
+int wl1251_acx_arp_ip_filter(struct wl1251 *wl, bool enable, __be32 address);
 int wl1251_acx_ac_cfg(struct wl1251 *wl, u8 ac, u8 cw_min, u16 cw_max,
 		      u8 aifs, u16 txop);
 int wl1251_acx_tid_cfg(struct wl1251 *wl, u8 queue,
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 46a2494..0e27f1f 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -980,6 +980,7 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct wl1251 *wl = hw->priv;
 	struct sk_buff *beacon, *skb;
+	bool enable;
 	int ret;
 
 	wl1251_debug(DEBUG_MAC80211, "mac80211 bss info changed");
@@ -1078,6 +1079,17 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
+	if (changed & BSS_CHANGED_ARP_FILTER) {
+		__be32 addr = bss_conf->arp_addr_list[0];
+		WARN_ON(wl->bss_type != BSS_TYPE_STA_BSS);
+
+		enable = bss_conf->arp_addr_cnt == 1 && bss_conf->assoc;
+		wl1251_acx_arp_ip_filter(wl, enable, addr);
+
+		if (ret < 0)
+			goto out_sleep;
+	}
+
 	if (changed & BSS_CHANGED_BEACON) {
 		beacon = ieee80211_beacon_get(hw, vif);
 		if (!beacon)
