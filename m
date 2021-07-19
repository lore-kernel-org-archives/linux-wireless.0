Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A203AC07E9B
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Jul 2021 12:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8936760FF3
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Jul 2021 12:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237072AbhGSMFJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Jul 2021 08:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237036AbhGSMFJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jul 2021 08:05:09 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913D0C061574
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jul 2021 05:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=TILiGKn5ZgSt3qksBPhF5gkL3orPIRpg0GeIWN4V4tk=; t=1626698748; x=1627908348; 
        b=pHi0ZFIEi5B4SIRI/Hs6diY+pmE9Zxv/0292+2v/Cpej5lXD8LFu4dU5XZ60KpQS+h0bEDeNUkM
        5TplmYHirxFWBGWbdDGk0IaLBjavKHLwsi2+PyJQEXkwyK9k0A0ArsqYT0OTjx9bbaS+pmts/RflQ
        nJLOLlQu9HmWM+iWwWHmOBfZHyeXVApDCs6kEKMYYZSBDRwY8dfCVN1IwnLRUsZkdwvmsaMZZoocp
        CfpzAK3DoiOJBppqFQXB5So7KhLwMVSYoJNp8QHb+cv1ubuigP8tHNcudNhI8vD34OrtEUzzTVMUg
        /QvwkOQJo2dT12EzqGsrQ7QHNkWIzB1Y0MBA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1m5SeY-004MeZ-Rv; Mon, 19 Jul 2021 14:45:46 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Yaara Baruch <yaara.baruch@intel.com>
Subject: [PATCH 5.14 1/2] iwlwifi: add new SoF with JF devices
Date:   Mon, 19 Jul 2021 14:45:38 +0200
Message-Id: <20210719144523.0545d8964ff2.I3498879d8c184e42b1578a64aa7b7c99a18b75fb@changeid>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yaara Baruch <yaara.baruch@intel.com>

Add new SoF JF devices to the driver.

Signed-off-by: Yaara Baruch <yaara.baruch@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 16baee3d52ae..e8693be51fb1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1110,6 +1110,40 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_NO_CDB,
 		      iwl_cfg_bz_a0_mr_a0, iwl_ax211_name),
 
+/* SoF with JF2 */
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SOF, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
+		      IWL_CFG_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9560_160_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SOF, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
+		      IWL_CFG_NO_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9560_name),
+
+/* SoF with JF */
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SOF, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
+		      IWL_CFG_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9461_160_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SOF, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
+		      IWL_CFG_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9462_160_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SOF, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
+		      IWL_CFG_NO_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9461_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SOF, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
+		      IWL_CFG_NO_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9462_name),
+
 /* So with GF */
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
 		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
-- 
2.31.1

