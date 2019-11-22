Return-Path: <SRS0=Y0IC=ZO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E9EC432C3
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 06:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DB5120708
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 06:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574403490;
	bh=94Hv4Ms5a+mG/S8NzCllVzvp0s/I1gaMseaY+uS86uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=pyfbryiHwNY9MCrDPbc+oGpjE3xaP6bc0pC8IdG13sq8gG3cbuaHWdDoJxaHwxsPf
	 vrwPk66wUzRIvog9sH6ar5VFCMs7msXHaTLHINjLIs5yLKju2zI2ztQ6A0QUdKHy04
	 K+10DvrH7RmjlBpy/3ALY98vdFwHd/CD1gzd9iW0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbfKVGSG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Nov 2019 01:18:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729176AbfKVGNR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Nov 2019 01:13:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86FB620715;
        Fri, 22 Nov 2019 06:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403196;
        bh=94Hv4Ms5a+mG/S8NzCllVzvp0s/I1gaMseaY+uS86uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQ+nBFGcmv8og7zPy2GbNp9u8nsZJiCSlo3erRzDzGn1AD+O5PZH2K9mZr0nL98da
         6Cz+X+52Ms/74cwS36Z1UhSaNM/DXUgCMHURVg+kJrS9v0jwBmoyknBX5IsWHZuPVy
         ewv8w1oLNR2D44fDJFOF60T9QQbiVm2xjCsSngg8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 13/68] rtl818x: fix potential use after free
Date:   Fri, 22 Nov 2019 01:12:06 -0500
Message-Id: <20191122061301.4947-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit afbb1947db94eacc5a13302eee88a9772fb78935 ]

entry is released via usb_put_urb just after calling usb_submit_urb.
However, entry is used if the submission fails, resulting in a use after
free bug. The patch fixes this.

Signed-off-by: Pan Bian <bianpan2016@163.com>
ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
index b3691712df610..60e77eaa4ce94 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
@@ -446,12 +446,13 @@ static int rtl8187_init_urbs(struct ieee80211_hw *dev)
 		skb_queue_tail(&priv->rx_queue, skb);
 		usb_anchor_urb(entry, &priv->anchored);
 		ret = usb_submit_urb(entry, GFP_KERNEL);
-		usb_put_urb(entry);
 		if (ret) {
 			skb_unlink(skb, &priv->rx_queue);
 			usb_unanchor_urb(entry);
+			usb_put_urb(entry);
 			goto err;
 		}
+		usb_put_urb(entry);
 	}
 	return ret;
 
-- 
2.20.1

