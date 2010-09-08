Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35620 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644Ab0IHX0C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:26:02 -0400
Received: by mail-pv0-f174.google.com with SMTP id 2so253118pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:26:01 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Steve deRosier <steve@cozybit.com>
Subject: [PATCH 6/9] libertas_tf: Fix to enable interrupts even when firmware has already started
Date: Wed,  8 Sep 2010 16:25:26 -0700
Message-Id: <1283988329-44549-7-git-send-email-steve@cozybit.com>
In-Reply-To: <1283988329-44549-1-git-send-email-steve@cozybit.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 drivers/net/wireless/libertas_tf/main.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 14ce1bc..b797787 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -327,20 +327,20 @@ static int lbtf_op_start(struct ieee80211_hw *hw)
 
 	lbtf_deb_enter(LBTF_DEB_MACOPS);
 
-	if (priv->hw_prog_firmware) {
-		if (!priv->fw_ready) {
-			lbtf_deb_main("Going to upload fw...");
-			/* Upload firmware */
+	if (!priv->fw_ready) {
+		lbtf_deb_main("Going to upload fw...");
+		/* Upload firmware */
+		if (priv->hw_prog_firmware) {
 			if (priv->hw_prog_firmware(card))
 				goto err_prog_firmware;
 			else
 				priv->fw_ready = 1;
-		} else {
-			if (priv->enable_interrupts) {
-				priv->enable_interrupts(priv);
-			}
-			lbtf_deb_main("FW was already ready...");
 		}
+	} else {
+		if (priv->enable_interrupts) {
+			priv->enable_interrupts(priv);
+		}
+		lbtf_deb_main("FW was already ready...");
 	}
 
 	/* poke the firmware */
-- 
1.7.0

