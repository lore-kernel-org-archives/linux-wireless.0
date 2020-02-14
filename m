Return-Path: <SRS0=dpF5=4C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 964F5C3B1B1
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 17:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73A9A20848
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 17:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581702675;
	bh=EPGMpNhnCU4ScCAQzPrYBJssBA7zn57+mhDsCbxyLQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2gMufyZ7+EKw47TkNuonedd9N5S8DT5/9EQEtqr1UreEDEd3eWa40qhiCX8WTylLZ
	 INslx2P8G14UUey6umK71t0GvGthHgdEQESSoXQUwCj1//FGm7vy+UnXsfD+GwO/i+
	 j4lTSspYJDlALfecUWS7PXJUhIuh1/M3fYRU3VjE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388750AbgBNP65 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Feb 2020 10:58:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:43358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388007AbgBNP65 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA7352467B;
        Fri, 14 Feb 2020 15:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695936;
        bh=EPGMpNhnCU4ScCAQzPrYBJssBA7zn57+mhDsCbxyLQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EEyC4K71vuAdmzy/CScZSaa+MpwhytCAZcZf3efxtJo8PG4iG7SASqywOgHkVhEHU
         WlDhzsFi6TrK8i+si3/tPcY1GvDrGcJoJmzBX9F+I2Dri4utKmWzMT1xueNpgLLAcP
         G6r+ZOPtyvkkyGRv+9NXvAlwEsBIOuRcQ8ZKi3H4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 471/542] ath10k: pci: Only dump ATH10K_MEM_REGION_TYPE_IOREG when safe
Date:   Fri, 14 Feb 2020 10:47:43 -0500
Message-Id: <20200214154854.6746-471-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit d239380196c4e27a26fa4bea73d2bf994c14ec2d ]

ath10k_pci_dump_memory_reg() will try to access memory of type
ATH10K_MEM_REGION_TYPE_IOREG however, if a hardware restart is in progress
this can crash a system.

Individual ioread32() time has been observed to jump from 15-20 ticks to >
80k ticks followed by a secure-watchdog bite and a system reset.

Work around this corner case by only issuing the read transaction when the
driver state is ATH10K_STATE_ON.

Tested-on: QCA9988 PCI 10.4-3.9.0.2-00044

Fixes: 219cc084c6706 ("ath10k: add memory dump support QCA9984")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/pci.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index bb44f5a0941b9..4822a65f6f3c2 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1604,11 +1604,22 @@ static int ath10k_pci_dump_memory_reg(struct ath10k *ar,
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	u32 i;
+	int ret;
+
+	mutex_lock(&ar->conf_mutex);
+	if (ar->state != ATH10K_STATE_ON) {
+		ath10k_warn(ar, "Skipping pci_dump_memory_reg invalid state\n");
+		ret = -EIO;
+		goto done;
+	}
 
 	for (i = 0; i < region->len; i += 4)
 		*(u32 *)(buf + i) = ioread32(ar_pci->mem + region->start + i);
 
-	return region->len;
+	ret = region->len;
+done:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
 }
 
 /* if an error happened returns < 0, otherwise the length */
@@ -1704,7 +1715,11 @@ static void ath10k_pci_dump_memory(struct ath10k *ar,
 			count = ath10k_pci_dump_memory_sram(ar, current_region, buf);
 			break;
 		case ATH10K_MEM_REGION_TYPE_IOREG:
-			count = ath10k_pci_dump_memory_reg(ar, current_region, buf);
+			ret = ath10k_pci_dump_memory_reg(ar, current_region, buf);
+			if (ret < 0)
+				break;
+
+			count = ret;
 			break;
 		default:
 			ret = ath10k_pci_dump_memory_generic(ar, current_region, buf);
-- 
2.20.1

