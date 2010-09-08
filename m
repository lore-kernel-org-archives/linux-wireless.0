Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35620 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab0IHXZ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:25:58 -0400
Received: by pvg2 with SMTP id 2so253118pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:25:58 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Steve deRosier <steve@cozybit.com>
Subject: [PATCH 3/9] libertas_tf: Added fullmac mode support so firmware supports libertas driver
Date: Wed,  8 Sep 2010 16:25:23 -0700
Message-Id: <1283988329-44549-4-git-send-email-steve@cozybit.com>
In-Reply-To: <1283988329-44549-1-git-send-email-steve@cozybit.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 drivers/net/wireless/libertas_tf/libertas_tf.h |    1 +
 drivers/net/wireless/libertas_tf/main.c        |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/libertas_tf.h b/drivers/net/wireless/libertas_tf/libertas_tf.h
index 078c52e..bedb6b1 100644
--- a/drivers/net/wireless/libertas_tf/libertas_tf.h
+++ b/drivers/net/wireless/libertas_tf/libertas_tf.h
@@ -80,6 +80,7 @@ enum lbtf_mode {
 	LBTF_PASSIVE_MODE,
 	LBTF_STA_MODE,
 	LBTF_AP_MODE,
+	LBTF_FULLMAC_MODE,
 };
 
 /** Card Event definition */
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 90ef6c7..5d34ad9 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -158,6 +158,7 @@ static int lbtf_setup_firmware(struct lbtf_private *priv)
 
 	lbtf_set_mac_control(priv);
 	lbtf_set_radio_control(priv);
+	lbtf_set_mode(priv, LBTF_PASSIVE_MODE);
 
 	ret = 0;
 done:
-- 
1.7.0

