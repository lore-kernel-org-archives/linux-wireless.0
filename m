Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D6AC10F03
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 584F62082F
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Jh3ZrPN/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfCDICt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 03:02:49 -0500
Received: from nbd.name ([46.4.11.11]:40456 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbfCDICs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 03:02:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RcUSrRnHZF8rDm/6jQoPWJfO4XydLSEsT6AYKQzJOhU=; b=Jh3ZrPN/lX52BFArrbiTh0MVNe
        rM7tcJXrb9JtnOZky1d52jZHTYgpPgmrD06MdAkLtlNtUL7d47D7tA60ArtsjTIxYUEoNA4aYIvxy
        yb9akKxEk9IJsAJIeBFAPq8JS8+zxxUgRarYWpbkid2ASYKQ2NiilnQAeZn9pk17qxjA=;
Received: by maeck.lan (Postfix, from userid 501)
        id 1959250E5413; Mon,  4 Mar 2019 09:02:34 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 11/11] mt76: mt7603: set moredata flag when queueing ps-filtered packets
Date:   Mon,  4 Mar 2019 09:02:34 +0100
Message-Id: <20190304080234.3221-11-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190304080234.3221-1-nbd@nbd.name>
References: <20190304080234.3221-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Clients should poll for more packets afterwards

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7603/main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index ea25eff5e81c..cc0fe0933b2d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -5,6 +5,7 @@
 #include <linux/pci.h>
 #include <linux/module.h>
 #include "mt7603.h"
+#include "mac.h"
 #include "eeprom.h"
 
 static int
@@ -385,6 +386,15 @@ mt7603_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
 	mt7603_ps_tx_list(dev, &list);
 }
 
+static void
+mt7603_ps_set_more_data(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr;
+
+	hdr = (struct ieee80211_hdr *) &skb->data[MT_TXD_SIZE];
+	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+}
+
 static void
 mt7603_release_buffered_frames(struct ieee80211_hw *hw,
 			       struct ieee80211_sta *sta,
@@ -411,6 +421,7 @@ mt7603_release_buffered_frames(struct ieee80211_hw *hw,
 
 		skb_set_queue_mapping(skb, MT_TXQ_PSD);
 		__skb_unlink(skb, &msta->psq);
+		mt7603_ps_set_more_data(skb);
 		__skb_queue_tail(&list, skb);
 		nframes--;
 	}
-- 
2.17.0

