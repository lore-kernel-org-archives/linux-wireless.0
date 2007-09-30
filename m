Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:21290 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbXI3SjG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:39:06 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 04/26] at76_usb: Don't clean priv->mib_buf,  just clean data explicitly if needed
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:39:04 -0400
Message-ID: <20070930183904.23921.77202.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

priv->mib_buf.reserved is 0 when priv is allocated, and stays 0.  When
setting ibss_change, set data[0] to 0.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 9044f3d..715b787 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -846,11 +846,9 @@ static int at76_set_pm_mode(struct at76_priv *priv)
 {
 	int ret = 0;
 
-	memset(&priv->mib_buf, 0, sizeof(struct set_mib_buffer));
 	priv->mib_buf.type = MIB_MAC_MGMT;
 	priv->mib_buf.size = 1;
 	priv->mib_buf.index = offsetof(struct mib_mac_mgmt, power_mgmt_mode);
-
 	priv->mib_buf.data[0] = priv->pm_mode;
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
@@ -866,11 +864,9 @@ static int at76_set_associd(struct at76_priv *priv, u16 id)
 {
 	int ret = 0;
 
-	memset(&priv->mib_buf, 0, sizeof(struct set_mib_buffer));
 	priv->mib_buf.type = MIB_MAC_MGMT;
 	priv->mib_buf.size = 2;
 	priv->mib_buf.index = offsetof(struct mib_mac_mgmt, station_id);
-
 	*(__le16 *)priv->mib_buf.data = cpu_to_le16(id);
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
@@ -886,11 +882,9 @@ static int at76_set_listen_interval(struct at76_priv *priv, u16 interval)
 {
 	int ret = 0;
 
-	memset(&priv->mib_buf, 0, sizeof(struct set_mib_buffer));
 	priv->mib_buf.type = MIB_MAC;
 	priv->mib_buf.size = 2;
 	priv->mib_buf.index = offsetof(struct mib_mac, listen_interval);
-
 	*(__le16 *)priv->mib_buf.data = cpu_to_le16(interval);
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
@@ -905,11 +899,11 @@ static int at76_set_preamble(struct at76_priv *priv, u8 type)
 {
 	int ret = 0;
 
-	memset(&priv->mib_buf, 0, sizeof(struct set_mib_buffer));
 	priv->mib_buf.type = MIB_LOCAL;
 	priv->mib_buf.size = 1;
 	priv->mib_buf.index = offsetof(struct mib_local, preamble_type);
 	priv->mib_buf.data[0] = type;
+
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
 		err("%s: set_mib (preamble) failed: %d", priv->netdev->name,
@@ -922,11 +916,11 @@ static int at76_set_frag(struct at76_priv *priv, u16 size)
 {
 	int ret = 0;
 
-	memset(&priv->mib_buf, 0, sizeof(struct set_mib_buffer));
 	priv->mib_buf.type = MIB_MAC;
 	priv->mib_buf.size = 2;
 	priv->mib_buf.index = offsetof(struct mib_mac, frag_threshold);
 	*(__le16 *)priv->mib_buf.data = cpu_to_le16(size);
+
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
 		err("%s: set_mib (frag threshold) failed: %d",
@@ -939,11 +933,11 @@ static int at76_set_rts(struct at76_priv *priv, u16 size)
 {
 	int ret = 0;
 
-	memset(&priv->mib_buf, 0, sizeof(struct set_mib_buffer));
 	priv->mib_buf.type = MIB_MAC;
 	priv->mib_buf.size = 2;
 	priv->mib_buf.index = offsetof(struct mib_mac, rts_threshold);
 	*(__le16 *)priv->mib_buf.data = cpu_to_le16(size);
+
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
 		err("%s: set_mib (rts) failed: %d", priv->netdev->name, ret);
@@ -955,11 +949,11 @@ static int at76_set_autorate_fallback(struct at76_priv *priv, int onoff)
 {
 	int ret = 0;
 
-	memset(&priv->mib_buf, 0, sizeof(struct set_mib_buffer));
 	priv->mib_buf.type = MIB_LOCAL;
 	priv->mib_buf.size = 1;
 	priv->mib_buf.index = offsetof(struct mib_local, txautorate_fallback);
 	priv->mib_buf.data[0] = onoff;
+
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
 		err("%s: set_mib (autorate fallback) failed: %d",
@@ -986,11 +980,11 @@ static int at76_add_mac_address(struct at76_priv *priv, void *addr)
 {
 	int ret = 0;
 
-	memset(&priv->mib_buf, 0, sizeof(struct set_mib_buffer));
 	priv->mib_buf.type = MIB_MAC_ADDR;
 	priv->mib_buf.size = ETH_ALEN;
 	priv->mib_buf.index = offsetof(struct mib_mac_addr, mac_addr);
 	memcpy(priv->mib_buf.data, addr, ETH_ALEN);
+
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
 		err("%s: set_mib (MAC_ADDR, mac_addr) failed: %d",
@@ -1006,24 +1000,24 @@ static int at76_set_group_address(struct at76_priv *priv, u8 *addr, int n)
 {
 	int ret = 0;
 
-	memset(&priv->mib_buf, 0, sizeof(struct set_mib_buffer));
 	priv->mib_buf.type = MIB_MAC_ADDR;
 	priv->mib_buf.size = ETH_ALEN;
 	priv->mib_buf.index =
 	    offsetof(struct mib_mac_addr, group_addr) + n * ETH_ALEN;
 	memcpy(priv->mib_buf.data, addr, ETH_ALEN);
+
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
 		err("%s: set_mib (MIB_MAC_ADDR, group_addr) failed: %d",
 		    priv->netdev->name, ret);
 
 	/* I do not know anything about the group_addr_status field... (oku) */
-	memset(&priv->mib_buf, 0, sizeof(struct set_mib_buffer));
 	priv->mib_buf.type = MIB_MAC_ADDR;
 	priv->mib_buf.size = 1;
 	priv->mib_buf.index =
 	    offsetof(struct mib_mac_addr, group_addr_status) + n;
 	priv->mib_buf.data[0] = 1;
+
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
 		err("%s: set_mib (MIB_MAC_ADDR, group_addr_status) failed: %d",
@@ -1417,10 +1411,11 @@ static int at76_start_ibss(struct at76_priv *priv)
 		return ret;
 
 	/* not sure what this is good for ??? */
-	memset(&priv->mib_buf, 0, sizeof(struct set_mib_buffer));
 	priv->mib_buf.type = MIB_MAC_MGMT;
 	priv->mib_buf.size = 1;
 	priv->mib_buf.index = offsetof(struct mib_mac_mgmt, ibss_change);
+	priv->mib_buf.data[0] = 0;
+
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0) {
 		err("%s: set_mib (ibss change ok) failed: %d",
@@ -3857,10 +3852,11 @@ static void at76_work_new_bss(struct work_struct *work)
 
 	at76_iwevent_bss_connect(priv->netdev, priv->bssid);
 
-	memset(&priv->mib_buf, 0, sizeof(struct set_mib_buffer));
 	priv->mib_buf.type = MIB_MAC_MGMT;
 	priv->mib_buf.size = 1;
 	priv->mib_buf.index = offsetof(struct mib_mac_mgmt, ibss_change);
+	priv->mib_buf.data[0] = 0;
+
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
 		err("%s: set_mib (ibss change ok) failed: %d", netdev->name,
@@ -4060,11 +4056,11 @@ static void at76_work_set_promisc(struct work_struct *work)
 
 	mutex_lock(&priv->mtx);
 
-	memset(&priv->mib_buf, 0, sizeof(struct set_mib_buffer));
 	priv->mib_buf.type = MIB_LOCAL;
 	priv->mib_buf.size = 1;
 	priv->mib_buf.index = offsetof(struct mib_local, promiscuous_mode);
 	priv->mib_buf.data[0] = priv->promisc ? 1 : 0;
+
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
 		err("%s: set_mib (promiscuous_mode) failed: %d",
