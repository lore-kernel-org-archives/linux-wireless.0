Return-Path: <SRS0=eW0r=7W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03683C433E0
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Jun 2020 00:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB39A20737
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Jun 2020 00:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591664229;
	bh=fe6JlMkedmaY+Fx6mlPmGF1n1tIJcCuXDwOukd/h1yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wHzTcgSvGCOaoUrAS5ZKEFOUsQ16vjSwUAFFoK5CSX1yW3KK7IcW54GzLoaRhOSjl
	 UHs2sZO/KTDf9Jo2EAH2a6cOr/nrf3QV8hYoxXsV1HdWiJrIeU8wBI51g+RwTyeq0Y
	 wU6iyPfyqnmYC+igbNcxd3B9ArRD1WPTDY3VXXTU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgFHXI5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Jun 2020 19:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728282AbgFHXIz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jun 2020 19:08:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A9BB208B6;
        Mon,  8 Jun 2020 23:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657734;
        bh=fe6JlMkedmaY+Fx6mlPmGF1n1tIJcCuXDwOukd/h1yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKn5jX7dIGmba3l9J/1JuUoIlobHcVR7Y24KQowsnG2bojfmF6gOU7LXjMlYQBYbL
         kn8RberEpnIz4gtEQnTWPZrCcFgV9+BFBMBdNi9V6KJRle2wuoG7rv5azTsWftpgDl
         BvXLQrJw8nmg0k3z+XPfo3BIjgEfthyOSuQjYrUk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 125/274] ath11k: use GFP_ATOMIC under spin lock
Date:   Mon,  8 Jun 2020 19:03:38 -0400
Message-Id: <20200608230607.3361041-125-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 69c93f9674c97dc439cdc0527811f8ad104c2e35 ]

A spin lock is taken here so we should use GFP_ATOMIC.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200427092417.56236-1-weiyongjun1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index f74a0e74bf3e..34b1e8e6a7fb 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -892,7 +892,7 @@ int ath11k_peer_rx_tid_setup(struct ath11k *ar, const u8 *peer_mac, int vdev_id,
 	else
 		hw_desc_sz = ath11k_hal_reo_qdesc_size(DP_BA_WIN_SZ_MAX, tid);
 
-	vaddr = kzalloc(hw_desc_sz + HAL_LINK_DESC_ALIGN - 1, GFP_KERNEL);
+	vaddr = kzalloc(hw_desc_sz + HAL_LINK_DESC_ALIGN - 1, GFP_ATOMIC);
 	if (!vaddr) {
 		spin_unlock_bh(&ab->base_lock);
 		return -ENOMEM;
-- 
2.25.1

