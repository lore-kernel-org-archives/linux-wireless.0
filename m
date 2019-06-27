Return-Path: <SRS0=XE1e=U2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555B3C48BD6
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Jun 2019 00:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 233EF21738
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Jun 2019 00:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561595524;
	bh=USMiDlK7H+yjx2U+GMP0w+qgryIory1Gzbd3k1HhKrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ojR+tlFG90KOR5xH3sAq42rUW6LmtnRodFCHbdipy2wH3HxlSv+G6jvK4s57Hrt52
	 ib4gbxWV5Uyz9azlOnX+/TQlSVzZcCZMJsQ7CzAbBflKftuLyjtZtlU0UGzSGXdriv
	 mZ9BPG3vSUMiM2SZwijC8xmerjkx5JFdRBUe5ucM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbfF0AcC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Jun 2019 20:32:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbfF0AcA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jun 2019 20:32:00 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6ECD2083B;
        Thu, 27 Jun 2019 00:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595519;
        bh=USMiDlK7H+yjx2U+GMP0w+qgryIory1Gzbd3k1HhKrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3iJBDQ3pcJC03QlJdrw34EM4TsV6sFr5A+CZk+fuUb4BQOEQ5BgUiTKG/EHrPVRq
         sTHOCXO6mvq4OC5rFmmwbOw7gJhkHkvEbSRR84UIh8O2ZRVO+CJzFPTHsmCsyqyy0J
         UaWJMC3PlgV2waH6XmMLA0xkfIUjDCy15iSfou2M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 28/95] iwlwifi: Fix double-free problems in iwl_req_fw_callback()
Date:   Wed, 26 Jun 2019 20:29:13 -0400
Message-Id: <20190627003021.19867-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit a8627176b0de7ba3f4524f641ddff4abf23ae4e4 ]

In the error handling code of iwl_req_fw_callback(), iwl_dealloc_ucode()
is called to free data. In iwl_drv_stop(), iwl_dealloc_ucode() is called
again, which can cause double-free problems.

To fix this bug, the call to iwl_dealloc_ucode() in
iwl_req_fw_callback() is deleted.

This bug is found by a runtime fuzzing tool named FIZZER written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 689a65b11cc3..4fd1737d768b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1579,7 +1579,6 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	goto free;
 
  out_free_fw:
-	iwl_dealloc_ucode(drv);
 	release_firmware(ucode_raw);
  out_unbind:
 	complete(&drv->request_firmware_complete);
-- 
2.20.1

