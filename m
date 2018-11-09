Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69FD7C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 16:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24F1720818
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 16:38:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n4aq0hhX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24F1720818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbeKJCT3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 21:19:29 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33251 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbeKJCT3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 21:19:29 -0500
Received: by mail-pf1-f195.google.com with SMTP id v68-v6so1170477pfk.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 08:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gGckfnoExzxWsSqFCpZLbKKIXo48NwKkb3kHmy2WQI4=;
        b=n4aq0hhXCsQGfXFRwSiTdt+likhjdcZrmyG71j+59wrllKxZmLNxrpaol82k2BVQeX
         ZOBrIQ6VbwzrpQAqvxournzCUx3LT/1HKFb9zzDCVUQhRqTmiEVaoiNwC6oTnSCSh894
         /j4BuZnWLjJRRwmiv5hjs2ySbdvSIkm3YR8uq29MBarrhRD8zwYzHZIHwLUORFQalVjh
         EV3TtyWAGPi0TAMq7wgUvFqDv03GRvoX0yEfPMTAl8aTK/PluDFaCntSK8yaLkrdb4x1
         BNJkjy7HYqYOh5pb22DFv5cD6wc9VBPBRMxnPL97Oz4NyPlGdcXMhTndKnEYJMQomzHM
         9FPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gGckfnoExzxWsSqFCpZLbKKIXo48NwKkb3kHmy2WQI4=;
        b=L+daZ4jvGCjam9Ubh4ga3FRATouYZHHNtSewaQ8QT/a8NlLGqvN1+Pov3NF3AbkmWW
         FFIbB/D5adjowN/wccPW7XfOr1WwbJU7u5gdfQGeXDYpWD90BDbScxPUtkhR2KBOP3hb
         6Zfpo4PpHnjz9VZiRwMpsyXyZ185Tbi1D4OAsstSmDnllnpYW30okfTIw7MCHNqgzkcn
         9oK7hyf7xIv7mCceJUPqWBcyeBO0JSYR912UIht/9SNN2W6KQrhLGO2bgCsrG1iDPPYG
         8Jlh6PCW/VLK4/s9pz3nqMc7KHwltNNx4Ez1eLnJ/yBKJ+mfk8VidlIm0IO0oUBtC6ow
         WkJQ==
X-Gm-Message-State: AGRZ1gLVJ3UwzdEth+NmWTYe78P2YE0DdN2+Ih/aGv2v6J4qnTwHIjSF
        5Lges/5lTgHCORk7Hp2YZs4=
X-Google-Smtp-Source: AJdET5d26BtNhuBv9Q8Znj2c29sEXb71p/gpgvJwxs2kGQ6z/eRxem7TDSOSvrRZcq7XhxoL9Kl2mA==
X-Received: by 2002:a63:fc49:: with SMTP id r9mr7875252pgk.209.1541781488919;
        Fri, 09 Nov 2018 08:38:08 -0800 (PST)
Received: from localhost.localdomain ([67.139.187.132])
        by smtp.gmail.com with ESMTPSA id y144-v6sm12507686pfb.81.2018.11.09.08.38.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 09 Nov 2018 08:38:08 -0800 (PST)
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
Subject: [PATCH v2] brcmfmac: support STA info struct v7
Date:   Fri,  9 Nov 2018 09:38:55 -0700
Message-Id: <1541781535-10523-1-git-send-email-dan.haab@luxul.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Reviewed-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 40 ++++++++++++++++++----
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index d5bb81e..39ac1bb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -176,6 +176,8 @@
 
 #define BRCMF_VHT_CAP_MCS_MAP_NSS_MAX	8
 
+#define BRCMF_HE_CAP_MCS_MAP_NSS_MAX	8
+
 /* MAX_CHUNK_LEN is the maximum length for data passing to firmware in each
  * ioctl. It is relatively small because firmware has small maximum size input
  * playload restriction for ioctls.
@@ -601,13 +603,37 @@ struct brcmf_sta_info_le {
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
+			__le16 pad_1;
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
+			u8 pad_2;
+			__le32 tx_rspec;	/* Rate of last successful tx frame */
+			__le32 rx_rspec;	/* Rate of last successful rx frame */
+			__le32 wnm_cap;		/* wnm capabilities */
+		} v7;
+	};
 };
 
 struct brcmf_chanspec_list {
-- 
1.9.1

