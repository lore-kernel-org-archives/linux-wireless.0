Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:46164 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752906AbZKVSQm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2009 13:16:42 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/2] rndis_wlan: disable stall workaround
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 22 Nov 2009 20:16:47 +0200
Message-ID: <20091122181647.24641.86877.stgit@fate.lan>
In-Reply-To: <20091122181642.24641.73461.stgit@fate.lan>
References: <20091122181642.24641.73461.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stall workaround doesn't work with bcm4320a devices like with bcm4320b. 
This workaround actually causes more stalls/device freeze on bcm4320a.
Therefore disable stall workaround by default.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 8b09b04..2ecbedb 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -83,11 +83,11 @@ MODULE_PARM_DESC(roamdelta,
 	"set roaming tendency: 0=aggressive, 1=moderate, "
 				"2=conservative (default: moderate)");
 
-static int modparam_workaround_interval = 500;
+static int modparam_workaround_interval;
 module_param_named(workaround_interval, modparam_workaround_interval,
 							int, 0444);
 MODULE_PARM_DESC(workaround_interval,
-	"set stall workaround interval in msecs (default: 500)");
+	"set stall workaround interval in msecs (0=disabled) (default: 0)");
 
 
 /* various RNDIS OID defs */
@@ -2550,7 +2550,7 @@ static void rndis_device_poller(struct work_struct *work)
 	/* Workaround transfer stalls on poor quality links.
 	 * TODO: find right way to fix these stalls (as stalls do not happen
 	 * with ndiswrapper/windows driver). */
-	if (priv->last_qual <= 25) {
+	if (priv->param_workaround_interval > 0 && priv->last_qual <= 25) {
 		/* Decrease stats worker interval to catch stalls.
 		 * faster. Faster than 400-500ms causes packet loss,
 		 * Slower doesn't catch stalls fast enough.

