Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:58664 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758084AbbAITSX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 14:18:23 -0500
Received: by mail-ob0-f177.google.com with SMTP id va2so14204262obc.8
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2015 11:18:22 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 6/8] wcn36xx: initialize dxe lock
Date: Fri,  9 Jan 2015 14:15:50 -0500
Message-Id: <1420830952-9624-7-git-send-email-me@bobcopeland.com> (sfid-20150109_201830_255398_E9FCC821)
In-Reply-To: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
References: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The dxe lock is missing its initialization, so add it.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/wcn36xx/main.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 7dd8873..972bb3e 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -298,6 +298,8 @@ static int wcn36xx_start(struct ieee80211_hw *hw)
 	wcn36xx_debugfs_init(wcn);
 
 	INIT_LIST_HEAD(&wcn->vif_list);
+	spin_lock_init(&wcn->dxe_lock);
+
 	return 0;
 
 out_smd_stop:
-- 
1.7.10.4

