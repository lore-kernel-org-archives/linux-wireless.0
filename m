Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 965CCC46465
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 18:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58D7620892
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 18:56:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KDBtKGb+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58D7620892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbeKHE2f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Nov 2018 23:28:35 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38530 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbeKHE2e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Nov 2018 23:28:34 -0500
Received: by mail-pg1-f194.google.com with SMTP id f8-v6so7702091pgq.5
        for <linux-wireless@vger.kernel.org>; Wed, 07 Nov 2018 10:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pbwaPeUEJoEdr85WXuC4ND2vfZK37raJMfYBIrYR4BQ=;
        b=KDBtKGb+jD4/PcDjay8HX5M0LqdZMfbswWwiuhBML9fD2ce6NxFY6a1VwgljANls3d
         ebucecw2bL7NdaRpeMHMkM3+FY0JZa1b6oEkmhAh0J4DIn6493R/Jf1rpE4u1obtLlWr
         V8g1bEOdJvR7Ix5e6IeltlQHH2uKS9BrpNKw4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pbwaPeUEJoEdr85WXuC4ND2vfZK37raJMfYBIrYR4BQ=;
        b=KAEldTZieCK2vrB+TzIKreGEmDAopvK21OtaQ+Ls+x/aOvjVg0h3DEvmYibLjocM2X
         wLqrd+hy3E26o5Zb1zgf9Wt7gYIZMi3LGK+pG7hHY8jY7ZRJSugZOEzqfId2wDF/33z7
         qcUyxTVWRMBk+OeTjfNThLgXapr0Lc8gch+fCoT3HrSoZCujy+7SnVTicobJSuCxLdBr
         1nqaQ9kIWR7AEhvtfaGAqofdMvJkjyJAETDVWHszKwhzfd3JGZYiVvMoHWFGdzq0w+sF
         //NvargVv8rPz2DlnonC4wVXBn5LQsXf9r5S6WWgYyEloi+4Y0XocmbNTyhTNGGXKSZ0
         DYpQ==
X-Gm-Message-State: AGRZ1gLuWI1bgs2x2aiuVVIi5RKLf9Dnbw/f3EMxjLxrt42hl9jKK53T
        IPrbTvv7YwAGSdpKLcDjKvMLHw==
X-Google-Smtp-Source: AJdET5dzYB0oKvoN7+mzEmdSBbZjlsrWsEyihjMuU295A2yre7bbJ6OiKI8oV6gftphRy9EiidfL1w==
X-Received: by 2002:a63:4a4a:: with SMTP id j10-v6mr1223210pgl.0.1541617015219;
        Wed, 07 Nov 2018 10:56:55 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id k38sm3149009pgb.33.2018.11.07.10.56.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Nov 2018 10:56:54 -0800 (PST)
From:   Brian Norris <briannorris@chromium.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Yu Wang <yyuwang@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Govind Singh <govinds@codeaurora.org>, stable@vger.kernel.org
Subject: [PATCH REGRESSION] Revert "ath10k: add quiet mode support for QCA6174/QCA9377"
Date:   Wed,  7 Nov 2018 10:56:43 -0800
Message-Id: <20181107185643.240346-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.19.1.930.g4563a0d9d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This reverts commit cfb353c0dc058bc1619cc226d3cbbda1f360bdd3.

WCN3990 firmware does not yet implement this feature, and so it crashes
like this:

  fatal error received: err_qdi.c:456:EX:wlan_process:1:WLAN RT:207a:PC=b001b4f0

This feature can be re-implemented with a proper service bitmap or other
feature-discovery mechanism in the future. But it should not break
working boards.

Fixes: cfb353c0dc05 ("ath10k: add quiet mode support for QCA6174/QCA9377")
Cc: Yu Wang <yyuwang@codeaurora.org>
Cc: Rakesh Pillai <pillair@codeaurora.org>
Cc: Govind Singh <govinds@codeaurora.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 33 +----------------------
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 16 -----------
 2 files changed, 1 insertion(+), 48 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index ad4114a88170..099e78b5de1f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3209,37 +3209,6 @@ ath10k_wmi_tlv_op_gen_tdls_peer_update(struct ath10k *ar,
 	return skb;
 }
 
-static struct sk_buff *
-ath10k_wmi_tlv_op_gen_pdev_set_quiet_mode(struct ath10k *ar, u32 period,
-					  u32 duration, u32 next_offset,
-					  u32 enabled)
-{
-	struct wmi_tlv_set_quiet_cmd *cmd;
-	struct wmi_tlv *tlv;
-	struct sk_buff *skb;
-
-	skb = ath10k_wmi_alloc_skb(ar, sizeof(*tlv) + sizeof(*cmd));
-	if (!skb)
-		return ERR_PTR(-ENOMEM);
-
-	tlv = (void *)skb->data;
-	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_PDEV_SET_QUIET_CMD);
-	tlv->len = __cpu_to_le16(sizeof(*cmd));
-	cmd = (void *)tlv->value;
-
-	/* vdev_id is not in use, set to 0 */
-	cmd->vdev_id = __cpu_to_le32(0);
-	cmd->period = __cpu_to_le32(period);
-	cmd->duration = __cpu_to_le32(duration);
-	cmd->next_start = __cpu_to_le32(next_offset);
-	cmd->enabled = __cpu_to_le32(enabled);
-
-	ath10k_dbg(ar, ATH10K_DBG_WMI,
-		   "wmi tlv quiet param: period %u duration %u enabled %d\n",
-		   period, duration, enabled);
-	return skb;
-}
-
 static struct sk_buff *
 ath10k_wmi_tlv_op_gen_wow_enable(struct ath10k *ar)
 {
@@ -4143,7 +4112,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_dbglog_cfg = ath10k_wmi_tlv_op_gen_dbglog_cfg,
 	.gen_pktlog_enable = ath10k_wmi_tlv_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_tlv_op_gen_pktlog_disable,
-	.gen_pdev_set_quiet_mode = ath10k_wmi_tlv_op_gen_pdev_set_quiet_mode,
+	/* .gen_pdev_set_quiet_mode not implemented */
 	.gen_pdev_get_temperature = ath10k_wmi_tlv_op_gen_pdev_get_temperature,
 	/* .gen_addba_clear_resp not implemented */
 	/* .gen_addba_send not implemented */
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index bf8a4320c39c..5db294558ce5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1,7 +1,6 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -1980,21 +1979,6 @@ struct wmi_tlv_wow_add_del_event_cmd {
 	__le32 event_bitmap;
 } __packed;
 
-/* Command to set/unset chip in quiet mode */
-struct wmi_tlv_set_quiet_cmd {
-	__le32 vdev_id;
-
-	/* in TUs */
-	__le32 period;
-
-	/* in TUs */
-	__le32 duration;
-
-	/* offset in TUs */
-	__le32 next_start;
-	__le32 enabled;
-} __packed;
-
 struct wmi_tlv_wow_enable_cmd {
 	__le32 enable;
 } __packed;
-- 
2.19.1.930.g4563a0d9d0-goog

