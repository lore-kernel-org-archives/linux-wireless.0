Return-Path: <SRS0=dpF5=4C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D73C3B1A1
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 16:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82BD4217F4
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 16:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581698170;
	bh=kqobUzNIK0zbxE3SOKiTCuJq60wEzhM2JkGtXbIxiek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=I1RkKFhs+u1aNBErObRbbVX6Ty0bCAGnDsOYLk6PFBwqQFIiuL3G1vhkFcOWnKLPd
	 Y0lP1KQfSsaXrI67h+ETrKnaitAApu+sV9e1C4vtdUV9uTUb1srzahxaJ6r0oYSrpN
	 9iXMmN4thocQ/YKgle2Xua41hIIpB21j71sqFDPc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393686AbgBNQgG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Feb 2020 11:36:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405888AbgBNQYa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Feb 2020 11:24:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4F622479D;
        Fri, 14 Feb 2020 16:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697469;
        bh=kqobUzNIK0zbxE3SOKiTCuJq60wEzhM2JkGtXbIxiek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2LOYZeMAOHfrw9UFGk/V2BL4VCqP43CuRPFJ+gnyp3I6lZ78hdc6+ZE3pPpE+kZX
         nY7BLEQqE7ftQ6rCRnsXe4nnhfGvDpe+WcD/1DX01yevAMrT9d/nZ0MF+w1kt3p+4F
         aRA34Om0lFGzMyTaNvGlYEV4SmFufS/jU4tCR9Lk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 003/100] brcmfmac: Fix use after free in brcmf_sdio_readframes()
Date:   Fri, 14 Feb 2020 11:22:47 -0500
Message-Id: <20200214162425.21071-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 216b44000ada87a63891a8214c347e05a4aea8fe ]

The brcmu_pkt_buf_free_skb() function frees "pkt" so it leads to a
static checker warning:

    drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:1974 brcmf_sdio_readframes()
    error: dereferencing freed memory 'pkt'

It looks like there was supposed to be a continue after we free "pkt".

Fixes: 4754fceeb9a6 ("brcmfmac: streamline SDIO read frame routine")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index 9954e641c943d..8bb028f740fd8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -2027,6 +2027,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					       BRCMF_SDIO_FT_NORMAL)) {
 				rd->len = 0;
 				brcmu_pkt_buf_free_skb(pkt);
+				continue;
 			}
 			bus->sdcnt.rx_readahead_cnt++;
 			if (rd->len != roundup(rd_new.len, 16)) {
-- 
2.20.1

