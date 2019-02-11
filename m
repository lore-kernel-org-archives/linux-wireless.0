Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81391C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 22:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 516AD218A1
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 22:05:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tqKbvAHW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfBKWFI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 17:05:08 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37850 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfBKWFH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 17:05:07 -0500
Received: by mail-lf1-f65.google.com with SMTP id n23so383249lfl.4
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2019 14:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hDWTmWX4Vqb1TEK+OwX8F9WXle3xfnlvHcLiOquCVbI=;
        b=tqKbvAHW14lsTMKU5jS5ZRIcjylezbsFLtxQ2VvX4DOBwaiIYOXZ2T6S1blFN87DX7
         XGtv//WWsx8IdaejvG7wzYov5QmCLsQocRvaACjIBEdYXPxe/D+hinllFwfuLxg4ZBfx
         3e5PqdjgKinRIvFSMvJDi2ht08IXpHLCVoK0SL2T+z4iKXdWPCOW5+B2FH/4znqGA4ca
         OiTtI9Lws+JyLiA5QqbVZB+HRvgNunhyGjQiBK4zwkCiwCukQv/fZSjN18pbV7CkXNCi
         eRp2gTBnxXrJrZIod04eipKSO6B1xQPODPZABwlvm2+0xd4GACQRTYeoDvkAmYPyTS08
         iuBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hDWTmWX4Vqb1TEK+OwX8F9WXle3xfnlvHcLiOquCVbI=;
        b=Qpy06tfLKAZzRqHY7F9oluof2DQwZH8Vqzu90rtAr1oa6h/kh1A4/ubgnwmqDPWiHM
         yPo5rAQ3SUNkodm+TmCfw2c2pfDxFYSs+fQ/tERsWaeunqdhfCb/+8Xi+6xpcl84lw+O
         aQMromCLk3hpSxVyA4ZMqshOnVDKc50oYZjBxakr08gNr9MZxHwuCZIvGtiIQX074kes
         VN+uOfmI/7Nw/f6sU6kmjep9FB1OzNYaBM6P6zQQdRZCBBrip5mDm81daQD9hJIy7QwD
         cSYA11yo/a7cAeIeU1dIQgHGpQd8InJq0Chq0l4cq6B4vGTUp/NNtiq9EJzpy6zgzBVX
         29PA==
X-Gm-Message-State: AHQUAuY5F80mYTB5iiLMET6e88TMIfNf0fkiGCxha3rTH3QAG71mV8VH
        IM56TNoBm+t4YiPQRtld5gk=
X-Google-Smtp-Source: AHgI3IYkXhGWRcLNpBlgKKaasKo6hiXBvA1xqBmHYkZspiUqvCr04Hyeyun7+x9hEUf6KFnRTWs1Ug==
X-Received: by 2002:ac2:4297:: with SMTP id m23mr233532lfh.141.1549922705415;
        Mon, 11 Feb 2019 14:05:05 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id c19-v6sm2238875lja.82.2019.02.11.14.05.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Feb 2019 14:05:04 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 1/2] brcmfmac: improve code handling bandwidth of firmware reported channels
Date:   Mon, 11 Feb 2019 23:04:53 +0100
Message-Id: <20190211220454.19850-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

1) Use switch to simplify/improve the code & avoid some duplication
2) Add warning for unsupported values

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index b5e291ed9496..fa752ec04f22 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6049,11 +6049,18 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 		/* assuming the chanspecs order is HT20,
 		 * HT40 upper, HT40 lower, and VHT80.
 		 */
-		if (ch.bw == BRCMU_CHAN_BW_80) {
+		switch (ch.bw) {
+		case BRCMU_CHAN_BW_80:
 			channel->flags &= ~IEEE80211_CHAN_NO_80MHZ;
-		} else if (ch.bw == BRCMU_CHAN_BW_40) {
+			break;
+		case BRCMU_CHAN_BW_40:
 			brcmf_update_bw40_channel_flag(channel, &ch);
-		} else {
+			break;
+		default:
+			wiphy_warn(wiphy, "Firmware reported unsupported bandwidth %d\n",
+				   ch.bw);
+			/* fall through */
+		case BRCMU_CHAN_BW_20:
 			/* enable the channel and disable other bandwidths
 			 * for now as mentioned order assure they are enabled
 			 * for subsequent chanspecs.
-- 
2.20.1

