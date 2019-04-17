Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF0EC282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 19:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68B3B2073F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 19:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MMKpWSzM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733305AbfDQTPa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 15:15:30 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45948 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbfDQTP3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 15:15:29 -0400
Received: by mail-lf1-f67.google.com with SMTP id t11so15226490lfl.12
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2019 12:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7BeD/gfKhVLmh4MRlzIfvgwYkglG8WzGBT5xlk8Q0iE=;
        b=MMKpWSzMd/5QaHBHymjxwQRyqZwkWLj2b5L5ebbu5DQAakLuh/X17aZnUYnWNS9Gkm
         mhBWVCjxaJbLuABVSbgdBH4IP4qv887eln+dfgrYqOspmv723IhGLGkKg2EV2jvSIAk5
         3t6umqSBYbvn1GoMLHL5CFVg+VwBmvA7EesuQ2gRIO87VYH6mdJlzhhE830Yjwz0hyrB
         EWFMCyRHQtwbVQFvsmNePUPyslb4+oXQ+qShmaYMMdJo7hd76dwvzfSO1Ml4cATwtFfu
         kVtxG9mIymNo0p8m2HXxhLpLSWNSdViYnSpqLEfzlIY4HAmUG7oYxcIhV8eTJq7z2a2H
         7wQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7BeD/gfKhVLmh4MRlzIfvgwYkglG8WzGBT5xlk8Q0iE=;
        b=lMm6ESI2XYNPsV6JwWhOfR2HfRSUunYnoS2L1+NUlhoqnbNKiQ12pq0cuiqgDzaANW
         TICVmX6huPzoJT5Y69SbIf8emP5T65aP3I+dk8XXBDZGJJ6AWWgQ5o2cdVMn99A2l4Qs
         EaAlKX7Jbl0zTkJseegewSHZfKdTZj08rSYkLhLDDoG1OYXMhdGPmw8jk5K8tIxos6hR
         OGSh19JayXxWLI75pPxiEWeAEwQltFEQF6P8SepjiHSnobRMwkbcanD/Y8fXnIvnXYKy
         9aEW8B7fr1OLiyoGRpCJtHQt966CvYGo5w+DQFUFNdbTBFAsVVrmx40ov58E3/gaGwjr
         Q5pA==
X-Gm-Message-State: APjAAAXOp9EE5rnj1dc1pzjF8mq/UZAy3nq/TW0MklBDDrN05iKuaA+n
        rCMJ7DtXkV2wv7UAUQqqGc4=
X-Google-Smtp-Source: APXvYqyRTn83TMjd3XVuq/BUUDjybQ/dya9e/vNRu1Aii7T46weXexVaUjbWunMIiwK0sd2gG9Ce1w==
X-Received: by 2002:a19:4b84:: with SMTP id y126mr7512835lfa.15.1555528527757;
        Wed, 17 Apr 2019 12:15:27 -0700 (PDT)
Received: from localhost.localdomain (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id j27sm11387203lfk.97.2019.04.17.12.15.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 12:15:27 -0700 (PDT)
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
To:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     Alagu Sankar <alagusankar@silex-india.com>,
        Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH v2 2/5] ath10k: high latency fixes for beacon buffer
Date:   Wed, 17 Apr 2019 21:15:00 +0200
Message-Id: <20190417191503.18814-3-erik.stromdahl@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190417191503.18814-1-erik.stromdahl@gmail.com>
References: <20190417191503.18814-1-erik.stromdahl@gmail.com>
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
Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
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

