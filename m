Return-Path: <SRS0=VaBP=4Q=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD91C3F2D2
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Feb 2020 13:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 056BB246AF
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Feb 2020 13:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582896580;
	bh=WpulWYXNjMmsJjDJFze4v+KqLF35EV2VhMC+DHMskQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Px3WgXC8oElnUlpARdC6u3VELD9D1tCEFtHOpQBHmsrcyNdhTa4K8rheACsCGAzsr
	 Plnifju4tK2THqDZFkoNrBHLrDDjFe0rDlCgzms5bflWmq1uMeVxIehFVK1kyWjGRx
	 Lr0IHMVWwZFJFTG63ycKEHSKtcn66g56xh7bvXsQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgB1N3j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Feb 2020 08:29:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726418AbgB1N3i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Feb 2020 08:29:38 -0500
Received: from lore-desk-wlan.redhat.com (unknown [151.48.128.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95566246A3;
        Fri, 28 Feb 2020 13:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582896578;
        bh=WpulWYXNjMmsJjDJFze4v+KqLF35EV2VhMC+DHMskQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvs9TOm7grojbtJuMOUMYHCMN9Ie3ANnjyOr2SKhrXqPYDcmUNZQYU3eSGNEOziQf
         ziiicoc83mt16kLM5O0vbKDXdz150TmAzSaFDCt4GjGaeiAQKYQ17RdHes0//fVzWs
         bTTkLmX9OeBm9qpXjJ+3PXH08tdVvv9392JmG0Wo=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        sean.wang@mediatek.com
Subject: [PATCH 3/6] mt76: mt7615: introduce mt7615_mcu_wait_response
Date:   Fri, 28 Feb 2020 14:29:24 +0100
Message-Id: <302c1bd580882ece7215a5bbde41b2ac4ed1d1ef.1582893136.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1582893136.git.lorenzo@kernel.org>
References: <cover.1582893136.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt7615_mcu_wait_response in order to be reused parsing mt7663u
mcu messages

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 38 ++++++++++++-------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 9975ee3b6c99..43a376814be7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -174,12 +174,33 @@ mt7615_mcu_parse_response(struct mt7615_dev *dev, int cmd,
 	return ret;
 }
 
+int mt7615_mcu_wait_response(struct mt7615_dev *dev, int cmd, int seq)
+{
+	unsigned long expires = jiffies + 20 * HZ;
+	struct sk_buff *skb;
+	int ret = 0;
+
+	while (true) {
+		skb = mt76_mcu_get_response(&dev->mt76, expires);
+		if (!skb) {
+			dev_err(dev->mt76.dev, "Message %d (seq %d) timeout\n",
+				cmd, seq);
+			return -ETIMEDOUT;
+		}
+
+		ret = mt7615_mcu_parse_response(dev, cmd, skb, seq);
+		if (ret != -EAGAIN)
+			break;
+	}
+
+	return ret;
+}
+
 static int
 mt7615_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 		    int len, bool wait_resp)
 {
 	struct mt7615_dev *dev = container_of(mdev, struct mt7615_dev, mt76);
-	unsigned long expires = jiffies + 20 * HZ;
 	struct sk_buff *skb;
 	int ret, seq;
 
@@ -193,19 +214,8 @@ mt7615_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 	if (ret)
 		goto out;
 
-	while (wait_resp) {
-		skb = mt76_mcu_get_response(mdev, expires);
-		if (!skb) {
-			dev_err(mdev->dev, "Message %d (seq %d) timeout\n",
-				cmd, seq);
-			ret = -ETIMEDOUT;
-			break;
-		}
-
-		ret = mt7615_mcu_parse_response(dev, cmd, skb, seq);
-		if (ret != -EAGAIN)
-			break;
-	}
+	if (wait_resp)
+		ret = mt7615_mcu_wait_response(dev, cmd, seq);
 
 out:
 	mutex_unlock(&mdev->mcu.mutex);
-- 
2.24.1

