Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15809C6786F
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 15:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF47C2081B
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 15:29:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BCsbeIHK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF47C2081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbeKBAdM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 20:33:12 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38337 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728298AbeKBAdM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 20:33:12 -0400
Received: by mail-pf1-f193.google.com with SMTP id b11-v6so9507977pfi.5;
        Thu, 01 Nov 2018 08:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=b2PzhwDdAp0pEpUPsO0H72CNFryAo9nWwGPZaOICtvI=;
        b=BCsbeIHK1ujJ16Eymh4835mLlsPQ3ij5lrb4sr/dgbIR5WtQGP0qojnzJr+TpL9nTm
         gMQU47Qjwa5BLPS7TuHdEgtGnzTk4ppxxjpKTtIYPJ30aOiwXqi51eCIxIz+FEsO6Nrd
         qR/y1oGQ1ITaFEymhmLTxELTr4AOfN0YCP7/QWGcdwhTQiz6G4STZXsX2cqOBpn5sVmD
         czZ3X4PT/APpAzyrhA2vghmK8eZeF6S7qPIZJO+IbR7JgW4eS8s9IFN7/RW0PP6qZsbs
         BXyABRdXfRlHbT3LipyBU7gm95DSQ7ftMKySeOIktZZ/FAY4O3N99tuude69vEK0oeMJ
         o39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=b2PzhwDdAp0pEpUPsO0H72CNFryAo9nWwGPZaOICtvI=;
        b=mY0QZvvtEMlZcSQLFYbE53R5Qk1dt7u8EbSy8o0HC4s4M8vfiXrhBCLztmiUfsb09x
         MSnzKSkq7RwmlAAmcmBzSqyFXO9BNHUeTLw1KIsWkftGR8QVNC8Z+ZZdQP1wjTnQRZGG
         w0Mpwfmpb7gTAor/HhX/IbHD8zZXS6SphjbkQdrmcf/FkZapJVkoqlxYutHI1v7m8xKv
         J4GnWyhyo291oK08U5KzgeafqnSN1/QCXjIIsKHRhy26RMgq0MrKRxCErPv4lSJxUNUU
         fw9M77+yNjMnp09JG195tuZ0Us4swIbSn+92yVdm8Tb/dWSD6zkpLDrXlnQnYbfGVLyt
         5ayA==
X-Gm-Message-State: AGRZ1gLMCGvDGePvyIzjrabTd8OiSPd0BUQmR8bfwyJXo85f4dtk3LXW
        k3lVCpPiWm5et9a72/YUcSI=
X-Google-Smtp-Source: AJdET5d4nWVVtEC2MzpYog8M16+VSET60ff6OVihh9d63iwSKyHQD+oJ+rxmH/MpjTUSA1x8/X7JgA==
X-Received: by 2002:a65:580d:: with SMTP id g13-v6mr7059331pgr.370.1541086185410;
        Thu, 01 Nov 2018 08:29:45 -0700 (PDT)
Received: from localhost (68.168.130.77.16clouds.com. [68.168.130.77])
        by smtp.gmail.com with ESMTPSA id b29-v6sm57412054pfj.183.2018.11.01.08.29.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 01 Nov 2018 08:29:44 -0700 (PDT)
From:   Yangtao Li <tiny.windzz@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yangtao Li <tiny.windzz@gmail.com>
Subject: [PATCH] ath10k: fix some typo
Date:   Thu,  1 Nov 2018 11:29:32 -0400
Message-Id: <20181101152932.22684-1-tiny.windzz@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
---
 drivers/net/wireless/ath/ath10k/wow.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wow.c b/drivers/net/wireless/ath/ath10k/wow.c
index a6b179f88d36..e834c25a9330 100644
--- a/drivers/net/wireless/ath/ath10k/wow.c
+++ b/drivers/net/wireless/ath/ath10k/wow.c
@@ -135,7 +135,7 @@ static void ath10k_wow_convert_8023_to_80211
 	       &old_hdr_mask->h_proto,
 	       sizeof(old_hdr_mask->h_proto));
 
-	/* Caculate new pkt_offset */
+	/* Calculate new pkt_offset */
 	if (old->pkt_offset < ETH_ALEN)
 		new->pkt_offset = old->pkt_offset +
 			offsetof(struct ieee80211_hdr_3addr, addr1);
@@ -146,7 +146,7 @@ static void ath10k_wow_convert_8023_to_80211
 	else
 		new->pkt_offset = old->pkt_offset + hdr_len + rfc_len - ETH_HLEN;
 
-	/* Caculate new hdr end offset */
+	/* Calculate new hdr end offset */
 	if (total_len > ETH_HLEN)
 		hdr_80211_end_offset = hdr_len + rfc_len;
 	else if (total_len > offsetof(struct ethhdr, h_proto))
-- 
2.17.0

