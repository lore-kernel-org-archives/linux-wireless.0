Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C751C282CE
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 22:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF9CD218A1
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 22:05:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tHkT1X43"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfBKWFK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 17:05:10 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38558 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfBKWFJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 17:05:09 -0500
Received: by mail-lf1-f66.google.com with SMTP id n15so378191lfe.5
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2019 14:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gh8tmjZJJrwcaBCD0SfNUWYtqzTSRUQtNCL4aak7XKE=;
        b=tHkT1X43n3fnevJAgR9DeQDkRKUMKCmGHu4u2V9S7tvtZLByU94bZ7COBg2FCzjtIK
         gri7x+0lIoqzqX/K3GJ7tDBoKjwXGNjE5flb29XqmttETNVYH1PYQlIxMCDCGQb1HKPk
         yMd6kzFDLK8YejA4rBFoN45DHMrLdOD+nR4LJem0HIm8JTDBjOyI7aHcG66WYRxdyFv3
         KZo6Xpx3dkJ9Fq+jM8+JJNusmRSp/WaWzG72FG6eEfXJfWT1Ke2VTKXlc2V7bQKdEFlb
         KdER/dEPb0uKZrrTGw3/Yx7nTT07dfsqMx8irbiF6aFbU08SMTR3FwEdNMVTHp9d79ZW
         pKYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gh8tmjZJJrwcaBCD0SfNUWYtqzTSRUQtNCL4aak7XKE=;
        b=k+ew+QbTNtisz89TtXvdNuFB3LBKQMgcqBVIjpmRHTMFH+uTtpVgkYaJKnpmuNj/hk
         UpIq6no/cEtbrsaBj400SbZz4QiYRwAwM41FFK/gtwYMwaR9g2SIf9nPtk61h8ROcyhe
         wO92Exmp6CSeyb1hfw1MpbSlDmf12ZJT8vyQb04affdsO+YmPqYa2ju8WVO8f5RNuoNe
         x4DSBLvhriEmTLN3D1Dnu2GJs7vMurWhmWT2ezyUz7frmPlqQ+ny0mevlvl6tXvqTLWJ
         NT2N7QvKGaecPemOP/G0wyMQYpVQcG3+eInohGrWGIb1Bi4f10doSG1ldIPx0KeY8wC1
         2sRQ==
X-Gm-Message-State: AHQUAuZjgHDNqpDntiFeVavVbc3iBYuMygtBN+JHANwz/4xUCKQD2C/3
        mSAS0nVUVaFFUvdl2/37wwI=
X-Google-Smtp-Source: AHgI3IbARwxDWUhNdNYRy7oX3eqWkoB05qHOJ/+tYlgJEEQNZ87M0tFtUM+JnwHzm4zOdxjYxoMwyg==
X-Received: by 2002:a19:c942:: with SMTP id z63mr244461lff.162.1549922707635;
        Mon, 11 Feb 2019 14:05:07 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id c19-v6sm2238875lja.82.2019.02.11.14.05.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Feb 2019 14:05:07 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 2/2] brcmfmac: support firmware reporting 160 MHz channels
Date:   Mon, 11 Feb 2019 23:04:54 +0100
Message-Id: <20190211220454.19850-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190211220454.19850-1-zajec5@gmail.com>
References: <20190211220454.19850-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

So far 160 MHz channels were treated as 20 MHz ones which was breaking
support for 40/80 MHz due to the brcmf_construct_chaninfo() logic and
its assumptions.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index fa752ec04f22..b3611f0f68bf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6050,6 +6050,9 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 		 * HT40 upper, HT40 lower, and VHT80.
 		 */
 		switch (ch.bw) {
+		case BRCMU_CHAN_BW_160:
+			channel->flags &= ~IEEE80211_CHAN_NO_160MHZ;
+			break;
 		case BRCMU_CHAN_BW_80:
 			channel->flags &= ~IEEE80211_CHAN_NO_80MHZ;
 			break;
-- 
2.20.1

