Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8AB9C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 03:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A28A2204EC
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 03:01:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Wl//zg05";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Wl//zg05"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfDCDBv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Apr 2019 23:01:51 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43552 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfDCDBv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Apr 2019 23:01:51 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9D6EE60590; Wed,  3 Apr 2019 03:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554260510;
        bh=lMe6o8B2AhfkHpDYFEl/mJmX0XlcMCrr5a643xu5/38=;
        h=From:To:Cc:Subject:Date:From;
        b=Wl//zg05eRiGSPTGpA7fDyzfNdNk9WKSZ7MnCd8uQv5KC4UiM89PZfXOVjdO5Wvy3
         4RavZ/2PCkdFOeKqhZSZUeAYqbcZ2NZ7dyxZWK62SxGwygyCzqGs5DPjtYuJUV+oLo
         BKC6AddHOa7KDO3PHQJHvyVyIvq7oe+iiO5CTQ7E=
Received: from localhost.localdomain (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 29ECC60452;
        Wed,  3 Apr 2019 03:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554260510;
        bh=lMe6o8B2AhfkHpDYFEl/mJmX0XlcMCrr5a643xu5/38=;
        h=From:To:Cc:Subject:Date:From;
        b=Wl//zg05eRiGSPTGpA7fDyzfNdNk9WKSZ7MnCd8uQv5KC4UiM89PZfXOVjdO5Wvy3
         4RavZ/2PCkdFOeKqhZSZUeAYqbcZ2NZ7dyxZWK62SxGwygyCzqGs5DPjtYuJUV+oLo
         BKC6AddHOa7KDO3PHQJHvyVyIvq7oe+iiO5CTQ7E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 29ECC60452
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: add peer id check in ath10k_peer_find_by_id
Date:   Wed,  3 Apr 2019 11:01:18 +0800
Message-Id: <1554260478-4161-1-git-send-email-wgong@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

For some SDIO chip, the peer id is 65535 for MPDU with error status,
then test_bit will trigger buffer overflow for peer's memory, if kasan
enabled, it will report error.

Add check for overflow the size of peer's peer_ids will avoid the buffer
overflow access.

Call trace of kasan:
dump_backtrace+0x0/0x2ec
show_stack+0x20/0x2c
__dump_stack+0x20/0x28
dump_stack+0xc8/0xec
print_address_description+0x74/0x240
kasan_report+0x250/0x26c
__asan_report_load8_noabort+0x20/0x2c
ath10k_peer_find_by_id+0x180/0x1e4 [ath10k_core]
ath10k_htt_t2h_msg_handler+0x100c/0x2fd4 [ath10k_core]
ath10k_htt_htc_t2h_msg_handler+0x20/0x34 [ath10k_core]
ath10k_sdio_irq_handler+0xcc8/0x1678 [ath10k_sdio]
process_sdio_pending_irqs+0xec/0x370
sdio_run_irqs+0x68/0xe4
sdio_irq_work+0x1c/0x28
process_one_work+0x3d8/0x8b0
worker_thread+0x508/0x7cc
kthread+0x24c/0x264
ret_from_fork+0x10/0x18

Tested with QCA6174 SDIO with firmware
WLAN.RMH.4.4.1-00007-QCARMSWP-1.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/txrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 23606b6..33de9e1 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -157,6 +157,9 @@ struct ath10k_peer *ath10k_peer_find_by_id(struct ath10k *ar, int peer_id)
 {
 	struct ath10k_peer *peer;
 
+	if (peer_id >= sizeof(peer->peer_ids) * BITS_PER_BYTE)
+		return NULL;
+
 	lockdep_assert_held(&ar->data_lock);
 
 	list_for_each_entry(peer, &ar->peers, list)
-- 
1.9.1

