Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF9FC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 02:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 451A42083A
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 02:15:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iM+99vVO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 451A42083A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbeIYIU2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 04:20:28 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46935 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbeIYIU1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 04:20:27 -0400
Received: by mail-pg1-f195.google.com with SMTP id b129-v6so10278418pga.13
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2018 19:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4aX9RqGYEOpUqmN/JMdMOVPkrGv1L6UeKT+wuh3HtjA=;
        b=iM+99vVOPCxQto8A8NoH9mB88niLecNbHP6QPLtYSKH8PLVLRg2Y0zljeXNoEJvV01
         raknAfZbrqppIS+r84/yBHKF1qRkAhK1M5xci6KhGc1Y8dyVx3PFIKyPky4djRtQUR00
         gpXRYXh6OxcbZnrZmn+5jcnutCIZ7cETwhAOquRMyH2AUatsB3qqEjme/LAojAGQRt/5
         aiMl2WVG4J1+Zo/tX47fdIu/9SJZEoJGLJiHYgeLJAmWgx10H26s3U+3EcI82UARZojW
         LFsmmXUJ/BW/FqI4ntBkm4IxV6ycAupAZU4BCja+PYx9VJsI52Yn8txYgCU3S9U8aGem
         m3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4aX9RqGYEOpUqmN/JMdMOVPkrGv1L6UeKT+wuh3HtjA=;
        b=WNmvbl5HFRqVY0Hm4yS30ykF/eAgFLxfvZ4kITBp3Cxg4YouVFqtRavqf6oIPE7jjn
         VXp5ZSIFcBb1rDRTQdRunNpSeRNbBidPRgSeE/gEqsANjENtFHvfZhlzMv70k91WdPQJ
         tP+zH1W0bwfqwK8Bo0vTQtFLX7PWmTp6rLHQxmBDBbVInBeUf6jjm+VTSMKLUJ3DgHGJ
         xo5T/dnq3Yz20NGZKkH08jvGTj3z1pWgO6n9FtiJFT0fq6Lz7fwgWXc8RSiva6qznkk5
         mBYiC3hZMfc/N7TWxYG3oHrFyux/gmInRH9Nrc9aw3w0vmmVYQIpd1fZMlBq89bXQnh3
         Qr1w==
X-Gm-Message-State: ABuFfohrvwkRJrXxPRSw1LJJUxwDRFAHOgP+6V0NXeeAB6pGErSt03+2
        8Wb5J7jUimrKD+O91zb2cXfWV1l2
X-Google-Smtp-Source: ACcGV62xtF+riTwmINUXnnaJKr0w9MBqMz3I+TXwld1mV5pI9ORa9syRPUovP7gcTT2lGjeOLC7puA==
X-Received: by 2002:a17:902:3a5:: with SMTP id d34-v6mr1277156pld.98.1537841719196;
        Mon, 24 Sep 2018 19:15:19 -0700 (PDT)
Received: from corei7.flets-east.jp ([2409:11:321:2100:1e:7de8:2e95:9a06])
        by smtp.gmail.com with ESMTPSA id p19-v6sm684865pgh.60.2018.09.24.19.15.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 24 Sep 2018 19:15:18 -0700 (PDT)
From:   Masashi Honma <masashi.honma@gmail.com>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH 1/2] nl80211: Fix possible Spectre-v1 for NL80211_TXRATE_HT
Date:   Tue, 25 Sep 2018 11:15:00 +0900
Message-Id: <1537841701-3092-1-git-send-email-masashi.honma@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use array_index_nospec() to sanitize ridx with respect to speculation.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0827cbd..3c469c1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3748,6 +3748,7 @@ static bool ht_rateset_to_mask(struct ieee80211_supported_band *sband,
 			return false;
 
 		/* check availability */
+		ridx = array_index_nospec(ridx, IEEE80211_HT_MCS_MASK_LEN);
 		if (sband->ht_cap.mcs.rx_mask[ridx] & rbit)
 			mcs[ridx] |= rbit;
 		else
-- 
2.7.4

