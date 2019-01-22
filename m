Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E8B8C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:38:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFFA5217F4
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:38:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ruXVbOH0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbfAVPi3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:38:29 -0500
Received: from nbd.name ([46.4.11.11]:51084 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728628AbfAVPi2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:38:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qDA4GgKULD1C3a0i6q0kxauwsTsDrPsTXZLQ7N53zvw=; b=ruXVbOH048vMQigtts7BE1FKI+
        chCWZalyGXYaBvhBUE2vNRM1dmowkiPFWvlznrS0oBpW36pMH/sLur+a+KhuqeBDZarXm4H+6a0TZ
        PJ6cvEhumjeFcDms91Msf2+Km7jEkY1v3ocPD2YTl52XUWFDQwgJgNOZEtI3mZamS4lo=;
Received: by maeck.lan (Postfix, from userid 501)
        id D27694D26897; Tue, 22 Jan 2019 16:38:23 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mt76: avoid scheduling tx queues for powersave stations
Date:   Tue, 22 Jan 2019 16:38:23 +0100
Message-Id: <20190122153823.46270-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190122153823.46270-1-nbd@nbd.name>
References: <20190122153823.46270-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In case a tx queue wake call arrives after a client has transitioned to
powersave, make sure that the queue is not kept active until the client
has left powersave mode

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 1ea08ce62713..ef38e8626da9 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -396,6 +396,11 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
 	bool probe;
 	int idx;
 
+	if (test_bit(MT_WCID_FLAG_PS, &wcid->flags)) {
+		*empty = true;
+		return 0;
+	}
+
 	skb = mt76_txq_dequeue(dev, mtxq, false);
 	if (!skb) {
 		*empty = true;
-- 
2.17.0

