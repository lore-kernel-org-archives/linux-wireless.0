Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:47046 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3K3VZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 16:25:02 -0500
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH mac80211] iwlwifi: don't install GTKs for IBSS vifs on resume
Date: Sat, 30 Nov 2013 22:24:18 +0100
Message-Id: <1385846658-2294-1-git-send-email-antonio@meshcoding.com> (sfid-20131130_222507_866134_AB3FF370)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

When performing keys reprogramming on HW resume, GTKs
belonging to IBSS stations should be skipped and not
installed onto the device.

Such keys are not installed by set_key() and the same
behaviour has to be kept on reprogramming (mac80211
is already performing enc/dec in SW for those keys).

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---

* compiled tested only *

 drivers/net/wireless/iwlwifi/dvm/lib.c | 5 +++++
 drivers/net/wireless/iwlwifi/mvm/d3.c  | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/dvm/lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
index 3d5bdc4..96be24d 100644
--- a/drivers/net/wireless/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -929,6 +929,11 @@ static void iwlagn_wowlan_program_keys(struct ieee80211_hw *hw,
 	u16 p1k[IWLAGN_P1K_SIZE];
 	int ret, i;
 
+	/* Group keys for IBSS interfaces are not stored in HW */
+	if (vif->type == NL80211_IFTYPE_ADHOC &&
+	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		return;
+
 	mutex_lock(&priv->mutex);
 
 	if ((key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 6f45966..53182e6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -156,6 +156,11 @@ static void iwl_mvm_wowlan_program_keys(struct ieee80211_hw *hw,
 	u16 p1k[IWL_P1K_SIZE];
 	int ret, i;
 
+	/* Group keys for IBSS interfaces are not stored in HW */
+	if (vif->type == NL80211_IFTYPE_ADHOC &&
+	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		return;
+
 	mutex_lock(&mvm->mutex);
 
 	switch (key->cipher) {
-- 
1.8.4.4

