Return-Path: <SRS0=kXDB=22=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1599AC33C8C
	for <linux-wireless@archiver.kernel.org>; Sun,  5 Jan 2020 12:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBAA2215A4
	for <linux-wireless@archiver.kernel.org>; Sun,  5 Jan 2020 12:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578226972;
	bh=cWYs4dQKQXCJyxCEyXYm1Mo0Ai1HYU/YvjiEm3565yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=H4FcDB6D3ko6DXJmfwo1nv/xcNKc/uewJXSlFd4CSUpFHbFoK7Z+V+ObL033OUw3C
	 SNLSyAK4Ie7G6MwW5GC5jPp+r6v25zjKPz6CkUjuKRghvCcGE17+ONo5SVRN8yARVw
	 plJsQySKgFC7CofsBr83VeNZsO1C9j7h7tT0TaZI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgAEMWv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 5 Jan 2020 07:22:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:47176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgAEMWu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Jan 2020 07:22:50 -0500
Received: from new-host-5.station (net-2-42-61-77.cust.vodafonedsl.it [2.42.61.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89D44215A4;
        Sun,  5 Jan 2020 12:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578226969;
        bh=cWYs4dQKQXCJyxCEyXYm1Mo0Ai1HYU/YvjiEm3565yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJ+M47n/sYDQoiFbgFbAxYwVoIL813U0f7zcLClYneei3+O2pbVTpDJqxmk5TjvpC
         HRCERCb0izqaTPl721OlWP5dPCZqYa69q6UEnoaruWFITOiMIlFPzpPepmD5PpzTGm
         9s0TrNCwOwf/YNFL+Fswq7j6t11KGYRyOTZ/TbDE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        Sean.Wang@mediatek.com
Subject: [PATCH v2 08/18] mt76: mt76u: introduce mt76u_free_rx_queue utility routine
Date:   Sun,  5 Jan 2020 13:21:46 +0100
Message-Id: <69a147d09c31f05fb2309dfa8b238a4b61617768.1578226544.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <cover.1578226544.git.lorenzo@kernel.org>
References: <cover.1578226544.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt76u_free_rx_queue utility routine to free rx hw queue.
This is a preliminary patch to support new devices (e.g. mt7663u) that
rely on a hw queue for mcu messages

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 96269e8eb170..8f0d92c11abf 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -627,9 +627,9 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 	return mt76u_submit_rx_buffers(dev, MT_RXQ_MAIN);
 }
 
-static void mt76u_free_rx(struct mt76_dev *dev)
+static void
+mt76u_free_rx_queue(struct mt76_dev *dev, struct mt76_queue *q)
 {
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 	struct page *page;
 	int i;
 
@@ -644,6 +644,13 @@ static void mt76u_free_rx(struct mt76_dev *dev)
 	memset(&q->rx_page, 0, sizeof(q->rx_page));
 }
 
+static void mt76u_free_rx(struct mt76_dev *dev)
+{
+	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+
+	mt76u_free_rx_queue(dev, q);
+}
+
 void mt76u_stop_rx(struct mt76_dev *dev)
 {
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
-- 
2.21.1

