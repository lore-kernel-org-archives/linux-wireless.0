Return-Path: <SRS0=676Y=DZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D19C433DF
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Oct 2020 19:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0EF520791
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Oct 2020 19:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603049345;
	bh=b0fn2WsIbPOHU2gdfv3rRmasaAVtIhOYtHllGMy7Ec4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=nQc7QFO2VraawQWFxhO2mbldcK95EctVCEq3/u/4EX9KcNn3l1JKpeP98Nwxhy0TJ
	 pvisTQvLS0BWYOCe7QauyEgTg0+NaGGF0OCghZiNrykPXmM04Vj4JR5VPBLX9WcHyE
	 5e1QA9oHPP9mFSwrdFZiZT+S5MkV+5gAjbU8zyN8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732362AbgJRT26 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 18 Oct 2020 15:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732236AbgJRT2G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Oct 2020 15:28:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F39422267;
        Sun, 18 Oct 2020 19:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049286;
        bh=b0fn2WsIbPOHU2gdfv3rRmasaAVtIhOYtHllGMy7Ec4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dg3UNtd2WUX9a/FPgR452iweL9uHA4ygujcMtt8HaRmW+AKL5A4+bsOidg4e+NVZg
         1jC7CSKEa09XukeARzO48hxRAAwdHYfeaNj8ic27N8S4U54bmIiZmTgCZcif+Lp55p
         eqfhsJNZCcokCMP8kvVyIvX2GT+QRk8PPW0AKZaw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Yufen <wangyufen@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 31/33] brcm80211: fix possible memleak in brcmf_proto_msgbuf_attach
Date:   Sun, 18 Oct 2020 15:27:26 -0400
Message-Id: <20201018192728.4056577-31-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192728.4056577-1-sashal@kernel.org>
References: <20201018192728.4056577-1-sashal@kernel.org>
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
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index f944f356d9c51..cacb43573f579 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -1530,6 +1530,8 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
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

