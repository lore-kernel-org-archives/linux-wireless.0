Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:60324 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab1A3TLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 14:11:15 -0500
Message-ID: <4D45B7C6.4030709@davizone.at>
Date: Sun, 30 Jan 2011 20:11:02 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 08/18] wl1251: implement hardware ARP filtering
References: <4D45A5C7.8000000@davizone.at>
In-Reply-To: <4D45A5C7.8000000@davizone.at>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update hardware ARP filter configuration on BSS_CHANGED_ARP_FILTER
notification from mac80211.
Ported from wl1271 driver.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
Sorry for the partly broken patches, I thought I configured my client the
right way. I tried to stop the mails at my mailserver, but it was mostly
already too late.
---
 drivers/net/wireless/wl1251/acx.c  |   31 +++++++++++++++++++++++++++++++
 drivers/net/wireless/wl1251/acx.h  |   15 +++++++++++++++
 drivers/net/wireless/wl1251/main.c |   13 +++++++++++++
 3 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl1251/acx.c b/drivers/net/wireless/wl1251/acx.c
index d43695a..0a1c22a 100644
--- a/drivers/net/wireless/wl1251/acx.c
+++ b/drivers/net/wireless/wl1251/acx.c
@@ -1066,6 +1066,37 @@ out:
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
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->version = ACX_IPV4_VERSION;
+	acx->enable = enable;
+
+	if (enable == true)
+		memcpy(acx->address, &address, ACX_IPV4_ADDR_SIZE);
+
+	ret = wl1251_cmd_configure(wl, ACX_ARP_IP_FILTER,
+				   acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1251_warning("failed to set arp ip filter: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
 int wl1251_acx_ac_cfg(struct wl1251 *wl, u8 ac, u8 cw_min, u16 cw_max,
 		      u8 aifs, u16 txop)
 {
diff --git a/drivers/net/wireless/wl1251/acx.h b/drivers/net/wireless/wl1251/acx.h
index 99ea80e..9958676 100644
--- a/drivers/net/wireless/wl1251/acx.h
+++ b/drivers/net/wireless/wl1251/acx.h
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
+} __packed;
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
diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index c0a7fd5..387878f 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -1051,6 +1051,19 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
+	if (changed & BSS_CHANGED_ARP_FILTER) {
+		__be32 addr = bss_conf->arp_addr_list[0];
+		WARN_ON(wl->bss_type != BSS_TYPE_STA_BSS);
+
+		if (bss_conf->arp_addr_cnt == 1 && bss_conf->arp_filter_enabled)
+			ret = wl1251_acx_arp_ip_filter(wl, true, addr);
+		else
+			ret = wl1251_acx_arp_ip_filter(wl, false, addr);
+
+		if (ret < 0)
+			goto out_sleep;
+	}
+
 	if (changed & BSS_CHANGED_BEACON) {
 		beacon = ieee80211_beacon_get(hw, vif);
 		ret = wl1251_cmd_template_set(wl, CMD_BEACON, beacon->data,
-- 
1.7.0.4


