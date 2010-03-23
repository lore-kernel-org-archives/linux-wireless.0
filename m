Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab0CWMtN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 08:49:13 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/2] iwlwifi: implement disabling/enabling QoS
Date: Tue, 23 Mar 2010 13:46:57 +0100
Message-Id: <1269348417-4081-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1269348417-4081-1-git-send-email-sgruszka@redhat.com>
References: <1269348417-4081-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 112149e..f1729ca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2410,6 +2410,15 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 		priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
 	}
 
+	if (changes & BSS_CHANGED_QOS) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&priv->lock, flags);
+		priv->qos_data.qos_active = bss_conf->qos_disabled ? 0 : 1;
+		iwl_activate_qos(priv, 1);
+		spin_unlock_irqrestore(&priv->lock, flags);
+	}
+
 	if (changes & BSS_CHANGED_BEACON_INT) {
 		priv->beacon_int = bss_conf->beacon_int;
 		/* TODO: in AP mode, do something to make this take effect */
-- 
1.6.6

