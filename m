Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab0AUM0k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 07:26:40 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: stable@kernel.org, linux-wireless@vger.kernel.org
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2.6.{32,31}] iwlwifi: power up all devices for EEPROM read
Date: Thu, 21 Jan 2010 13:22:25 +0100
Message-Id: <1264076545-12223-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit f8701fe3aec24fcfb0dfa19aab47904611f96daf upstream

On 2.6.31 and 2.6.32 iwl3945 crash during kdump, I discovered
above upstream commit fix that.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
I tested patch on 2.6.32 with iwl3945 - it fix kdump, and on 2.6.31
with iwl5300 - no regression notice.

 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 18dc3a4..870c0db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -486,6 +486,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 	}
 	e = (__le16 *)priv->eeprom;
 
+	priv->cfg->ops->lib->apm_ops.init(priv);
 	ret = priv->cfg->ops->lib->eeprom_ops.verify_signature(priv);
 	if (ret < 0) {
 		IWL_ERR(priv, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
@@ -556,6 +557,8 @@ done:
 err:
 	if (ret)
 		iwl_eeprom_free(priv);
+	/* Reset chip to save power until we load uCode during "up". */
+	priv->cfg->ops->lib->apm_ops.stop(priv);
 alloc_err:
 	return ret;
 }
-- 
1.6.2.5

