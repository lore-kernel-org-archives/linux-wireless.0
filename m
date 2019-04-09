Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC15C282DA
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 19:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E51FB2084F
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 19:13:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pC1ZcmoT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfDITNM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 15:13:12 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38828 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfDITNL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 15:13:11 -0400
Received: by mail-lf1-f66.google.com with SMTP id u24so6290967lfg.5
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 12:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JTmqFgNzwEMzX2/VlhCrZe+jbyHjEvWhfr0MDtw6xTw=;
        b=pC1ZcmoTKR3Ap0XaWQQc4TYYu/EHakvd5TXVBzTZqL98eum0L5KOGxZFwvkhHQDbkL
         UQXlme+c9QhKsEbDUoszUwP55TXZ4UK94uc3VnD92hbND6KxU2zkUPtaT/oX40xmHrAM
         Nkt20Pno7YKQlnKRzd5nxGKyhWOpAOsYNB/FVnD5ZeTJ4XMBm2DZROA69JWRfSJtvukE
         TRfS7l3m0cI7ARtIwvAoNKbhze7qAkkColOQOr0DgXPXB+tVFWK8etj5gSqYuBjZtHgt
         upAaZhGflDFiVzoPfq9vZ7KpWVRh6nUnQwV0a23WbgecI8Ik3Cczj3G9FO5teFH6ttww
         mp3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JTmqFgNzwEMzX2/VlhCrZe+jbyHjEvWhfr0MDtw6xTw=;
        b=taGhvcNJHmsQ0lEArrI1vOpcYA1j/zG9vcUkgQ4l2kEoq3tFkz2ZAvGcqMzZDooV9f
         U242awiAHlPh+NCoY+fk0Wyb4zlHaY3nI6SpX99BZY2nxQoYIHzuImA2XXPKH7iuYNak
         6w4z0Yl0v3OjcszsUjBLOswiZlPJT4hVvtdePulZQLyAKp0JyanVUglK8c6N/ftQ9XRA
         Yk5Wj/Z+LgETv3otaBLw16wBwe2sWd4dzxxN5WaKCNlb+pk1cbsrIhr+Vi1cy8l8Ir/P
         TgEtBsLvWNgcQOui8en/1DwZWeR5G1QnAGTbeZjN7A0DHGGD/ua/iI5OFFT33g65Wu19
         0qoQ==
X-Gm-Message-State: APjAAAV3g4rnwe4LWIDk6OsfnKmC4sjG758Enq3dlY6ruGV8b74XitsX
        G/AWXpaMQE/D5S7mH+y/2Pc=
X-Google-Smtp-Source: APXvYqwjtw/cM8UKKmcgwTqXVc4IPi2Wtt0XLMfSe6E1k+AFaD6A9De9eWAkEVpY9ZpRqJxJyfmyRQ==
X-Received: by 2002:a19:e30a:: with SMTP id a10mr4246969lfh.58.1554837189007;
        Tue, 09 Apr 2019 12:13:09 -0700 (PDT)
Received: from localhost.localdomain (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id q64sm6807848ljq.76.2019.04.09.12.13.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Apr 2019 12:13:08 -0700 (PDT)
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
To:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     Alagu Sankar <alagusankar@silex-india.com>
Subject: [PATCH 2/6] ath10k: high latency fixes for beacon buffer
Date:   Tue,  9 Apr 2019 21:08:47 +0200
Message-Id: <20190409190851.4557-3-erik.stromdahl@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190409190851.4557-1-erik.stromdahl@gmail.com>
References: <20190409190851.4557-1-erik.stromdahl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alagu Sankar <alagusankar@silex-india.com>

Beacon buffer for high latency devices does not use DMA. other similar
buffer allocation methods in the driver have already been modified for
high latency path. Fix the beacon buffer allocation left out in the
earlier high latency changes.

Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 31 ++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c9e700b844f8..2dd99ce44453 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -953,8 +953,12 @@ static void ath10k_mac_vif_beacon_cleanup(struct ath10k_vif *arvif)
 	ath10k_mac_vif_beacon_free(arvif);
 
 	if (arvif->beacon_buf) {
-		dma_free_coherent(ar->dev, IEEE80211_MAX_FRAME_LEN,
-				  arvif->beacon_buf, arvif->beacon_paddr);
+		if (ar->dev_type == ATH10K_DEV_TYPE_HL)
+			kfree(arvif->beacon_buf);
+		else
+			dma_free_coherent(ar->dev, IEEE80211_MAX_FRAME_LEN,
+					  arvif->beacon_buf,
+					  arvif->beacon_paddr);
 		arvif->beacon_buf = NULL;
 	}
 }
@@ -5210,10 +5214,17 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	if (vif->type == NL80211_IFTYPE_ADHOC ||
 	    vif->type == NL80211_IFTYPE_MESH_POINT ||
 	    vif->type == NL80211_IFTYPE_AP) {
-		arvif->beacon_buf = dma_alloc_coherent(ar->dev,
-						       IEEE80211_MAX_FRAME_LEN,
-						       &arvif->beacon_paddr,
-						       GFP_ATOMIC);
+		if (ar->dev_type == ATH10K_DEV_TYPE_HL) {
+			arvif->beacon_buf = kmalloc(IEEE80211_MAX_FRAME_LEN,
+						    GFP_KERNEL);
+			arvif->beacon_paddr = (dma_addr_t)arvif->beacon_buf;
+		} else {
+			arvif->beacon_buf =
+				dma_alloc_coherent(ar->dev,
+						   IEEE80211_MAX_FRAME_LEN,
+						   &arvif->beacon_paddr,
+						   GFP_ATOMIC);
+		}
 		if (!arvif->beacon_buf) {
 			ret = -ENOMEM;
 			ath10k_warn(ar, "failed to allocate beacon buffer: %d\n",
@@ -5424,8 +5435,12 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 err:
 	if (arvif->beacon_buf) {
-		dma_free_coherent(ar->dev, IEEE80211_MAX_FRAME_LEN,
-				  arvif->beacon_buf, arvif->beacon_paddr);
+		if (ar->dev_type == ATH10K_DEV_TYPE_HL)
+			kfree(arvif->beacon_buf);
+		else
+			dma_free_coherent(ar->dev, IEEE80211_MAX_FRAME_LEN,
+					  arvif->beacon_buf,
+					  arvif->beacon_paddr);
 		arvif->beacon_buf = NULL;
 	}
 
-- 
2.19.1

