Return-Path: <SRS0=Y0IC=ZO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED53C43215
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 05:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D15A2068F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 05:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574402169;
	bh=nqrDeAiqwjw67y0i2EHRlzpeX2mJIKdZBClni9COesA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LLjsFGcuqj+kep08iBN8K4u+JvkFCvgU4vNoWQjGzpf8PxtP3x4iL+aTQKVF08jRS
	 yheKYfw60tclngvgn8zVXjMwSX6UgS3bA/TWdXA5QSWNuEiW/oVXTlBGvtU4fj/Bhp
	 lyT1eHs3Y1OmjeE5IAXwbHxa0q3s7W3T30aFCQac=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbfKVF4I (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Nov 2019 00:56:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729009AbfKVF4H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Nov 2019 00:56:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B0C220717;
        Fri, 22 Nov 2019 05:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402166;
        bh=nqrDeAiqwjw67y0i2EHRlzpeX2mJIKdZBClni9COesA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Yf8DZNhYDzCTbB7zQOHOcsNMC435pbuKpZbnefXVXGdwUwd/T8sFSPSepSQNkXRn
         hDYV+cJXdksStHs4EtTGarDdxtM+hB4TKqbYVRGq+cefikqeoAymMWWS6t0SMWcmm6
         R1vCMDjBf4RIz5ZOhag/8HX2seTgPQ7VUiAldFC8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 019/127] rtl818x: fix potential use after free
Date:   Fri, 22 Nov 2019 00:53:57 -0500
Message-Id: <20191122055544.3299-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
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
index 9a1d15b3ce453..518caaaf8a987 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
@@ -444,12 +444,13 @@ static int rtl8187_init_urbs(struct ieee80211_hw *dev)
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

