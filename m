Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:39474 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbYAILCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 06:02:33 -0500
Received: by rv-out-0910.google.com with SMTP id k20so189004rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2008 03:02:33 -0800 (PST)
From: Joonwoo Park <joonwpark81@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>, netdev@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org,
	Joonwoo Park <joonwpark81@gmail.com>
Subject: [PATCH 2/5] iwlwifi: iwl3945 synchronize interrupt and tasklet for down iwlwifi
Date: Wed,  9 Jan 2008 20:02:28 +0900
Message-Id: <11998765481610-git-send-email-joonwpark81@gmail.com> (sfid-20080109_110256_944957_E248AAEB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After disabling interrupts, it's possible irq & tasklet is pending or running
This patch eleminates races for down iwlwifi

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c97448d..3986aaf 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6262,6 +6262,10 @@ static void __iwl_down(struct iwl_priv *priv)
 	/* tell the device to stop sending interrupts */
 	iwl_disable_interrupts(priv);
 
+	/* synchronize irq and tasklet */
+	synchronize_irq(priv->pci_dev->irq);
+	tasklet_kill(&priv->irq_tasklet);
+
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
 
-- 
1.5.3.rc5

