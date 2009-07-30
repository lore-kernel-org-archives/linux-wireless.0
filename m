Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:38939 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZG3Qrf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 12:47:35 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 04/10] rndis_wlan: reset device and restore multicast list on
	rndis_wlan_reset()
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Thu, 30 Jul 2009 19:41:37 +0300
Message-ID: <20090730164137.28317.8315.stgit@fate.lan>
In-Reply-To: <20090730164120.28317.53313.stgit@fate.lan>
References: <20090730164120.28317.53313.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reset device properly with RNDIS_MSG_RESET in rndis_wlan_reset() and restore
multicast list afterwards.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index dee0551..bfb9861 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -594,6 +594,28 @@ static int rndis_set_oid(struct usbnet *dev, __le32 oid, void *data, int len)
 }
 
 
+static int rndis_reset(struct usbnet *usbdev)
+{
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
+	struct rndis_reset *reset;
+	int ret;
+
+	mutex_lock(&priv->command_lock);
+
+	reset = (void *)priv->command_buffer;
+	memset(reset, 0, sizeof(*reset));
+	reset->msg_type = RNDIS_MSG_RESET;
+	reset->msg_len = cpu_to_le32(sizeof(*reset));
+	ret = rndis_command(usbdev, (void *)reset, CONTROL_BUFFER_SIZE);
+
+	mutex_unlock(&priv->command_lock);
+
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+
 /*
  * Specs say that we can only set config parameters only soon after device
  * initialization.
@@ -2500,9 +2522,17 @@ static void rndis_wlan_unbind(struct usbnet *usbdev, struct usb_interface *intf)
 static int rndis_wlan_reset(struct usbnet *usbdev)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
+	int retval;
 
 	devdbg(usbdev, "rndis_wlan_reset");
 
+	retval = rndis_reset(usbdev);
+	if (retval)
+		devwarn(usbdev, "rndis_reset() failed: %d", retval);
+
+	/* rndis_reset cleared multicast list, so restore here. */
+	set_multicast_list(usbdev);
+
 	queue_delayed_work(priv->workqueue, &priv->stats_work,
 		round_jiffies_relative(STATS_UPDATE_JIFFIES));
 

