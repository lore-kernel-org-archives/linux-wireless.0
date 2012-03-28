Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55284 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab2C1Nvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 09:51:43 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	PingYang Zhang <pingzhan@qca.qualcomm.com>
Subject: [PATCH 2/2] ath6kl: Fix scan related issue on suspend-resume
Date: Wed, 28 Mar 2012 19:21:26 +0530
Message-ID: <1332942686-6965-2-git-send-email-nataraja@qca.qualcomm.com> (sfid-20120328_155145_886396_B7A73E02)
In-Reply-To: <1332942686-6965-1-git-send-email-nataraja@qca.qualcomm.com>
References: <1332942686-6965-1-git-send-email-nataraja@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a scan request is pending while going to suspend, any new
scan request after resume will fail. So, cancel all scan requests
in all the vifs before moving to suspend state.

Signed-off-by: PingYang Zhang <pingzhan@qca.qualcomm.com>
Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index df95e0d..952a858 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2205,6 +2205,7 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 			    enum ath6kl_cfg_suspend_mode mode,
 			    struct cfg80211_wowlan *wow)
 {
+	struct ath6kl_vif *vif;
 	enum ath6kl_state prev_state;
 	int ret;
 
@@ -2274,6 +2275,9 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 		break;
 	}
 
+	list_for_each_entry(vif, &ar->vif_list, list)
+		ath6kl_cfg80211_scan_complete_event(vif, true);
+
 	return 0;
 }
 EXPORT_SYMBOL(ath6kl_cfg80211_suspend);
-- 
1.7.4.1

