Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 865FEC6786F
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 20:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E5562082D
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 20:50:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E5562082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbeKCF6v (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 3 Nov 2018 01:58:51 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43181 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbeKCF6u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Nov 2018 01:58:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id y3-v6so2943206wrh.10
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2018 13:50:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ki2MvgubDdmFLQ/wk8y7i7JzQd4R4VZrQ63JkrFRQQw=;
        b=BUGSacGWuj5wLdbfjoRDHnVxrOXmhzAmIxu1DgyThW0aM7ZzNIS/kTwkTVycYy3Ne3
         Bl4Z8DkVJGEFkzfYHg+mMJYt1bPoMatMPR86lHXBkdrHBLCmeWcQF6wKydXHkBzBpZG5
         5g8fGoxIsjteRXksGKjYZCPtYwoqHD35sPoCy6EmIgrTulMM4AlE/nr8/ZgjRhHSE5C+
         K7jixI5YPmshz7nluCqpRwS9v1TrhYixwmrMrhbVdivIfNLT7Me8LWtA9L1i0Yv4fpLO
         nhqTXxXoOHfunePuVvIKKzLHVeY5TlkJ542iXvD90KhkLY58SbfXaxurmW8jqJBKx8up
         2qmQ==
X-Gm-Message-State: AGRZ1gL7YKricDDFh6k2kEvIrTeEaieNKpgVOEx85mujGcbsuh8o3890
        Fuk+29UyriZU4nQzOmbIffPA++Vnx9A=
X-Google-Smtp-Source: AJdET5e/y6cHwu+WFhwBnw2S495yJidcJONJhrXQoRWPeyW/G2TWwvUYLkM3pQlG/2j+nJGCYKoh5Q==
X-Received: by 2002:adf:e808:: with SMTP id o8-v6mr11520183wrm.112.1541191810974;
        Fri, 02 Nov 2018 13:50:10 -0700 (PDT)
Received: from localhost.localdomain ([151.66.16.197])
        by smtp.gmail.com with ESMTPSA id c14-v6sm28349450wmh.44.2018.11.02.13.50.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 13:50:10 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     koen.vandeputte@ncentric.com
Subject: [PATCH 3/5] ath9k: dynack: check da->enabled first in sampling routines
Date:   Fri,  2 Nov 2018 21:49:57 +0100
Message-Id: <abbbe99d9430b02875570101832ff7a2170a4b3c.1541190974.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1541190974.git.lorenzo.bianconi@redhat.com>
References: <cover.1541190974.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Check da->enabled flag first in ath_dynack_sample_tx_ts and
ath_dynack_sample_ack_ts routines in order to avoid useless
processing

Tested-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/ath/ath9k/dynack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dynack.c b/drivers/net/wireless/ath/ath9k/dynack.c
index 5c969d833825..5c3b32f4e61b 100644
--- a/drivers/net/wireless/ath/ath9k/dynack.c
+++ b/drivers/net/wireless/ath/ath9k/dynack.c
@@ -178,7 +178,7 @@ void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
 	u32 dur = ts->duration;
 	u8 ridx;
 
-	if ((info->flags & IEEE80211_TX_CTL_NO_ACK) || !da->enabled)
+	if (!da->enabled || (info->flags & IEEE80211_TX_CTL_NO_ACK))
 		return;
 
 	spin_lock_bh(&da->qlock);
@@ -251,7 +251,7 @@ void ath_dynack_sample_ack_ts(struct ath_hw *ah, struct sk_buff *skb,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
-	if (!ath_dynack_bssidmask(ah, hdr->addr1) || !da->enabled)
+	if (!da->enabled || !ath_dynack_bssidmask(ah, hdr->addr1))
 		return;
 
 	spin_lock_bh(&da->qlock);
-- 
2.19.1

