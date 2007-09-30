Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:21290 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbXI3SjM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:39:12 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 05/26] at76_usb: No need to reserve 72 bytes in set_mib_buffer  - we only need 6
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:39:11 -0400
Message-ID: <20070930183910.23921.62920.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use union for data in set_mib_buffer to guarantee minimally needed
buffer length.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   26 +++++++++++++-------------
 drivers/net/wireless/at76_usb.h |    6 +++++-
 2 files changed, 18 insertions(+), 14 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 715b787..ca8157a 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -849,7 +849,7 @@ static int at76_set_pm_mode(struct at76_priv *priv)
 	priv->mib_buf.type = MIB_MAC_MGMT;
 	priv->mib_buf.size = 1;
 	priv->mib_buf.index = offsetof(struct mib_mac_mgmt, power_mgmt_mode);
-	priv->mib_buf.data[0] = priv->pm_mode;
+	priv->mib_buf.data.byte = priv->pm_mode;
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
@@ -867,7 +867,7 @@ static int at76_set_associd(struct at76_priv *priv, u16 id)
 	priv->mib_buf.type = MIB_MAC_MGMT;
 	priv->mib_buf.size = 2;
 	priv->mib_buf.index = offsetof(struct mib_mac_mgmt, station_id);
-	*(__le16 *)priv->mib_buf.data = cpu_to_le16(id);
+	priv->mib_buf.data.word = cpu_to_le16(id);
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
@@ -885,7 +885,7 @@ static int at76_set_listen_interval(struct at76_priv *priv, u16 interval)
 	priv->mib_buf.type = MIB_MAC;
 	priv->mib_buf.size = 2;
 	priv->mib_buf.index = offsetof(struct mib_mac, listen_interval);
-	*(__le16 *)priv->mib_buf.data = cpu_to_le16(interval);
+	priv->mib_buf.data.word = cpu_to_le16(interval);
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
@@ -902,7 +902,7 @@ static int at76_set_preamble(struct at76_priv *priv, u8 type)
 	priv->mib_buf.type = MIB_LOCAL;
 	priv->mib_buf.size = 1;
 	priv->mib_buf.index = offsetof(struct mib_local, preamble_type);
-	priv->mib_buf.data[0] = type;
+	priv->mib_buf.data.byte = type;
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
@@ -919,7 +919,7 @@ static int at76_set_frag(struct at76_priv *priv, u16 size)
 	priv->mib_buf.type = MIB_MAC;
 	priv->mib_buf.size = 2;
 	priv->mib_buf.index = offsetof(struct mib_mac, frag_threshold);
-	*(__le16 *)priv->mib_buf.data = cpu_to_le16(size);
+	priv->mib_buf.data.word = cpu_to_le16(size);
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
@@ -936,7 +936,7 @@ static int at76_set_rts(struct at76_priv *priv, u16 size)
 	priv->mib_buf.type = MIB_MAC;
 	priv->mib_buf.size = 2;
 	priv->mib_buf.index = offsetof(struct mib_mac, rts_threshold);
-	*(__le16 *)priv->mib_buf.data = cpu_to_le16(size);
+	priv->mib_buf.data.word = cpu_to_le16(size);
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
@@ -952,7 +952,7 @@ static int at76_set_autorate_fallback(struct at76_priv *priv, int onoff)
 	priv->mib_buf.type = MIB_LOCAL;
 	priv->mib_buf.size = 1;
 	priv->mib_buf.index = offsetof(struct mib_local, txautorate_fallback);
-	priv->mib_buf.data[0] = onoff;
+	priv->mib_buf.data.byte = onoff;
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
@@ -983,7 +983,7 @@ static int at76_add_mac_address(struct at76_priv *priv, void *addr)
 	priv->mib_buf.type = MIB_MAC_ADDR;
 	priv->mib_buf.size = ETH_ALEN;
 	priv->mib_buf.index = offsetof(struct mib_mac_addr, mac_addr);
-	memcpy(priv->mib_buf.data, addr, ETH_ALEN);
+	memcpy(priv->mib_buf.data.addr, addr, ETH_ALEN);
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
@@ -1004,7 +1004,7 @@ static int at76_set_group_address(struct at76_priv *priv, u8 *addr, int n)
 	priv->mib_buf.size = ETH_ALEN;
 	priv->mib_buf.index =
 	    offsetof(struct mib_mac_addr, group_addr) + n * ETH_ALEN;
-	memcpy(priv->mib_buf.data, addr, ETH_ALEN);
+	memcpy(priv->mib_buf.data.addr, addr, ETH_ALEN);
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
@@ -1016,7 +1016,7 @@ static int at76_set_group_address(struct at76_priv *priv, u8 *addr, int n)
 	priv->mib_buf.size = 1;
 	priv->mib_buf.index =
 	    offsetof(struct mib_mac_addr, group_addr_status) + n;
-	priv->mib_buf.data[0] = 1;
+	priv->mib_buf.data.byte = 1;
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
@@ -1414,7 +1414,7 @@ static int at76_start_ibss(struct at76_priv *priv)
 	priv->mib_buf.type = MIB_MAC_MGMT;
 	priv->mib_buf.size = 1;
 	priv->mib_buf.index = offsetof(struct mib_mac_mgmt, ibss_change);
-	priv->mib_buf.data[0] = 0;
+	priv->mib_buf.data.byte = 0;
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0) {
@@ -3855,7 +3855,7 @@ static void at76_work_new_bss(struct work_struct *work)
 	priv->mib_buf.type = MIB_MAC_MGMT;
 	priv->mib_buf.size = 1;
 	priv->mib_buf.index = offsetof(struct mib_mac_mgmt, ibss_change);
-	priv->mib_buf.data[0] = 0;
+	priv->mib_buf.data.byte = 0;
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
@@ -4059,7 +4059,7 @@ static void at76_work_set_promisc(struct work_struct *work)
 	priv->mib_buf.type = MIB_LOCAL;
 	priv->mib_buf.size = 1;
 	priv->mib_buf.index = offsetof(struct mib_local, promiscuous_mode);
-	priv->mib_buf.data[0] = priv->promisc ? 1 : 0;
+	priv->mib_buf.data.byte = priv->promisc ? 1 : 0;
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index 8b51f9a..4fef446 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -245,7 +245,11 @@ struct set_mib_buffer {
 	u8 size;
 	u8 index;
 	u8 reserved;
-	u8 data[72];
+	union {
+		u8 byte;
+		__le16 word;
+		u8 addr[ETH_ALEN];
+	} data;
 } __attribute__((packed));
 
 struct mib_local {
