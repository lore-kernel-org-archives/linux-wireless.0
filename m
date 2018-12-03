Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D651C04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 12:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99E5020878
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 12:24:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="oe351Zr6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99E5020878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbeLCMZH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 07:25:07 -0500
Received: from nbd.name ([46.4.11.11]:51624 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbeLCMZH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 07:25:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eUFRqr/XzlAkf82DVB9RPzs4eQ6xQ7kp7KkQGAds2ak=; b=oe351Zr6zvNLH7GVvuvUyFI9dT
        q5/sBy4Rry6qvAKepFJQOsPCFzUrxdyDCPs1+xrSkogklg1YJzfz7bvzDZoxbJ5UHgUQdMAW75esu
        slM625KUooEsL5cMJhCJU/Q7w1v4PPuyy27o64w6SBEhLfyqyB1mfZ27/m2nmEJsDBX0=;
Received: by maeck.lan (Postfix, from userid 501)
        id 7A236480F7A9; Mon,  3 Dec 2018 13:24:15 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] mt76: throttle transmission of buffered multicast packets
Date:   Mon,  3 Dec 2018 13:24:14 +0100
Message-Id: <20181203122415.22387-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181203122415.22387-1-nbd@nbd.name>
References: <20181203122415.22387-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Avoids drowning out regular transmissions

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 66315410aebe..6974acc75e2b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -121,9 +121,10 @@ static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
 		ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
 			IEEE80211_IFACE_ITER_RESUME_ALL,
 			mt76x02_add_buffered_bc, &data);
-	} while (nframes != skb_queue_len(&data.q));
+	} while (nframes != skb_queue_len(&data.q) &&
+		 skb_queue_len(&data.q) < 8);
 
-	if (!nframes)
+	if (!skb_queue_len(&data.q))
 		return;
 
 	for (i = 0; i < ARRAY_SIZE(data.tail); i++) {
-- 
2.17.0

