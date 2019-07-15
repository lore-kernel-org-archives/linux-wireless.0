Return-Path: <SRS0=nAss=VM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7470DC7618F
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jul 2019 15:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D4652054F
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jul 2019 15:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563203369;
	bh=AVIWfeOq2+QctxhGn7Gs9o0z2ngpeZllDmYpTK7i0iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HneHoXt6eNhc8rkLZzPuqunjrHkvh/ue1oLmDZL1BWL6CucLjLMn4OnY6HdbJTEi/
	 PI48+l0pvunrQdVcso0EV28nopgQf/Pc7FOrIwZDQ/lrfCYo4280wh0cQ5KLsAj1AC
	 ceVIIkpmYsIYjtWG/3r/cLN1XoHAbkJXwwvlfOaQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732897AbfGON4u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Jul 2019 09:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732891AbfGON4s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jul 2019 09:56:48 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 683A621530;
        Mon, 15 Jul 2019 13:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199007;
        bh=AVIWfeOq2+QctxhGn7Gs9o0z2ngpeZllDmYpTK7i0iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUwVTtI8jKa+Q50vb6N+p8Ows8X9dJJ3AwHGhOAGaivLdWAsHXHeAMMQTxb2tspub
         9LGsnhQIlYb0wfk2gaX4mNlCo587sxPEeG/2nv5D/Odl+BeW+0UYXglTCs6NY/oO4y
         oYhsrOb+WUV3z3wrhXKoRK0O0+UO1LaB7lGSumMk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claire Chang <tientzu@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 163/249] ath10k: add missing error handling
Date:   Mon, 15 Jul 2019 09:45:28 -0400
Message-Id: <20190715134655.4076-163-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Claire Chang <tientzu@chromium.org>

[ Upstream commit 4b553f3ca4cbde67399aa3a756c37eb92145b8a1 ]

In function ath10k_sdio_mbox_rx_alloc() [sdio.c],
ath10k_sdio_mbox_alloc_rx_pkt() is called without handling the error cases.
This will make the driver think the allocation for skb is successful and
try to access the skb. If we enable failslab, system will easily crash with
NULL pointer dereferencing.

Call trace of CONFIG_FAILSLAB:
ath10k_sdio_irq_handler+0x570/0xa88 [ath10k_sdio]
process_sdio_pending_irqs+0x4c/0x174
sdio_run_irqs+0x3c/0x64
sdio_irq_work+0x1c/0x28

Fixes: d96db25d2025 ("ath10k: add initial SDIO support")
Signed-off-by: Claire Chang <tientzu@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index fae56c67766f..73ef3e75d199 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -602,6 +602,10 @@ static int ath10k_sdio_mbox_rx_alloc(struct ath10k *ar,
 						    full_len,
 						    last_in_bundle,
 						    last_in_bundle);
+		if (ret) {
+			ath10k_warn(ar, "alloc_rx_pkt error %d\n", ret);
+			goto err;
+		}
 	}
 
 	ar_sdio->n_rx_pkts = i;
-- 
2.20.1

