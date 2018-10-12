Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FFCC6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 09:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ED3420868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 09:30:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NpQvNXma";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GKZ0d+0s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0ED3420868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbeJLRBw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:01:52 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39164 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728027AbeJLRBw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:01:52 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4E30360AD8; Fri, 12 Oct 2018 09:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539336620;
        bh=JbRXAVIBWwD16QNZWzV+fa1aFbd2FdekTlbm6N+BsdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NpQvNXmaIrI8Csq6We7OfLtCE2F9IIgAnvf3MgT3EJUPArfbwF7VtKXVp6+TWA4Q7
         lF4xpZbvGstUicXZufUASt5u3QxLbmTJNZxKE0o8aSFPveCymxdwzjO7kOF64bri/P
         cZpcFlA++lGMvuZFtlzeYkWJ4LtkK9mgr2QyXn7o=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8ACC260B73;
        Fri, 12 Oct 2018 09:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539336619;
        bh=JbRXAVIBWwD16QNZWzV+fa1aFbd2FdekTlbm6N+BsdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKZ0d+0skSWNGzCLMHFPBvj4YaLuxbL8+hCtuxnuyYxw8nW6KjbKqAygM8QG6hUjk
         MUMiW2TOLLXOfYCVfZeZtksqVb3m3eUQw0jxlxA+nbDUoXVw7lO4CqBH1s/NSoBSkc
         wTV0oORMHwGXM1MgmtNvOF5qoMH7OGXRr4/YK/Aw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8ACC260B73
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 2/3] ath10k: Disable interface pause wow config for integrated chipset
Date:   Fri, 12 Oct 2018 15:00:02 +0530
Message-Id: <20181012093003.11932-3-govinds@codeaurora.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181012093003.11932-1-govinds@codeaurora.org>
References: <20181012093003.11932-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

wow pause iface config controls the PCI D0/D3-WOW cases for pcie
bus state. Firmware does not expects WOW_IFACE_PAUSE_ENABLED config
for bus/link that cannot be suspended ex:snoc and does not trigger
common subsystem shutdown.
Disable interface pause wow config for integrated chipset(WCN3990)
for correct WOW configuration in the firmware.

Testing:
    Tested on WCN3990 HW.
    Tested FW: WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 2 ++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 8c49a26fc571..1e608ef6499c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3185,6 +3185,8 @@ ath10k_wmi_tlv_op_gen_wow_enable(struct ath10k *ar)
 	cmd = (void *)tlv->value;
 
 	cmd->enable = __cpu_to_le32(1);
+	if (ar->hif.bus == ATH10K_BUS_SNOC)
+		cmd->pause_iface_config = WOW_IFACE_PAUSE_DISABLED;
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv wow enable\n");
 	return skb;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 3e1e340cd834..a8bdb5614b9b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1968,8 +1968,15 @@ struct wmi_tlv_set_quiet_cmd {
 	__le32 enabled;
 } __packed;
 
+enum wmi_tlv_wow_interface_cfg {
+	WOW_IFACE_PAUSE_ENABLED,
+	WOW_IFACE_PAUSE_DISABLED
+};
+
 struct wmi_tlv_wow_enable_cmd {
 	__le32 enable;
+	__le32 pause_iface_config;
+	__le32 flags;
 } __packed;
 
 struct wmi_tlv_wow_host_wakeup_ind {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

