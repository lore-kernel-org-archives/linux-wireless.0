Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 185A1C004D2
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 18:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD02920684
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 18:04:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YlZOrunv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FyoIDOQY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD02920684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbeJCAsj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 20:48:39 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57218 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbeJCAsj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 20:48:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2CDCA60C63; Tue,  2 Oct 2018 18:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538503443;
        bh=PbBj6vOdPE36We5O25jLsEZowlkS/OTVb0/kGtfetUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlZOrunvolKMsbtdrzbpooTuzeR43N0jV9w+EXwc5mCG+Jo7M6Xc1Ep/XWx77Isry
         yQvjcGLX4qPMsbzIx3Zp9tOOzTu8EDBqbPj9FRpuiEzXeeP94c7O6zvxEYwKLbyEiY
         2hn0i55MNE8EAapBypiaxpOlx2AmPeegmvbteiGc=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 31C9860C4B;
        Tue,  2 Oct 2018 18:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538503442;
        bh=PbBj6vOdPE36We5O25jLsEZowlkS/OTVb0/kGtfetUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FyoIDOQYYgY2uGYA3MFGbxWuEzK+lSq6SeFCVtPA+EegAg5xO8uxlO++whAjiljkm
         T5iXdVcFVX/ph9LuYHnFoC7YYURT/CTvX+MHcyNCe9o2uuMm+qbCNKXy+cEoAa3bMc
         UvHwWGCcxgHowLnLmPRoMQC1HqJzyfNL4IyCLwxc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 31C9860C4B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH 2/2] ath10k: Enable bundle tx compl for management frames in WCN3990
Date:   Tue,  2 Oct 2018 23:33:41 +0530
Message-Id: <1538503421-17607-3-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1538503421-17607-1-git-send-email-pillair@codeaurora.org>
References: <1538503421-17607-1-git-send-email-pillair@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

WCN3990 sends tx completion of multiple management
frames bundled together in a single event, if the
host driver exposes the support to handle this
bundled tx completion event. This reduces the number
of WMI events which are sent to the host driver by
the target.

Set the BUNDLE_TX_COMPL flag in the host capability
flags when host sends the wmi init command, to indicate
the host capability to handle bundled tx completion for
management frames.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index f7d4f01..df8f673 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1685,7 +1685,7 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	cfg->num_ocb_vdevs = __cpu_to_le32(0);
 	cfg->num_ocb_channels = __cpu_to_le32(0);
 	cfg->num_ocb_schedules = __cpu_to_le32(0);
-	cfg->host_capab = __cpu_to_le32(0);
+	cfg->host_capab = __cpu_to_le32(WMI_TLV_FLAG_MGMT_BUNDLE_TX_COMPL);
 
 	ath10k_wmi_put_host_mem_chunks(ar, chunks);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index c575921..8014fc8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1580,6 +1580,8 @@ struct ath10k_mgmt_tx_pkt_addr {
 	dma_addr_t paddr;
 };
 
+#define WMI_TLV_FLAG_MGMT_BUNDLE_TX_COMPL	BIT(9)
+
 struct wmi_tlv_mgmt_tx_compl_ev {
 	__le32 desc_id;
 	__le32 status;
-- 
2.7.4

