Return-Path: <SRS0=LENq=3F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 520FEC33CB6
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 16:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EC49217F4
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 16:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579193108;
	bh=HSzZeyZOCMTW1ielyMng8hwcj7scf2yJ/mEbaDIbSvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hnRTsu2cC9om/gbvLvM3Kr2tomRi+skkBmHX6CRzAaVFd2i3j4I7hPSJneooYvNcO
	 JaiepVzRdqhJAsUqBZfJv4bgipYCfO+nkct2JvEsFed33M0rJZcqFNourWXNDkBpbJ
	 k9ZuXM/eZgVAeZ96wLTfCfxn52cDuI1tjDP5rr7A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgAPQo7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:44:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:53396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729005AbgAPQoz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Jan 2020 11:44:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6B5E214AF;
        Thu, 16 Jan 2020 16:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193094;
        bh=HSzZeyZOCMTW1ielyMng8hwcj7scf2yJ/mEbaDIbSvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vophNceU86Fbag6iPOZjamwVVsIBcM/EnkYo5h8etoiNFSjVOkjU2nBSmyzReAUOE
         Vk0f4aawOc7AttaXA/YXDcMvY4LcPj37TAIbMv6RBrBuA1SOH+KVjdFTfyD0L6EjEc
         bUtF5y0372VWIH78Xa+8P9V0pZaU2+/4snpxHIwo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 023/205] rtw88: fix error handling when setup efuse info
Date:   Thu, 16 Jan 2020 11:39:58 -0500
Message-Id: <20200116164300.6705-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit f4268729eb1eefe23f6746849c1b5626d9030532 ]

Disable efuse if the efuse is enabled when we failed to setup the efuse
information, otherwise the hardware will not turn off.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 7a3a4911bde2..806af37192bc 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1048,19 +1048,19 @@ static int rtw_chip_efuse_info_setup(struct rtw_dev *rtwdev)
 	/* power on mac to read efuse */
 	ret = rtw_chip_efuse_enable(rtwdev);
 	if (ret)
-		goto out;
+		goto out_unlock;
 
 	ret = rtw_parse_efuse_map(rtwdev);
 	if (ret)
-		goto out;
+		goto out_disable;
 
 	ret = rtw_dump_hw_feature(rtwdev);
 	if (ret)
-		goto out;
+		goto out_disable;
 
 	ret = rtw_check_supported_rfe(rtwdev);
 	if (ret)
-		goto out;
+		goto out_disable;
 
 	if (efuse->crystal_cap == 0xff)
 		efuse->crystal_cap = 0;
@@ -1087,9 +1087,10 @@ static int rtw_chip_efuse_info_setup(struct rtw_dev *rtwdev)
 	efuse->ext_pa_5g = efuse->pa_type_5g & BIT(0) ? 1 : 0;
 	efuse->ext_lna_2g = efuse->lna_type_5g & BIT(3) ? 1 : 0;
 
+out_disable:
 	rtw_chip_efuse_disable(rtwdev);
 
-out:
+out_unlock:
 	mutex_unlock(&rtwdev->mutex);
 	return ret;
 }
-- 
2.20.1

