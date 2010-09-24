Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:54573 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab0IXMXm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 08:23:42 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 24 Sep 2010 05:23:35 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: Fix TKIP disconnect failure with HTC drivers
Date: Fri, 24 Sep 2010 17:58:50 +0530
Message-ID: <1285331330-26105-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following commit removed splitmic. But forgot to add
ATH_CRYPT_CAP_MIC_COMBINED flag for HTC drivers which causes
TKIP to fail.

Author: Bruno Randolf <br1@einfach.org>
Date:   Wed Sep 8 16:04:54 2010 +0900

    ath/ath9k: Replace common->splitmic with a flag

    Replace common->splitmic with ATH_CRYPT_CAP_MIC_COMBINED flag.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 33850c9..b100db2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -561,6 +561,9 @@ static void ath9k_init_crypto(struct ath9k_htc_priv *priv)
 		common->keymax = ATH_KEYMAX;
 	}
 
+	if (priv->ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA)
+		common->crypt_caps |= ATH_CRYPT_CAP_MIC_COMBINED;
+
 	/*
 	 * Reset the key cache since some parts do not
 	 * reset the contents on initial power up.
-- 
1.7.3

