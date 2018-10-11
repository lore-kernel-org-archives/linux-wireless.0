Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A930C677FC
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 20:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E7B520659
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 20:18:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xw2Vhrgj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E7B520659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbeJLDr3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:47:29 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38081 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbeJLDr3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 23:47:29 -0400
Received: by mail-pf1-f193.google.com with SMTP id f29-v6so4968591pff.5
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2018 13:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6vDOTArplbSoSgRTTMA3dGwknH38peuZIANetG37mPc=;
        b=Xw2VhrgjBfVpYHhgGrkHlA3+N86uzize+QHe+4jPX09BtgGM/kMsikmqkIGmZ42DrV
         AUDRCFJc2I9CL5QwUPSqUJxXgEuzbZ+h/3buocObRuiA4EeaChfhzDiMWX1GisNWdszT
         P/MtkbJOfds/xK4JCrmmMFUv3717gDmBRdGxV2yX0QMWmDz3XtoXuuvG1vx02MGX6CPK
         ti5Ea65V+GMghTwfzSW3rwfcAbSldSKahZIgmEa97vrHHTMcNNa+IdQJdslPx/FMO35K
         voQozcBaoym+m0Lt7LG+7iZUDKqhpqTnFrmgNfafpToCWxU5INenHsszqCMWlhU8uDu3
         mCoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6vDOTArplbSoSgRTTMA3dGwknH38peuZIANetG37mPc=;
        b=g4tRbInu/xViuOOi67N2tMPseAJocqEuTP3PdM5V7SQCf/qZzLcnRO6PCeRfz/dZnU
         pqlX75nw/upfOOuk3ercflZh5QF5BNbvQaCwyp3rWkGl9v6T5XwfWk0B4mRaPgTP4ZeT
         9NattGRo6L4E9H4YB4cwNOEInI9h9gRKkXsyiT/o1SpbsCN2gZBfvEPigOu4dIbVLy5z
         09mv68ICf6jpL8XJJ5TAtQP2zOEvqlwkUnJCNiQUV89MCxvatchGtLhHKKQJHIMkYsbT
         jK1TYoPbLtQZd7tqMGOq4a/vP7aX2YujIQT2YG6BBFyVbENdB6W0FZX4oblWK1OlI5U/
         Xwug==
X-Gm-Message-State: ABuFfog2O2rcZpCI173etzwIcnGjFmxlHU+SfJYaNMEpdfKsVZvnBQBH
        jl5CfOiM2AJe6tE7mrqH9GM=
X-Google-Smtp-Source: ACcGV625kfPnU1NzD+hYxFx4BcbPRWRN8YlLVyuo6PTkpDUkwG7O7EtzImED1oaK4QvBTtADrKAkxA==
X-Received: by 2002:a63:e601:: with SMTP id g1-v6mr2763936pgh.290.1539289117391;
        Thu, 11 Oct 2018 13:18:37 -0700 (PDT)
Received: from localhost.localdomain ([67.139.187.132])
        by smtp.gmail.com with ESMTPSA id l71-v6sm22616152pgd.31.2018.10.11.13.18.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 11 Oct 2018 13:18:36 -0700 (PDT)
From:   Dan Haab <riproute@gmail.com>
X-Google-Original-From: Dan Haab <dan.haab@luxul.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Dan Haab <dan.haab@luxul.com>
Subject: [PATCH] brcmfmac: support STA info struct v7
Date:   Thu, 11 Oct 2018 14:19:01 -0600
Message-Id: <1539289141-13689-1-git-send-email-dan.haab@luxul.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The newest firmwares provide STA info using v7 of the struct. As v7
isn't backward compatible, a union is needed.

Even though brcmfmac does not use any of the new info it's important to
provide the proper struct buffer. Without this change new firmwares will
fallback to the very limited v3 instead of something in between such as
v4.

Signed-off-by: Dan Haab <dan.haab@luxul.com>
---
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 39 ++++++++++++++++++----
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index d5bb81e..189d576 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -176,6 +176,8 @@
 
 #define BRCMF_VHT_CAP_MCS_MAP_NSS_MAX	8
 
+#define BRCMF_HE_CAP_MCS_MAP_NSS_MAX	8
+
 /* MAX_CHUNK_LEN is the maximum length for data passing to firmware in each
  * ioctl. It is relatively small because firmware has small maximum size input
  * playload restriction for ioctls.
@@ -601,13 +603,36 @@ struct brcmf_sta_info_le {
 	__le32 rx_pkts_retried;        /* # rx with retry bit set */
 	__le32 tx_rate_fallback;       /* lowest fallback TX rate */
 
-	/* Fields valid for ver >= 5 */
-	struct {
-		__le32 count;					/* # rates in this set */
-		u8 rates[BRCMF_MAXRATES_IN_SET];		/* rates in 500kbps units w/hi bit set if basic */
-		u8 mcs[BRCMF_MCSSET_LEN];			/* supported mcs index bit map */
-		__le16 vht_mcs[BRCMF_VHT_CAP_MCS_MAP_NSS_MAX];	/* supported mcs index bit map per nss */
-	} rateset_adv;
+	union {
+		struct {
+			struct {
+				__le32 count;					/* # rates in this set */
+				u8 rates[BRCMF_MAXRATES_IN_SET];		/* rates in 500kbps units w/hi bit set if basic */
+				u8 mcs[BRCMF_MCSSET_LEN];			/* supported mcs index bit map */
+				__le16 vht_mcs[BRCMF_VHT_CAP_MCS_MAP_NSS_MAX];	/* supported mcs index bit map per nss */
+			} rateset_adv;
+		} v5;
+
+		struct {
+			__le32 rx_dur_total;	/* total user RX duration (estimated) */
+			__le16 chanspec;	/** chanspec this sta is on */
+			__le16 pad;
+			struct {
+				__le16 version;					/* version */
+				__le16 len;					/* length */
+				__le32 count;					/* # rates in this set */
+				u8 rates[BRCMF_MAXRATES_IN_SET];		/* rates in 500kbps units w/hi bit set if basic */
+				u8 mcs[BRCMF_MCSSET_LEN];			/* supported mcs index bit map */
+				__le16 vht_mcs[BRCMF_VHT_CAP_MCS_MAP_NSS_MAX];	/* supported mcs index bit map per nss */
+				__le16 he_mcs[BRCMF_HE_CAP_MCS_MAP_NSS_MAX];	/* supported he mcs index bit map per nss */
+			} rateset_adv;		/* rateset along with mcs index bitmap */
+			__le16 wpauth;		/* authentication type */
+			u8 algo;		/* crypto algorithm */
+			__le32 tx_rspec;	/* Rate of last successful tx frame */
+			__le32 rx_rspec;	/* Rate of last successful rx frame */
+			__le32 wnm_cap;		/* wnm capabilities */
+		} v7;
+	};
 };
 
 struct brcmf_chanspec_list {
-- 
1.9.1

