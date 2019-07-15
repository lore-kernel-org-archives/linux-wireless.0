Return-Path: <SRS0=nAss=VM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BD5C7618F
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jul 2019 14:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6372D206B8
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jul 2019 14:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563199958;
	bh=ULjxUzx+++yfz9jlrK8gl/SRLm6WxtHyr+F6CLcmbpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=W9a4HdU32q9q7QSkBg+6SgsiHb93BnToDkUnxetjeNC7ZT58Bh5B4djk4dzx7YbmE
	 VoFsRbEQaMS1gBDPOwPaYXwHAKAWumJdEtEWFp8AIDSYqNkFNnqrwAjU7Dn4OzzU+W
	 WdmvqfMG6sgK6uQukvJ8ojo6Jk0eUO2RJM1Y2y7Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388786AbfGOOM0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Jul 2019 10:12:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389083AbfGOOMZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jul 2019 10:12:25 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62BE220651;
        Mon, 15 Jul 2019 14:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199943;
        bh=ULjxUzx+++yfz9jlrK8gl/SRLm6WxtHyr+F6CLcmbpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oq/NRPQWsxL2cmCDu+qMAYllKgP7746VZnyHHTdVHbk2rXNHm63V3ijtpNk/Car3z
         21Yp3ED7jeU8VI4y9oBNwVjc9S59y39MEzo7QxNS6/Z6X3RRvgqodPRNG2nN40JzRF
         fftwyjDMoDQ896A+WVGRdxoCK475HlQqOzMf7d8Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaoqing Pan <miaoqing@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 145/219] ath10k: fix fw crash by moving chip reset after napi disabled
Date:   Mon, 15 Jul 2019 10:02:26 -0400
Message-Id: <20190715140341.6443-145-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Miaoqing Pan <miaoqing@codeaurora.org>

[ Upstream commit 08d80e4cd27ba19f9bee9e5f788f9a9fc440a22f ]

On SMP platform, when continuously running wifi up/down, the napi
poll can be scheduled during chip reset, which will call
ath10k_pci_has_fw_crashed() to check the fw status. But in the reset
period, the value from FW_INDICATOR_ADDRESS register will return
0xdeadbeef, which also be treated as fw crash. Fix the issue by
moving chip reset after napi disabled.

ath10k_pci 0000:01:00.0: firmware crashed! (guid 73b30611-5b1e-4bdd-90b4-64c81eb947b6)
ath10k_pci 0000:01:00.0: qca9984/qca9994 hw1.0 target 0x01000000 chip_id 0x00000000 sub 168c:cafe
ath10k_pci 0000:01:00.0: htt-ver 2.2 wmi-op 6 htt-op 4 cal otp max-sta 512 raw 0 hwcrypto 1
ath10k_pci 0000:01:00.0: failed to get memcpy hi address for firmware address 4: -16
ath10k_pci 0000:01:00.0: failed to read firmware dump area: -16
ath10k_pci 0000:01:00.0: Copy Engine register dump:
ath10k_pci 0000:01:00.0: [00]: 0x0004a000   0   0   0   0
ath10k_pci 0000:01:00.0: [01]: 0x0004a400   0   0   0   0
ath10k_pci 0000:01:00.0: [02]: 0x0004a800   0   0   0   0
ath10k_pci 0000:01:00.0: [03]: 0x0004ac00   0   0   0   0
ath10k_pci 0000:01:00.0: [04]: 0x0004b000   0   0   0   0
ath10k_pci 0000:01:00.0: [05]: 0x0004b400   0   0   0   0
ath10k_pci 0000:01:00.0: [06]: 0x0004b800   0   0   0   0
ath10k_pci 0000:01:00.0: [07]: 0x0004bc00   1   0   1   0
ath10k_pci 0000:01:00.0: [08]: 0x0004c000   0   0   0   0
ath10k_pci 0000:01:00.0: [09]: 0x0004c400   0   0   0   0
ath10k_pci 0000:01:00.0: [10]: 0x0004c800   0   0   0   0
ath10k_pci 0000:01:00.0: [11]: 0x0004cc00   0   0   0   0

Tested HW: QCA9984,QCA9887,WCN3990

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/pci.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 2c27f407a851..6e5f7ae00253 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2059,6 +2059,11 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif stop\n");
 
+	ath10k_pci_irq_disable(ar);
+	ath10k_pci_irq_sync(ar);
+	napi_synchronize(&ar->napi);
+	napi_disable(&ar->napi);
+
 	/* Most likely the device has HTT Rx ring configured. The only way to
 	 * prevent the device from accessing (and possible corrupting) host
 	 * memory is to reset the chip now.
@@ -2072,10 +2077,6 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	 */
 	ath10k_pci_safe_chip_reset(ar);
 
-	ath10k_pci_irq_disable(ar);
-	ath10k_pci_irq_sync(ar);
-	napi_synchronize(&ar->napi);
-	napi_disable(&ar->napi);
 	ath10k_pci_flush(ar);
 
 	spin_lock_irqsave(&ar_pci->ps_lock, flags);
-- 
2.20.1

