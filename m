Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:49917 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbZK3TuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 14:50:03 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/2] rndis_wlan: move copy of module parameters to separate
	function
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Nov 2009 21:50:07 +0200
Message-ID: <20091130195007.13062.25776.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   37 ++++++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 2ecbedb..8dd9224 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2594,23 +2594,9 @@ end:
 /*
  * driver/device initialization
  */
-static int bcm4320a_early_init(struct usbnet *usbdev)
-{
-	/* bcm4320a doesn't handle configuration parameters well. Try
-	 * set any and you get partially zeroed mac and broken device.
-	 */
-
-	return 0;
-}
-
-static int bcm4320b_early_init(struct usbnet *usbdev)
+static void rndis_copy_module_params(struct usbnet *usbdev)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
-	char buf[8];
-
-	/* Early initialization settings, setting these won't have effect
-	 * if called after generic_rndis_bind().
-	 */
 
 	priv->param_country[0] = modparam_country[0];
 	priv->param_country[1] = modparam_country[1];
@@ -2652,6 +2638,27 @@ static int bcm4320b_early_init(struct usbnet *usbdev)
 		priv->param_workaround_interval = 500;
 	else
 		priv->param_workaround_interval = modparam_workaround_interval;
+}
+
+static int bcm4320a_early_init(struct usbnet *usbdev)
+{
+	/* bcm4320a doesn't handle configuration parameters well. Try
+	 * set any and you get partially zeroed mac and broken device.
+	 */
+
+	return 0;
+}
+
+static int bcm4320b_early_init(struct usbnet *usbdev)
+{
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
+	char buf[8];
+
+	rndis_copy_module_params(usbdev);
+
+	/* Early initialization settings, setting these won't have effect
+	 * if called after generic_rndis_bind().
+	 */
 
 	rndis_set_config_parameter_str(usbdev, "Country", priv->param_country);
 	rndis_set_config_parameter_str(usbdev, "FrameBursting",

