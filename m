Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F45C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 13:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 173732184A
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 13:48:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mrTxKT8A";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mrTxKT8A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729960AbfBLNsT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 08:48:19 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60520 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727428AbfBLNsT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 08:48:19 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 63CE060770; Tue, 12 Feb 2019 13:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549979298;
        bh=LnzSpdR2CIxHpUzst55xOm6Fil8GNvpR6RFONl2pLgA=;
        h=From:To:Cc:Subject:Date:From;
        b=mrTxKT8AOemrAvGcIFO47tkV7CQgp5O0gpDSM6MONxnrYyNVwdJd+g1qxOfgrHWtw
         azdSPFAF2o3J9U/m5WbgXY7hmFkmVkq0OJ5USm0bbtl3TWeFA/w2r4ur3E5nIG1eDt
         AS3luj11nNbrbSAb7wnSDsXUasyl1xKfQZmjvSus=
Received: from dundi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dundi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DBD6360208;
        Tue, 12 Feb 2019 13:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549979298;
        bh=LnzSpdR2CIxHpUzst55xOm6Fil8GNvpR6RFONl2pLgA=;
        h=From:To:Cc:Subject:Date:From;
        b=mrTxKT8AOemrAvGcIFO47tkV7CQgp5O0gpDSM6MONxnrYyNVwdJd+g1qxOfgrHWtw
         azdSPFAF2o3J9U/m5WbgXY7hmFkmVkq0OJ5USm0bbtl3TWeFA/w2r4ur3E5nIG1eDt
         AS3luj11nNbrbSAb7wnSDsXUasyl1xKfQZmjvSus=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DBD6360208
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=dundi@codeaurora.org
From:   Dundi Raviteja <dundi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Dundi Raviteja <dundi@codeaurora.org>
Subject: [PATCH] ath10k: Enable support for beacon interval per VAP
Date:   Tue, 12 Feb 2019 19:18:06 +0530
Message-Id: <1549979286-9255-1-git-send-email-dundi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Enable support to configure different beacon interval per VAP.

To support this feature, map different beacon interval service bit
to wmi tlv service.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Signed-off-by: Dundi Raviteja <dundi@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c     | 33 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  3 +++
 2 files changed, 36 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e49b367..09c4705 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8232,6 +8232,30 @@ void ath10k_mac_destroy(struct ath10k *ar)
 	},
 };
 
+static struct
+ieee80211_iface_combination ath10k_tlv_qcs_bcn_int_if_comb[] = {
+	{
+		.limits = ath10k_tlv_if_limit,
+		.num_different_channels = 1,
+		.max_interfaces = 4,
+		.beacon_int_infra_match = true,
+		.beacon_int_min_gcd = 1,
+		.n_limits = ARRAY_SIZE(ath10k_tlv_if_limit),
+	},
+	{
+		.limits = ath10k_tlv_qcs_if_limit,
+		.num_different_channels = 2,
+		.max_interfaces = 4,
+		.n_limits = ARRAY_SIZE(ath10k_tlv_qcs_if_limit),
+	},
+	{
+		.limits = ath10k_tlv_if_limit_ibss,
+		.num_different_channels = 1,
+		.max_interfaces = 2,
+		.n_limits = ARRAY_SIZE(ath10k_tlv_if_limit_ibss),
+	},
+};
+
 static const struct ieee80211_iface_limit ath10k_10_4_if_limits[] = {
 	{
 		.max = 1,
@@ -8642,6 +8666,15 @@ int ath10k_mac_register(struct ath10k *ar)
 				ath10k_tlv_qcs_if_comb;
 			ar->hw->wiphy->n_iface_combinations =
 				ARRAY_SIZE(ath10k_tlv_qcs_if_comb);
+
+			if (test_bit
+			    (WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
+			    ar->wmi.svc_map)) {
+				ar->hw->wiphy->iface_combinations =
+						ath10k_tlv_qcs_bcn_int_if_comb;
+				ar->hw->wiphy->n_iface_combinations =
+				     ARRAY_SIZE(ath10k_tlv_qcs_bcn_int_if_comb);
+			}
 		} else {
 			ar->hw->wiphy->iface_combinations = ath10k_tlv_if_comb;
 			ar->hw->wiphy->n_iface_combinations =
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index e07e990..9f78502 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1567,6 +1567,9 @@ enum wmi_tlv_service {
 	SVCMAP(WMI_TLV_SERVICE_THERM_THROT,
 	       WMI_SERVICE_THERM_THROT,
 	       WMI_TLV_MAX_SERVICE);
+	SVCMAP(WMI_TLV_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
+	       WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
+	       WMI_TLV_MAX_SERVICE);
 }
 
 #undef SVCMAP
-- 
1.9.1

