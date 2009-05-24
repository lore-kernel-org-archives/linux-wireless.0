Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:39656 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbZEXRnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2009 13:43:50 -0400
Received: by bwz22 with SMTP id 22so2635845bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 24 May 2009 10:43:50 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 24 May 2009 20:43:50 +0300
Message-ID: <eb3ff54b0905241043i2c8a0407yeac7d2c07d1e7e1f@mail.gmail.com>
Subject: [PATCH] iwlwifi: avoid build warning in iwl-core.
From: Rami Rosen <ramirose@gmail.com>
To: linville@tuxdriver.com
Cc: reinette.chatre@intel.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When building when CONFIG_IWLWIFI_DEBUG is not set is not set, we get
the following
warning:
/work/src/w/drivers/net/wireless/iwlwifi/iwl-core.c: In function ‘iwl_isr’:
/work/src/w/drivers/net/wireless/iwlwifi/iwl-core.c:1707: warning:
unused variable ‘inta_fh’

This patch avoids this warning by adding #ifdef CONFIG_IWLWIFI_DEBUG
before the declaration of inta_fh in iwl_isr() in
drivers/net/wireless/iwlwifi/iwl-core.c

Signed-off-by: Rami Rosen <ramirose@gmail.com>

---
(wireless-testing).

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c
b/drivers/net/wireless/iwlwifi/iwl-core.c
index e93ddb7..811a525 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1704,8 +1704,9 @@ static irqreturn_t iwl_isr(int irq, void *data)
 {
 	struct iwl_priv *priv = data;
 	u32 inta, inta_mask;
+#ifdef CONFIG_IWLWIFI_DEBUG
 	u32 inta_fh;
-
+#endif
 	if (!priv)
 		return IRQ_NONE;
