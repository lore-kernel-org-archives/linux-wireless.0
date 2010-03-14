Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:21489 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759533Ab0CNSpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Mar 2010 14:45:00 -0400
Received: by fg-out-1718.google.com with SMTP id 16so1202671fgg.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Mar 2010 11:44:59 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 14 Mar 2010 19:44:59 +0100
Message-ID: <6cf6b73e1003141144l5a549309xfc627fa7cb7bf817@mail.gmail.com>
Subject: [PATCH] iwlwifi: Silence tfds_in_queue message
From: Adel Gadllah <adel.gadllah@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 83bf3f1dba41e3dccdef4fecfccb094559568342 Mon Sep 17 00:00:00 2001
From: Adel Gadllah <adel.gadllah@gmail.com>
Date: Sun, 14 Mar 2010 19:16:25 +0100
Subject: [PATCH] iwlwifi: Silence tfds_in_queue message

Commit a239a8b47cc0e5e6d7416a89f340beac06d5edaa introduced a
noisy message, that fills up the log very fast.

The error seems not to be fatal (the connection is stable and
performance is ok), so make it IWL_DEBUG_TX rather than IWL_ERR.

Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: stable@kernel.org

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c
b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 045e4a6..d6222aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -161,7 +161,7 @@ void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 	if (priv->stations[sta_id].tid[tid].tfds_in_queue >= freed)
 		priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
 	else {
-		IWL_ERR(priv, "free more than tfds_in_queue (%u:%d)\n",
+		IWL_DEBUG_TX(priv, "free more than tfds_in_queue (%u:%d)\n",
 			priv->stations[sta_id].tid[tid].tfds_in_queue,
 			freed);
 		priv->stations[sta_id].tid[tid].tfds_in_queue = 0;
-- 
1.6.6.1
