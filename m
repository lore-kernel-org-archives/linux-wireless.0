Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:46113 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451AbZH1J6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 05:58:49 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/8] rndis_wlan: ignore OID_802_11_ADD_KEY triggered media
	connect indications
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 28 Aug 2009 12:58:49 +0300
Message-ID: <20090828095849.10554.58857.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setting WPA keys with OID_802_11_ADD_KEY sometimes trigger
instant media connect indication. These indications are extranous and
should be ignored, as otherwise driver would send reassociation event to
userspace which in this case is not needed.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index f181b00..612c2c7 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -470,6 +470,7 @@ struct rndis_wlan_private {
 	int radio_on;
 	int infra_mode;
 	struct ndis_80211_ssid essid;
+	__le32 current_command_oid;
 
 	/* encryption stuff */
 	int  encr_tx_key_index;
@@ -665,7 +666,9 @@ static int rndis_query_oid(struct usbnet *dev, __le32 oid, void *data, int *len)
 	u.get->msg_len = cpu_to_le32(sizeof *u.get);
 	u.get->oid = oid;
 
+	priv->current_command_oid = oid;
 	ret = rndis_command(dev, u.header, buflen);
+	priv->current_command_oid = 0;
 	if (ret < 0)
 		devdbg(dev, "rndis_query_oid(%s): rndis_command() failed, %d "
 			"(%08x)", oid_to_string(oid), ret,
@@ -725,7 +728,9 @@ static int rndis_set_oid(struct usbnet *dev, __le32 oid, void *data, int len)
 	u.set->handle = cpu_to_le32(0);
 	memcpy(u.buf + sizeof(*u.set), data, len);
 
+	priv->current_command_oid = oid;
 	ret = rndis_command(dev, u.header, buflen);
+	priv->current_command_oid = 0;
 	if (ret < 0)
 		devdbg(dev, "rndis_set_oid(%s): rndis_command() failed, %d "
 			"(%08x)", oid_to_string(oid), ret,
@@ -760,6 +765,7 @@ static int rndis_reset(struct usbnet *usbdev)
 	memset(reset, 0, sizeof(*reset));
 	reset->msg_type = RNDIS_MSG_RESET;
 	reset->msg_len = cpu_to_le32(sizeof(*reset));
+	priv->current_command_oid = 0;
 	ret = rndis_command(usbdev, (void *)reset, CONTROL_BUFFER_SIZE);
 
 	mutex_unlock(&priv->command_lock);
@@ -2558,6 +2564,17 @@ static void rndis_wlan_indication(struct usbnet *usbdev, void *ind, int buflen)
 
 	switch (msg->status) {
 	case RNDIS_STATUS_MEDIA_CONNECT:
+		if (priv->current_command_oid == OID_802_11_ADD_KEY) {
+			/* OID_802_11_ADD_KEY causes sometimes extra
+			 * "media connect" indications which confuses driver
+			 * and userspace to think that device is
+			 * roaming/reassociating when it isn't.
+			 */
+			devdbg(usbdev, "ignored OID_802_11_ADD_KEY triggered "
+					"'media connect'");
+			return;
+		}
+
 		usbnet_pause_rx(usbdev);
 
 		devinfo(usbdev, "media connect");

