Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:37762 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbYFLRTY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 13:19:24 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] rndis_wlan: preallocate command buffer for set/get_oid
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Thu, 12 Jun 2008 20:19:19 +0300
Message-ID: <20080612171919.15255.85549.stgit@nanoha.lan> (sfid-20080612_191928_198343_0B737C57)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reduce amount of kmalloc/kfree calls in set/get_oid by preallocating command
buffer.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   47 ++++++++++++++++++++++++++-----------
 1 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 6eb487d..a0ad8e7 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -314,6 +314,8 @@ enum wpa_key_mgmt { KEY_MGMT_802_1X, KEY_MGMT_PSK, KEY_MGMT_NONE,
 #define WORK_LINK_DOWN		(1<<1)
 #define WORK_SET_MULTICAST_LIST	(1<<2)
 
+#define COMMAND_BUFFER_SIZE	(CONTROL_BUFFER_SIZE + sizeof(struct rndis_set))
+
 /* RNDIS device private data */
 struct rndis_wext_private {
 	char name[32];
@@ -362,6 +364,8 @@ struct rndis_wext_private {
 	u8  *wpa_ie;
 	int  wpa_cipher_pair;
 	int  wpa_cipher_group;
+
+	u8 command_buffer[COMMAND_BUFFER_SIZE];
 };
 
 
@@ -428,18 +432,23 @@ static int rndis_query_oid(struct usbnet *dev, __le32 oid, void *data, int *len)
 	buflen = *len + sizeof(*u.get);
 	if (buflen < CONTROL_BUFFER_SIZE)
 		buflen = CONTROL_BUFFER_SIZE;
-	u.buf = kmalloc(buflen, GFP_KERNEL);
-	if (!u.buf)
-		return -ENOMEM;
+
+	if (buflen > COMMAND_BUFFER_SIZE) {
+		u.buf = kmalloc(buflen, GFP_KERNEL);
+		if (!u.buf)
+			return -ENOMEM;
+	} else {
+		u.buf = priv->command_buffer;
+	}
+
+	mutex_lock(&priv->command_lock);
+
 	memset(u.get, 0, sizeof *u.get);
 	u.get->msg_type = RNDIS_MSG_QUERY;
 	u.get->msg_len = ccpu2(sizeof *u.get);
 	u.get->oid = oid;
 
-	mutex_lock(&priv->command_lock);
 	ret = rndis_command(dev, u.header);
-	mutex_unlock(&priv->command_lock);
-
 	if (ret == 0) {
 		ret = le32_to_cpu(u.get_c->len);
 		*len = (*len > ret) ? ret : *len;
@@ -447,7 +456,10 @@ static int rndis_query_oid(struct usbnet *dev, __le32 oid, void *data, int *len)
 		ret = rndis_error_status(u.get_c->status);
 	}
 
-	kfree(u.buf);
+	mutex_unlock(&priv->command_lock);
+
+	if (u.buf != priv->command_buffer)
+		kfree(u.buf);
 	return ret;
 }
 
@@ -466,9 +478,16 @@ static int rndis_set_oid(struct usbnet *dev, __le32 oid, void *data, int len)
 	buflen = len + sizeof(*u.set);
 	if (buflen < CONTROL_BUFFER_SIZE)
 		buflen = CONTROL_BUFFER_SIZE;
-	u.buf = kmalloc(buflen, GFP_KERNEL);
-	if (!u.buf)
-		return -ENOMEM;
+
+	if (buflen > COMMAND_BUFFER_SIZE) {
+		u.buf = kmalloc(buflen, GFP_KERNEL);
+		if (!u.buf)
+			return -ENOMEM;
+	} else {
+		u.buf = priv->command_buffer;
+	}
+
+	mutex_lock(&priv->command_lock);
 
 	memset(u.set, 0, sizeof *u.set);
 	u.set->msg_type = RNDIS_MSG_SET;
@@ -479,14 +498,14 @@ static int rndis_set_oid(struct usbnet *dev, __le32 oid, void *data, int len)
 	u.set->handle = ccpu2(0);
 	memcpy(u.buf + sizeof(*u.set), data, len);
 
-	mutex_lock(&priv->command_lock);
 	ret = rndis_command(dev, u.header);
-	mutex_unlock(&priv->command_lock);
-
 	if (ret == 0)
 		ret = rndis_error_status(u.set_c->status);
 
-	kfree(u.buf);
+	mutex_unlock(&priv->command_lock);
+
+	if (u.buf != priv->command_buffer)
+		kfree(u.buf);
 	return ret;
 }
 

