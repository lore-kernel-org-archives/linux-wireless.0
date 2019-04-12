Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC99C10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 12:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3104B2171F
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 12:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555072068;
	bh=kOPEc8n97NX7DIoTCNbC5dTFy8hP1jRwfbIo+KcP2VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wc4KXH5pcxqZSpGS38N4OdNSXOThy5Dheqfk9gBYIULJjyhDjSWUicLGIW6TzMTET
	 jaD9QUdosUc8A5gIbr+RKoaJoixhDaE7DgcuMMc369PBdTvBjBU+Ksp0gvCRbooMw4
	 QHZXXr4rpSkS5wk5jWdJc6W4683EJgn2SrSeTYiI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfDLM1r (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 08:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbfDLM1r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 08:27:47 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C10F42082E;
        Fri, 12 Apr 2019 12:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555072066;
        bh=kOPEc8n97NX7DIoTCNbC5dTFy8hP1jRwfbIo+KcP2VE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnSu+s9uZECinRBKgM4efylYOxygS5eFhQLKCeFCBtA98GFkKAFacrPrgtl6n2L7e
         MxBojvpClqF6VhiTAkpWxcE/8UwKzAoJriCpml7Tmzr9qMYc9C3ZMwG+BrEZuAyMsY
         m2epa3WY5z8nBVdKdOkqnArkxA+rM41qK7lGd6DU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sgruszka@redhat.com
Subject: [PATCH] mt76: usb: fix possible memory leak during suspend/resume
Date:   Fri, 12 Apr 2019 14:27:16 +0200
Message-Id: <bdd1046beaee6104b1fcd25b1069f25db8f2fb20.1555071870.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1555071870.git.lorenzo@kernel.org>
References: <cover.1555071870.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Disable mt76u_tx_tasklet at the end of mt76u_stop_queues in order to
properly deallocate all pending skbs during suspend/resume phase

Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index a3acc070063a..575207133775 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -842,10 +842,10 @@ static void mt76u_stop_tx(struct mt76_dev *dev)
 void mt76u_stop_queues(struct mt76_dev *dev)
 {
 	tasklet_disable(&dev->usb.rx_tasklet);
-	tasklet_disable(&dev->usb.tx_tasklet);
-
 	mt76u_stop_rx(dev);
+
 	mt76u_stop_tx(dev);
+	tasklet_disable(&dev->usb.tx_tasklet);
 }
 EXPORT_SYMBOL_GPL(mt76u_stop_queues);
 
-- 
2.20.1

