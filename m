Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:42157 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbZK3TuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 14:50:08 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/2] rndis_wlan: copy module parameters for bcm4320a devices
	too
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Nov 2009 21:50:13 +0200
Message-ID: <20091130195013.13062.47241.stgit@fate.lan>
In-Reply-To: <20091130195007.13062.25776.stgit@fate.lan>
References: <20091130195007.13062.25776.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rndis_wlan didn't copy module parameters for bcm4320a to private structure.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 8dd9224..305c106 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2642,6 +2642,11 @@ static void rndis_copy_module_params(struct usbnet *usbdev)
 
 static int bcm4320a_early_init(struct usbnet *usbdev)
 {
+	/* copy module parameters for bcm4320a so that iwconfig reports txpower
+	 * and workaround parameter is copied to private structure correctly.
+	 */
+	rndis_copy_module_params(usbdev);
+
 	/* bcm4320a doesn't handle configuration parameters well. Try
 	 * set any and you get partially zeroed mac and broken device.
 	 */

