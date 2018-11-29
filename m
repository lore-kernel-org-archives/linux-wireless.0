Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0822BC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 04:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD5872081B
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 04:25:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oecDjT10";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lbE/bGil"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD5872081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbeK2P32 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 10:29:28 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41084 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbeK2P32 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 10:29:28 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F352C60B26; Thu, 29 Nov 2018 04:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543465529;
        bh=z8RL8MfzKBdyBKvEXSMkXTnaGCxjqar3UsvqEc8Mwyc=;
        h=From:To:Cc:Subject:Date:From;
        b=oecDjT10jOeX36rJXGIgWInICnU+kNv9aBjEKzmUgIxcZ76RmZGqbCcVzo84AEHqc
         ixpvtxPqtICSI7081pGT7dCVd3uZhFWz5rW2kRshwkbkw/3rIXTqNWVTGvmwVvVT8m
         hMV3k6DGNRN16bVaSf581CtfxWbVEHM6io9l+TU8=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 193D6606DC;
        Thu, 29 Nov 2018 04:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543465528;
        bh=z8RL8MfzKBdyBKvEXSMkXTnaGCxjqar3UsvqEc8Mwyc=;
        h=From:To:Cc:Subject:Date:From;
        b=lbE/bGilvcyp6EHLo1/LWzS7LzporAClXF1rHs301PHn/cx/s5ycE/DdgEbgeOckr
         nP2ZExaxvK4hNA45wwh2Dla3Z/BCum8DIpqE27nZ9i5BFzEcqhR7uQXSgha3dehCqU
         IAjbYhZSiwAuWaEj8JOiTgb8a97SkCv0R5ACHJyQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 193D6606DC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH] ath10k: Move non-fatal warn logs to dbg level
Date:   Thu, 29 Nov 2018 09:55:22 +0530
Message-Id: <20181129042522.11767-1-govinds@codeaurora.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

During driver load below warn logs are printed in the console.
Since driver may not implement all wmi events sent by fw and
all of them are non-fatal, move this log to debug level to
remove un-necessary warn message on console.

[  361.887230] ath10k_snoc a000000.wifi: Unknown eventid: 16393
[  361.907037] ath10k_snoc a000000.wifi: Unknown eventid: 237569

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index ad4114a88170..892bd8c30dd9 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -621,7 +621,7 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_wmi_event_mgmt_tx_compl(ar, skb);
 		break;
 	default:
-		ath10k_warn(ar, "Unknown eventid: %d\n", id);
+		ath10k_dbg(ar, ATH10K_DBG_WMI, "Unknown eventid: %d\n", id);
 		break;
 	}
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

