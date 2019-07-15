Return-Path: <SRS0=nAss=VM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11548C7618F
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jul 2019 14:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D17EE2067C
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jul 2019 14:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563202260;
	bh=F/3Yu9F8Yg7390e8aDrvVnWJyw1DVgBdBCAfaAM2QtA=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=hglwS0Q/1OG6QzkUAN6fnJIlmkB210rb36f3bnpFPy2OyXT/qxXfnXf8C60quW++P
	 XlnTfhQKeNFrm1BDETzPEqf9/MdKo0W5DhWgLLNArQ7MEADP2kq3UIuKK8rkXGGcaV
	 aWiTX/sy0xTIsZmtPRB3VXxUP3kPNJXzsTlCJpMM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404170AbfGOOpm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Jul 2019 10:45:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404134AbfGOOpk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jul 2019 10:45:40 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3787620651;
        Mon, 15 Jul 2019 14:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201940;
        bh=F/3Yu9F8Yg7390e8aDrvVnWJyw1DVgBdBCAfaAM2QtA=;
        h=From:To:Cc:Subject:Date:From;
        b=V7NQNNFirOKFuniarJ+o63vHV+ddFAo8dyl4DrWnwM/sJM4vFBmc7o09U3H2VWZ21
         6Ot5fQUV1cYiP0MMAIIbwWXOQGp36lJYjDQbXWyk2ZtKGrmsfAXpFirPOFB9qCi5e/
         gez19cADwekduZ1I08i2fgfOQ17ZjT9FaDQEIjNA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Surabhi Vishnoi <svishnoi@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 01/53] ath10k: Do not send probe response template for mesh
Date:   Mon, 15 Jul 2019 10:44:43 -0400
Message-Id: <20190715144535.11636-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Surabhi Vishnoi <svishnoi@codeaurora.org>

[ Upstream commit 97354f2c432788e3163134df6bb144f4b6289d87 ]

Currently mac80211 do not support probe response template for
mesh point. When WMI_SERVICE_BEACON_OFFLOAD is enabled, host
driver tries to configure probe response template for mesh, but
it fails because the interface type is not NL80211_IFTYPE_AP but
NL80211_IFTYPE_MESH_POINT.

To avoid this failure, skip sending probe response template to
firmware for mesh point.

Tested HW: WCN3990/QCA6174/QCA9984

Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 398068ad0b62..5a0138c1c045 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1502,6 +1502,10 @@ static int ath10k_mac_setup_prb_tmpl(struct ath10k_vif *arvif)
 	if (arvif->vdev_type != WMI_VDEV_TYPE_AP)
 		return 0;
 
+	 /* For mesh, probe response and beacon share the same template */
+	if (ieee80211_vif_is_mesh(vif))
+		return 0;
+
 	prb = ieee80211_proberesp_get(hw, vif);
 	if (!prb) {
 		ath10k_warn(ar, "failed to get probe resp template from mac80211\n");
-- 
2.20.1

