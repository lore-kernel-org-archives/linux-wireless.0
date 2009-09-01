Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:13474 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754666AbZIANM6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 09:12:58 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 6/9] iwmc3200wifi: fix misuse of le16_to_cpu
Date: Tue,  1 Sep 2009 15:14:03 +0200
Message-Id: <0b1215c4ea3f375a932030fe94fd97e47df4b4eb.1251809163.git.sameo@linux.intel.com>
In-Reply-To: <cf887cbfdcddc6c3874e08978b8926f82862d345.1251809163.git.sameo@linux.intel.com>
References: <cover.1251809163.git.sameo@linux.intel.com>
 <51aebb943245be1aef404d6274fe60feabd47c94.1251809163.git.sameo@linux.intel.com>
 <b08ebbaa73e4796a6be51889860bc1bd67867a90.1251809163.git.sameo@linux.intel.com>
 <3a950a601bd437ab1c971dc495fc0a2c3c886631.1251809163.git.sameo@linux.intel.com>
 <8736a234164502177f2073aa9d2f042eed39f67b.1251809163.git.sameo@linux.intel.com>
 <cf887cbfdcddc6c3874e08978b8926f82862d345.1251809163.git.sameo@linux.intel.com>
In-Reply-To: <cover.1251809163.git.sameo@linux.intel.com>
References: <cover.1251809163.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

Also mark some functions static.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/iwmc3200wifi/main.c |    8 ++++----
 drivers/net/wireless/iwmc3200wifi/rx.c   |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index c41fa8c..6cf2f0c 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -128,8 +128,8 @@ static void iwm_disconnect_work(struct work_struct *work)
 	cfg80211_disconnected(iwm_to_ndev(iwm), 0, NULL, 0, GFP_KERNEL);
 }
 
-int __iwm_up(struct iwm_priv *iwm);
-int __iwm_down(struct iwm_priv *iwm);
+static int __iwm_up(struct iwm_priv *iwm);
+static int __iwm_down(struct iwm_priv *iwm);
 
 static void iwm_reset_worker(struct work_struct *work)
 {
@@ -559,7 +559,7 @@ static int iwm_channels_init(struct iwm_priv *iwm)
 	return 0;
 }
 
-int __iwm_up(struct iwm_priv *iwm)
+static int __iwm_up(struct iwm_priv *iwm)
 {
 	int ret;
 	struct iwm_notif *notif_reboot, *notif_ack = NULL;
@@ -693,7 +693,7 @@ int iwm_up(struct iwm_priv *iwm)
 	return ret;
 }
 
-int __iwm_down(struct iwm_priv *iwm)
+static int __iwm_down(struct iwm_priv *iwm)
 {
 	int ret;
 
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 4d9793e..2daa586 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -850,7 +850,7 @@ static int iwm_mlme_mgt_frame(struct iwm_priv *iwm, u8 *buf,
 				       iwm->resp_ie_len, GFP_KERNEL);
 	} else {
 		IWM_ERR(iwm, "Unsupported management frame: 0x%x",
-			cpu_to_le16(mgt->frame_control));
+			le16_to_cpu(mgt->frame_control));
 		return 0;
 	}
 
-- 
1.6.3.3

