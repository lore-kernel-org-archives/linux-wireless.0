Return-Path: <SRS0=hdaX=2H=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6962C2D0D6
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Dec 2019 14:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A256920684
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Dec 2019 14:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbfLQOTg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 17 Dec 2019 09:19:36 -0500
Received: from nbd.name ([46.4.11.11]:41756 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728925AbfLQOTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Dec 2019 09:19:34 -0500
Received: from pd95fd66b.dip0.t-ipconnect.de ([217.95.214.107] helo=bertha.fritz.box)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1ihDhD-0001fe-MP; Tue, 17 Dec 2019 15:19:31 +0100
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        John Crispin <john@phrozen.org>
Subject: [PATCH V3 4/4] ath11k: add handling for BSS color
Date:   Tue, 17 Dec 2019 15:19:21 +0100
Message-Id: <20191217141921.8114-4-john@phrozen.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191217141921.8114-1-john@phrozen.org>
References: <20191217141921.8114-1-john@phrozen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch adds code to handle the BSS_CHANGED_BSS_COLOR flag. It will
trigger the propagation of BSS color settings into the FW. Handling is
slightly different between AP and STA interfaces.

Signed-off-by: John Crispin <john@phrozen.org>
---
Changes in V2
* handle return codes

 drivers/net/wireless/ath/ath11k/mac.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 6a8c1c3b8da2..fec268b9b711 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -1928,6 +1928,33 @@ static void ath11k_mac_op_bss_info_changed(struct ieee80211_hw *hw,
 		ath11k_wmi_send_obss_spr_cmd(ar, arvif->vdev_id,
 					     &info->he_obss_pd);
 
+	if (changed & BSS_CHANGED_HE_BSS_COLOR) {
+		if (vif->type == NL80211_IFTYPE_AP) {
+			ret = ath11k_wmi_send_obss_color_collision_cfg_cmd(
+				ar, arvif->vdev_id, info->he_bss_color.color,
+				ATH11K_BSS_COLOR_COLLISION_DETECTION_AP_PERIOD_MS,
+				!info->he_bss_color.disabled);
+			if (ret)
+				ath11k_warn(ar->ab,
+				    "failed to set bss color collision on vdev %i: %d\n",
+				    arvif->vdev_id,  ret);
+		} else if (vif->type == NL80211_IFTYPE_STATION) {
+			ret = ath11k_wmi_send_bss_color_change_enable_cmd(ar,
+								arvif->vdev_id, 1);
+			if (ret)
+				ath11k_warn(ar->ab,
+				    "failed to enable bss color change on vdev %i: %d\n",
+				    arvif->vdev_id,  ret);
+			ret = ath11k_wmi_send_obss_color_collision_cfg_cmd(
+				ar, arvif->vdev_id, 0,
+				ATH11K_BSS_COLOR_COLLISION_DETECTION_STA_PERIOD_MS, 1);
+			if (ret)
+				ath11k_warn(ar->ab,
+				    "failed to set bss color collision on vdev %i: %d\n",
+				    arvif->vdev_id,  ret);
+}
+	}
+
 	mutex_unlock(&ar->conf_mutex);
 }
 
-- 
2.20.1

