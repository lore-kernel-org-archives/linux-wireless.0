Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE4AFC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 02:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91C1B2083A
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 02:15:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tf+9xwFd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91C1B2083A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbeIYIUa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 04:20:30 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34457 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbeIYIUa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 04:20:30 -0400
Received: by mail-pg1-f193.google.com with SMTP id d19-v6so10309240pgv.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2018 19:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S4r2w47U4hSg7f0YOro933X13/jRs2Sf+BpqxJzhBas=;
        b=Tf+9xwFdWV8JBNAXGEMtJmxqNNBZQHzaMjwhd551S2Lmi30V0iFin4azC/FceznbhS
         +FNFq75+ZMiRM51+aF+exZ6V0gS31HzWwjW+3X5AY9Yb404BFlC8qzWDhjjO5eZl7mzH
         ag723CTrqsbKB9eW741r5TFevmiQ9iOLHuUEgAaJRRgGL3asaE12CVXJbqrHir9BeWO2
         YnyyW8HAT856Vkq1bLAO/8ayI3LGDk6QutPw6I79HTAK+YWW6c69AamTHSVujOlFnFKN
         Dku+llWz8G+S01ntkDpYa+r0RwaSHX0N1w2/lcMPGiygA4d9s1hlHIjfW3cvM+5zZ0OY
         Lujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=S4r2w47U4hSg7f0YOro933X13/jRs2Sf+BpqxJzhBas=;
        b=SO8HozqRvF+ELF3VRrD3xi40smDxkWN73t3mxTulUyMJnoQRebvbTLyr95XY5I4O+q
         1LVcl2Sm9tSXtgZoLv2zGPBbaPS9rmR0EunB4ozxqZM9b/e1SL74Asw142pEiYpDqm0W
         piolRLrdZGXV/LLsp376o7pwu2xB7ZfVqzgR8ByIrjLDGSWSNvYT2STsIiWeTU32w6Lz
         06BGh10ABFNB2If1gcg6+UsIMAsXEGjiwKMuBK8N2Dr2ItgGTWEKTo//MhTNeYJCHF+Y
         PkaQ6yijHPpyVWVZ60W04+yATLrbuyqmkxKOMpat4+HwQA8Z6qSoEIEXhOPJyLlmztSU
         c1Uw==
X-Gm-Message-State: ABuFfog6Qnc2CDbdekdx1VRVJSuusI+OD07MSa0SM0dNvJiosoaS6wf8
        JJhgokZChjeHLA1Bni2XByo=
X-Google-Smtp-Source: ACcGV62kPtB+Y0K/lESL0ax1Fob0dNRwBB2rNKApwTVG/ZaIPC7hSYMeHDjqk1aaY+Npx5HQGprOXg==
X-Received: by 2002:a65:560a:: with SMTP id l10-v6mr1249143pgs.130.1537841721221;
        Mon, 24 Sep 2018 19:15:21 -0700 (PDT)
Received: from corei7.flets-east.jp ([2409:11:321:2100:1e:7de8:2e95:9a06])
        by smtp.gmail.com with ESMTPSA id p19-v6sm684865pgh.60.2018.09.24.19.15.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 24 Sep 2018 19:15:20 -0700 (PDT)
From:   Masashi Honma <masashi.honma@gmail.com>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH 2/2] nl80211: Fix possible Spectre-v1 for CQM RSSI thresholds
Date:   Tue, 25 Sep 2018 11:15:01 +0900
Message-Id: <1537841701-3092-2-git-send-email-masashi.honma@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1537841701-3092-1-git-send-email-masashi.honma@gmail.com>
References: <1537841701-3092-1-git-send-email-masashi.honma@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use array_index_nospec() to sanitize i with respect to speculation.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/wireless/nl80211.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3c469c1..4f47502 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10227,7 +10227,7 @@ static int cfg80211_cqm_rssi_update(struct cfg80211_registered_device *rdev,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	s32 last, low, high;
 	u32 hyst;
-	int i, n;
+	int i, n, low_index;
 	int err;
 
 	/* RSSI reporting disabled? */
@@ -10264,10 +10264,19 @@ static int cfg80211_cqm_rssi_update(struct cfg80211_registered_device *rdev,
 		if (last < wdev->cqm_config->rssi_thresholds[i])
 			break;
 
-	low = i > 0 ?
-		(wdev->cqm_config->rssi_thresholds[i - 1] - hyst) : S32_MIN;
-	high = i < n ?
-		(wdev->cqm_config->rssi_thresholds[i] + hyst - 1) : S32_MAX;
+	low_index = i - 1;
+	if (low_index >= 0) {
+		low_index = array_index_nospec(low_index, n);
+		low = wdev->cqm_config->rssi_thresholds[low_index] - hyst;
+	} else {
+		low = S32_MIN;
+	}
+	if (i < n) {
+		i = array_index_nospec(i, n);
+		high = wdev->cqm_config->rssi_thresholds[i] + hyst - 1;
+	} else {
+		high = S32_MAX;
+	}
 
 	return rdev_set_cqm_rssi_range_config(rdev, dev, low, high);
 }
-- 
2.7.4

