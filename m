Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:59920 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbZG3QvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 12:51:09 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 06/10] rndis_wlan: add rndis_set/query_oid debugging
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Thu, 30 Jul 2009 19:41:47 +0300
Message-ID: <20090730164147.28317.76990.stgit@fate.lan>
In-Reply-To: <20090730164120.28317.53313.stgit@fate.lan>
References: <20090730164120.28317.53313.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add better debugging for failed OID queries.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   86 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 974f724..f6dcbb1 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -100,7 +100,6 @@ MODULE_PARM_DESC(workaround_interval,
 #define OID_GEN_RCV_ERROR			cpu_to_le32(0x00020104)
 #define OID_GEN_RCV_NO_BUFFER			cpu_to_le32(0x00020105)
 
-#define OID_802_3_PERMANENT_ADDRESS		cpu_to_le32(0x01010101)
 #define OID_802_3_CURRENT_ADDRESS		cpu_to_le32(0x01010102)
 #define OID_802_3_MULTICAST_LIST		cpu_to_le32(0x01010103)
 #define OID_802_3_MAXIMUM_LIST_SIZE		cpu_to_le32(0x01010104)
@@ -478,6 +477,68 @@ static u32 get_bcm4320_power_dbm(struct rndis_wlan_private *priv)
 }
 
 
+#ifdef DEBUG
+static const char *oid_to_string(__le32 oid)
+{
+	switch (oid) {
+#define OID_STR(oid) case oid: return(#oid)
+		/* from rndis_host.h */
+		OID_STR(OID_802_3_PERMANENT_ADDRESS);
+		OID_STR(OID_GEN_MAXIMUM_FRAME_SIZE);
+		OID_STR(OID_GEN_CURRENT_PACKET_FILTER);
+		OID_STR(OID_GEN_PHYSICAL_MEDIUM);
+
+		/* from rndis_wlan.c */
+		OID_STR(OID_GEN_LINK_SPEED);
+		OID_STR(OID_GEN_RNDIS_CONFIG_PARAMETER);
+
+		OID_STR(OID_GEN_XMIT_OK);
+		OID_STR(OID_GEN_RCV_OK);
+		OID_STR(OID_GEN_XMIT_ERROR);
+		OID_STR(OID_GEN_RCV_ERROR);
+		OID_STR(OID_GEN_RCV_NO_BUFFER);
+
+		OID_STR(OID_802_3_CURRENT_ADDRESS);
+		OID_STR(OID_802_3_MULTICAST_LIST);
+		OID_STR(OID_802_3_MAXIMUM_LIST_SIZE);
+
+		OID_STR(OID_802_11_BSSID);
+		OID_STR(OID_802_11_SSID);
+		OID_STR(OID_802_11_INFRASTRUCTURE_MODE);
+		OID_STR(OID_802_11_ADD_WEP);
+		OID_STR(OID_802_11_REMOVE_WEP);
+		OID_STR(OID_802_11_DISASSOCIATE);
+		OID_STR(OID_802_11_AUTHENTICATION_MODE);
+		OID_STR(OID_802_11_PRIVACY_FILTER);
+		OID_STR(OID_802_11_BSSID_LIST_SCAN);
+		OID_STR(OID_802_11_ENCRYPTION_STATUS);
+		OID_STR(OID_802_11_ADD_KEY);
+		OID_STR(OID_802_11_REMOVE_KEY);
+		OID_STR(OID_802_11_ASSOCIATION_INFORMATION);
+		OID_STR(OID_802_11_PMKID);
+		OID_STR(OID_802_11_NETWORK_TYPES_SUPPORTED);
+		OID_STR(OID_802_11_NETWORK_TYPE_IN_USE);
+		OID_STR(OID_802_11_TX_POWER_LEVEL);
+		OID_STR(OID_802_11_RSSI);
+		OID_STR(OID_802_11_RSSI_TRIGGER);
+		OID_STR(OID_802_11_FRAGMENTATION_THRESHOLD);
+		OID_STR(OID_802_11_RTS_THRESHOLD);
+		OID_STR(OID_802_11_SUPPORTED_RATES);
+		OID_STR(OID_802_11_CONFIGURATION);
+		OID_STR(OID_802_11_BSSID_LIST);
+#undef OID_STR
+	}
+
+	return "?";
+}
+#else
+static const char *oid_to_string(__le32 oid)
+{
+	return "?";
+}
+#endif
+
+
 /* translate error code */
 static int rndis_error_status(__le32 rndis_status)
 {
@@ -533,11 +594,21 @@ static int rndis_query_oid(struct usbnet *dev, __le32 oid, void *data, int *len)
 	u.get->oid = oid;
 
 	ret = rndis_command(dev, u.header, buflen);
+	if (ret < 0)
+		devdbg(dev, "rndis_query_oid(%s): rndis_command() failed, %d "
+			"(%08x)", oid_to_string(oid), ret,
+			le32_to_cpu(u.get_c->status));
+
 	if (ret == 0) {
 		ret = le32_to_cpu(u.get_c->len);
 		*len = (*len > ret) ? ret : *len;
 		memcpy(data, u.buf + le32_to_cpu(u.get_c->offset) + 8, *len);
 		ret = rndis_error_status(u.get_c->status);
+
+		if (ret < 0)
+			devdbg(dev, "rndis_query_oid(%s): device returned "
+				"error,  0x%08x (%d)", oid_to_string(oid),
+				le32_to_cpu(u.get_c->status), ret);
 	}
 
 	mutex_unlock(&priv->command_lock);
@@ -583,9 +654,20 @@ static int rndis_set_oid(struct usbnet *dev, __le32 oid, void *data, int len)
 	memcpy(u.buf + sizeof(*u.set), data, len);
 
 	ret = rndis_command(dev, u.header, buflen);
-	if (ret == 0)
+	if (ret < 0)
+		devdbg(dev, "rndis_set_oid(%s): rndis_command() failed, %d "
+			"(%08x)", oid_to_string(oid), ret,
+			le32_to_cpu(u.set_c->status));
+
+	if (ret == 0) {
 		ret = rndis_error_status(u.set_c->status);
 
+		if (ret < 0)
+			devdbg(dev, "rndis_set_oid(%s): device returned error, "
+				"0x%08x (%d)", oid_to_string(oid),
+				le32_to_cpu(u.set_c->status), ret);
+	}
+
 	mutex_unlock(&priv->command_lock);
 
 	if (u.buf != priv->command_buffer)

