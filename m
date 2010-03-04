Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:60285 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab0CDQ1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 11:27:04 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/4 v2] rndis_wlan: copy only useful data from rndis_command
	respond
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 04 Mar 2010 18:27:02 +0200
Message-ID: <20100304162657.2609.64867.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rndis_query_oid() uses full output buffer size to copy response buffer
from rndis_command()/device. This doesn't cause problems as response buffer
is sized based on output buffer but does copy extra unset bytes.
So change rndis_query_oid() so that only meaningful bytes are being copied.

Also in case of malfunctioning device/cable/etc returned data offset from
device might be wrong so bound check memory access correctly, so add
checks for this.

v2: fixed to use new netdev_dbg/warn/etc instead of old devdbg/warn/etc

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 9f6d6bf..a4f70de 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -704,6 +704,7 @@ static int rndis_query_oid(struct usbnet *dev, __le32 oid, void *data, int *len)
 		struct rndis_query_c	*get_c;
 	} u;
 	int ret, buflen;
+	int resplen, respoffs, copylen;
 
 	buflen = *len + sizeof(*u.get);
 	if (buflen < CONTROL_BUFFER_SIZE)
@@ -733,11 +734,34 @@ static int rndis_query_oid(struct usbnet *dev, __le32 oid, void *data, int *len)
 			   le32_to_cpu(u.get_c->status));
 
 	if (ret == 0) {
-		memcpy(data, u.buf + le32_to_cpu(u.get_c->offset) + 8, *len);
+		resplen = le32_to_cpu(u.get_c->len);
+		respoffs = le32_to_cpu(u.get_c->offset) + 8;
 
-		ret = le32_to_cpu(u.get_c->len);
-		if (ret > *len)
-			*len = ret;
+		if (respoffs > buflen) {
+			/* Device returned data offset outside buffer, error. */
+			netdev_dbg(dev->net, "%s(%s): received invalid "
+				"data offset: %d > %d\n", __func__,
+				oid_to_string(oid), respoffs, buflen);
+
+			ret = -EINVAL;
+			goto exit_unlock;
+		}
+
+		if ((resplen + respoffs) > buflen) {
+			/* Device would have returned more data if buffer would
+			 * have been big enough. Copy just the bits that we got.
+			 */
+			copylen = buflen - respoffs;
+		} else {
+			copylen = resplen;
+		}
+
+		if (copylen > *len)
+			copylen = *len;
+
+		memcpy(data, u.buf + respoffs, copylen);
+
+		*len = resplen;
 
 		ret = rndis_error_status(u.get_c->status);
 		if (ret < 0)
@@ -746,6 +770,7 @@ static int rndis_query_oid(struct usbnet *dev, __le32 oid, void *data, int *len)
 				   le32_to_cpu(u.get_c->status), ret);
 	}
 
+exit_unlock:
 	mutex_unlock(&priv->command_lock);
 
 	if (u.buf != priv->command_buffer)

