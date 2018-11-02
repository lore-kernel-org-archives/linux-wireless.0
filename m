Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2D1C32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 20:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 130D92082D
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 20:50:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 130D92082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbeKCF6s (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 3 Nov 2018 01:58:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33445 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbeKCF6r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Nov 2018 01:58:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id u1-v6so3271230wrn.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2018 13:50:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XgsV9q+VqEHbvYsNWaC9/lJ9VUj/M+M+nCXzSkOzviI=;
        b=BzvWP7CW6rnQilsGGlfXOxBMHw0JjHlxhlr5pH84jRg9Lvx27WSKChRAEF+O4fAfvT
         feqiw7dG3YwvA51mIgpMuVkpzu5PBXimZSJO8ro3kGTDaG97rInN0CG0Ltl6VLlDZkg9
         nNOxyq204kNEGmAAxlw3MRJ6iK8awp6B1WgJCd6yI50jOsZ60Ifa2GO5OZs+fBUJo7YI
         Y/3iSIFSxMMcdS9D82SgucD4RGo9IVL409M4X9imsg/G1p16TwsOXXS98aHNJJB+Zgr4
         4oR6t7C+rAAtNtLD5RKtQ82dF7o2tBBXQXwIbEQJRpcT0Au2yG8lgEWvMEAFOy0XFVtY
         NFGQ==
X-Gm-Message-State: AGRZ1gJr0AY5iEFFHQV2w3tOn64JalG5j+sA0Ot55eqYvwmMz1jXXb/h
        tvwCGJTW2kunJ7Q+EK36o01K3rkNQsc=
X-Google-Smtp-Source: AJdET5c2Iw3pVdy/xUJpz3fPuGpsBhKZ0uPm97cTM/YfF1WfKeKpGz6CxT/mdiAsnncIck/kYvZhww==
X-Received: by 2002:adf:ea12:: with SMTP id q18-v6mr11949967wrm.224.1541191808031;
        Fri, 02 Nov 2018 13:50:08 -0700 (PDT)
Received: from localhost.localdomain ([151.66.16.197])
        by smtp.gmail.com with ESMTPSA id c14-v6sm28349450wmh.44.2018.11.02.13.50.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 13:50:07 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     koen.vandeputte@ncentric.com
Subject: [PATCH 1/5] ath9k: dynack: use authentication messages for 'late' ack
Date:   Fri,  2 Nov 2018 21:49:55 +0100
Message-Id: <9ec0b086cfa7199bf7bc70d3118e9f835808b907.1541190974.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1541190974.git.lorenzo.bianconi@redhat.com>
References: <cover.1541190974.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In order to properly support dynack in ad-hoc mode running
wpa_supplicant, take into account authentication frames for
'late ack' detection. This patch has been tested on devices
mounted on offshore high-voltage stations connected through
~24Km link

Reported-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
Tested-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/ath/ath9k/dynack.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/dynack.c b/drivers/net/wireless/ath/ath9k/dynack.c
index 7334c9b09e82..cc0dc966c512 100644
--- a/drivers/net/wireless/ath/ath9k/dynack.c
+++ b/drivers/net/wireless/ath/ath9k/dynack.c
@@ -187,7 +187,8 @@ void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
 	/* late ACK */
 	if (ts->ts_status & ATH9K_TXERR_XRETRY) {
 		if (ieee80211_is_assoc_req(hdr->frame_control) ||
-		    ieee80211_is_assoc_resp(hdr->frame_control)) {
+		    ieee80211_is_assoc_resp(hdr->frame_control) ||
+		    ieee80211_is_auth(hdr->frame_control)) {
 			ath_dbg(common, DYNACK, "late ack\n");
 			ath9k_hw_setslottime(ah, (LATEACK_TO - 3) / 2);
 			ath9k_hw_set_ack_timeout(ah, LATEACK_TO);
-- 
2.19.1

