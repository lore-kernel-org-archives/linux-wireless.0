Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44876 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab2JPPw1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 11:52:27 -0400
To: <ath6kl-devel@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Set HT caps when an interface is added
Date: Tue, 16 Oct 2012 21:22:18 +0530
Message-ID: <1350402738-6422-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20121016_175231_155644_350225FB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Set HT capabilites when a vif is added (based on ht_supported
advertized is 'true'). ath6kl_set_htcap
seems to be called when an AP vif is added but not so in
other vifs. Fix this.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index d6e6c2d..5c3aaf6 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3630,6 +3630,8 @@ struct wireless_dev *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	list_add_tail(&vif->list, &ar->vif_list);
 	spin_unlock_bh(&ar->list_lock);
 
+	ath6kl_restore_htcap(vif);
+
 	return &vif->wdev;
 
 err:
-- 
1.7.0.4

