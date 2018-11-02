Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 805ABC65C22
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 17:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 461712081F
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 17:18:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gZmyvMQ1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 461712081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbeKCC0W (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 22:26:22 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44822 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbeKCC0V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 22:26:21 -0400
Received: by mail-pg1-f194.google.com with SMTP id w3-v6so1244645pgs.11
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2018 10:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ffqVuA97Vr+ZfIuptqd/ikvaB11RwRd45xwN+Xck2yw=;
        b=gZmyvMQ1BgWqzZpMTTGDB033FKeMtSTtMkr2Icmv1yO3Ym56bWu0StqaPMQDxBMvQs
         I8SQBv/YODZ9coKNXMXnXRtTLl1KVoeIYVownzw8hf9m6Tbfn3X9sv5Q3IJhfswdKbxm
         ugMNbTwINUyJ/GOwj9sNSVxSdsH+E+tGI/dio=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ffqVuA97Vr+ZfIuptqd/ikvaB11RwRd45xwN+Xck2yw=;
        b=AjrC7L5LZSRjMQxcCDrahc8aafbLhLMDsKklYn2bbaaFaXddGCX04l9c66rowA8bpz
         V4xdThTsIZ6g+NsA0WKsDCrSdnKCF5kpgbvhmrex2GgT7xw5erAdguybVJG5rWC+/yEu
         b2MoDSyOXXOqLnMKcWgin8CuSzXNer7k8H+vDZn48DSv/7Cnax3CPhqOkcYggBSfK884
         X/Yvi4d6VVcMe3ul8zsG5MxhhC7ernvyxFhSlxtOn+HMA9vx01rTVQ06sDPV372BVENm
         1OctFefGTEOknwscuzDKw8LED/f4GRIGgRuoN0cI5ZMI+1ahOFlD3EfiE0DNv2UBPqhZ
         GAmg==
X-Gm-Message-State: AGRZ1gJhDlJYp9I/lXXW6B8KatVlQbLSU0UpAY9iKys5sGVd+1TWoaXv
        Zp9N7XBoxiEkzh2eYG2rvzJ2PQ==
X-Google-Smtp-Source: AJdET5cstslmQBp4QugmvmduufvZ7LTX3N7fqusSgkKwZ4jpGICEXm+qxXLKmkN/NU4Olp/1uNd0iA==
X-Received: by 2002:a62:2741:: with SMTP id n62-v6mr12702939pfn.138.1541179108582;
        Fri, 02 Nov 2018 10:18:28 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id d5-v6sm19222675pfo.131.2018.11.02.10.18.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 10:18:27 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@qti.qualcomm.com>,
        Govind Singh <govinds@qti.qualcomm.com>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 1/3] ath10k: assign 'n_cipher_suites' for WCN3990
Date:   Fri,  2 Nov 2018 10:17:47 -0700
Message-Id: <20181102171749.38680-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.19.1.930.g4563a0d9d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Commit 2ea9f12cefe4 ("ath10k: add new cipher suite support") added a new
n_cipher_suites HW param with a fallback value and a warning log. Commit
03a72288c546 ("ath10k: wmi: add hw params entry for wcn3990") later
added WCN3990 HW entries, but it missed the n_cipher_suites.

Rather than seeing this warning every boot

  ath10k_snoc 18800000.wifi: invalid hw_params.n_cipher_suites 0

let's provide the appropriate value.

Cc: Rakesh Pillai <pillair@qti.qualcomm.com>
Cc: Govind Singh <govinds@qti.qualcomm.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index da607febfd82..bdc81f1cdb94 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -561,6 +561,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.hw_ops = &wcn3990_ops,
 		.decap_align_bytes = 1,
 		.num_peers = TARGET_HL_10_TLV_NUM_PEERS,
+		.n_cipher_suites = 8,
 		.ast_skid_limit = TARGET_HL_10_TLV_AST_SKID_LIMIT,
 		.num_wds_entries = TARGET_HL_10_TLV_NUM_WDS_ENTRIES,
 		.target_64bit = true,
-- 
2.19.1.930.g4563a0d9d0-goog

