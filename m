Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58299 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbbJ0J0p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 05:26:45 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 17/27] staging: wilc1000: mac_ioctl: use private data instead of g_linux_wlan
Date: Tue, 27 Oct 2015 18:27:53 +0900
Message-ID: <1445938083-20445-17-git-send-email-glen.lee@atmel.com> (sfid-20151027_102647_641407_E77B47B2)
In-Reply-To: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
References: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use netdev private data member wilc instead of g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b6244f93..bd9f715 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1496,11 +1496,13 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	perInterface_wlan_t *nic;
 	struct wilc_priv *priv;
 	s32 s32Error = 0;
+	struct wilc *wilc;
 
 	/* struct iwreq *wrq = (struct iwreq *) req;	// tony moved to case SIOCSIWPRIV */
 	nic = netdev_priv(ndev);
+	wilc = nic->wilc;
 
-	if (!g_linux_wlan->initialized)
+	if (!wilc->initialized)
 		return 0;
 
 	switch (cmd) {
-- 
1.9.1

