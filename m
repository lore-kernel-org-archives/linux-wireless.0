Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.dnainternet.fi ([87.94.96.108]:49257 "EHLO
	smtp1.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbYE0IPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 04:15:10 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/2] rndis_wlan: add missing range check for power_output
	modparam
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Tue, 27 May 2008 11:15:08 +0300
Message-ID: <20080527081508.15936.45218.stgit@fate.lan> (sfid-20080527_101513_937571_C69790A6)
In-Reply-To: <20080527081502.15936.68708.stgit@fate.lan>
References: <20080527081502.15936.68708.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Range check for power_output were missing.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index ed310f8..f7cca7d 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2414,6 +2414,11 @@ static int bcm4320_early_init(struct usbnet *dev)
 	else if (priv->param_power_save > 2)
 		priv->param_power_save = 2;
 
+	if (priv->param_power_output < 0)
+		priv->param_power_output = 0;
+	else if (priv->param_power_output > 3)
+		priv->param_power_output = 3;
+
 	if (priv->param_roamtrigger < -80)
 		priv->param_roamtrigger = -80;
 	else if (priv->param_roamtrigger > -60)

