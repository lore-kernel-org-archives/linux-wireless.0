Return-Path: <SRS0=LENq=3F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26AA2C33CAF
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 19:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED71E2053B
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 19:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579201298;
	bh=O1gW2xHsT7KaiHvrJKm6nT3L0TVBbK/KXOUm2+acMbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mAEPtyxYv3XYbNHrgXkEkRq0tQdkcXVlwRwXinOkp82qxJ3XzniIjulAfCRNF7W1w
	 MAR1LaFZZQuJRbhjZEBoWF+QSYJiC3BfikdC+jMMBO3pnFgYJlnExD8LT9U2Y/7yy1
	 wTevj02QkeSVLzBvP3BBenena1YZyu4yh5Q2XPzs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388791AbgAPRFv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:05:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:35264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388782AbgAPRFu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Jan 2020 12:05:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10E122192A;
        Thu, 16 Jan 2020 17:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194350;
        bh=O1gW2xHsT7KaiHvrJKm6nT3L0TVBbK/KXOUm2+acMbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3GwyvOAj9UNB4FflPr+LajT6Wo4n8p+8WbBk3bznxObKNARx7pA7Y3tYKJtjEo6g
         SU2NwpTbJvx0nDOvJuWT+6mNjvzGQ5t9UG3585jK1I0npTqTJKMtKrwCSh1gcWR2ZW
         feq2FL3pi0Uhp/cP4QRmTvyAC17X9hTXf/UM8lh0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 290/671] brcmfmac: fix leak of mypkt on error return path
Date:   Thu, 16 Jan 2020 11:58:48 -0500
Message-Id: <20200116170509.12787-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit a927e8d8ab57e696800e20cf09a72b7dfe3bbebb ]

Currently if the call to brcmf_sdiod_set_backplane_window fails then
error return path leaks mypkt. Fix this by returning by a new
error path labelled 'out' that calls brcmu_pkt_buf_free_skb to free
mypkt.  Also remove redundant check on err before calling
brcmf_sdiod_skbuff_write.

Addresses-Coverity: ("Resource Leak")
Fixes: a7c3aa1509e2 ("brcmfmac: Remove brcmf_sdiod_addrprep()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index d2f788d88668..710dc59c5d34 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -617,15 +617,13 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 
 	err = brcmf_sdiod_set_backplane_window(sdiodev, addr);
 	if (err)
-		return err;
+		goto out;
 
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	if (!err)
-		err = brcmf_sdiod_skbuff_write(sdiodev, sdiodev->func2, addr,
-					       mypkt);
-
+	err = brcmf_sdiod_skbuff_write(sdiodev, sdiodev->func2, addr, mypkt);
+out:
 	brcmu_pkt_buf_free_skb(mypkt);
 
 	return err;
-- 
2.20.1

