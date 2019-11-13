Return-Path: <SRS0=dvfj=ZF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3590BC17441
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 01:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05ACA2246A
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 01:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573610392;
	bh=n3L8c49TwuPiA6F7l7w64tmiblH3+gobPtPSx1j/Ylg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WDLGI13S/uAW5ehQVVMIWs3PBvqL3Vo22LfqpcZt7XQM3Q7I3BB0ychmbwYRzrxMs
	 GlrHSdP8/I+dTVmEm/UFDUoPzCH07FKAEYtH0U7AwRzov7MhGeT60vCFag0SE7mHF6
	 4J/xoE0C1yNuYFswHtai1I3QG1cFvmkxjvJtg/f0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbfKMB7v (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Nov 2019 20:59:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730336AbfKMB7t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Nov 2019 20:59:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19EA222474;
        Wed, 13 Nov 2019 01:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610388;
        bh=n3L8c49TwuPiA6F7l7w64tmiblH3+gobPtPSx1j/Ylg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3ovXAGBZrJBHKh1amI/eHFXz5vxS9AGZQ+Cv9Pl3pgE199RzgFTwHF0e61ju89qz
         eFGrkmwKebmSGLoHZns77CZ2bHU++RIXG3r5plKJBYKAztfH91AjZzyV7HbF1Un7I0
         pcAW2pAoX21wpe78fmbH9NHw73N2ezAv+AChaGjE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Simon Wunderlich <sw@simonwunderlich.de>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/68] ath9k: fix reporting calculated new FFT upper max
Date:   Tue, 12 Nov 2019 20:58:35 -0500
Message-Id: <20191113015932.12655-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>

[ Upstream commit 4fb5837ac2bd46a85620b297002c704e9958f64d ]

Since the debug print code is outside of the loop, it shouldn't use the loop
iterator anymore but instead print the found maximum index.

Cc: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index eedf86b67cf51..807fbe31e9303 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -411,7 +411,7 @@ ath_cmn_process_ht20_40_fft(struct ath_rx_status *rs,
 
 		ath_dbg(common, SPECTRAL_SCAN,
 			"Calculated new upper max 0x%X at %i\n",
-			tmp_mag, i);
+			tmp_mag, fft_sample_40.upper_max_index);
 	} else
 	for (i = dc_pos; i < SPECTRAL_HT20_40_NUM_BINS; i++) {
 		if (fft_sample_40.data[i] == (upper_mag >> max_exp))
-- 
2.20.1

