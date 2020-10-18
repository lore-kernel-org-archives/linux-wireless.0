Return-Path: <SRS0=676Y=DZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786FBC433DF
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Oct 2020 19:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AC5220714
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Oct 2020 19:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603050456;
	bh=w/Sna8B+cBW1cHgRCUsiscRCXsumyDFjekjoM3S3xXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=DCpzwii44ep3uTma6nSWuzzS0KpNCb6M2TuJZD/H3RY0ZPswh7T/xWcRjm5sT02NT
	 S69pJlr/0tz8ADOZisiEwpVbmlpXDzC9kCl8uG9LmYUSopBq+BiSEPSn+1RHuUkHDJ
	 dKooEclqaK9YBl0B1cH+39nO5BXIPzDxTKi6ZOQY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387490AbgJRTra (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 18 Oct 2020 15:47:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729807AbgJRTWW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Oct 2020 15:22:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B67D22314;
        Sun, 18 Oct 2020 19:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048942;
        bh=w/Sna8B+cBW1cHgRCUsiscRCXsumyDFjekjoM3S3xXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P6AUGVM9QCj6JjaWO5WpYU5kRkwzQnFNsvrPdt9AnGNV6HkjAZdjVkdxx1tK001EX
         gehHJ/AcjUtSsIlcYZn+slnqGj5oEsiWwVGhu4gtOqPIbVnoU6njKh+VdcQ98lwlxM
         GaablH1GuQGUSNW7BpbLY6EINSvdngalJG2SR8t4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Yufen <wangyufen@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 095/101] brcm80211: fix possible memleak in brcmf_proto_msgbuf_attach
Date:   Sun, 18 Oct 2020 15:20:20 -0400
Message-Id: <20201018192026.4053674-95-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 6c151410d5b57e6bb0d91a735ac511459539a7bf ]

When brcmf_proto_msgbuf_attach fail and msgbuf->txflow_wq != NULL,
we should destroy the workqueue.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1595237765-66238-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 8bb4f1fa790e7..1bb270e782ff2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -1619,6 +1619,8 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 					  BRCMF_TX_IOCTL_MAX_MSG_SIZE,
 					  msgbuf->ioctbuf,
 					  msgbuf->ioctbuf_handle);
+		if (msgbuf->txflow_wq)
+			destroy_workqueue(msgbuf->txflow_wq);
 		kfree(msgbuf);
 	}
 	return -ENOMEM;
-- 
2.25.1

