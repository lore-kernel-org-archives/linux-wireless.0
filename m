Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:37906 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaBCU7D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:03 -0500
Received: by mail-ee0-f45.google.com with SMTP id b15so3893456eek.4
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:02 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/62] iwlwifi: mvm: add vif type in debugfs output
Date: Mon,  3 Feb 2014 22:57:35 +0200
Message-Id: <1391461088-8082-29-git-send-email-egrumbach@gmail.com> (sfid-20140203_220007_571463_4759B472)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Add the vif type when we print the mac params.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 9194709..f6bed07 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -225,6 +225,29 @@ static ssize_t iwl_dbgfs_mac_params_read(struct file *file,
 
 	ap_sta_id = mvmvif->ap_sta_id;
 
+	switch (ieee80211_vif_type_p2p(vif)) {
+	case NL80211_IFTYPE_ADHOC:
+		pos += scnprintf(buf+pos, bufsz-pos, "type: ibss\n");
+		break;
+	case NL80211_IFTYPE_STATION:
+		pos += scnprintf(buf+pos, bufsz-pos, "type: bss\n");
+		break;
+	case NL80211_IFTYPE_AP:
+		pos += scnprintf(buf+pos, bufsz-pos, "type: ap\n");
+		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+		pos += scnprintf(buf+pos, bufsz-pos, "type: p2p client\n");
+		break;
+	case NL80211_IFTYPE_P2P_GO:
+		pos += scnprintf(buf+pos, bufsz-pos, "type: p2p go\n");
+		break;
+	case NL80211_IFTYPE_P2P_DEVICE:
+		pos += scnprintf(buf+pos, bufsz-pos, "type: p2p dev\n");
+		break;
+	default:
+		break;
+	}
+
 	pos += scnprintf(buf+pos, bufsz-pos, "mac id/color: %d / %d\n",
 			 mvmvif->id, mvmvif->color);
 	pos += scnprintf(buf+pos, bufsz-pos, "bssid: %pM\n",
-- 
1.7.9.5

