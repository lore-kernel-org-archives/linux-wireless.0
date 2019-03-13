Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17898C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 03:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D67EB2077B
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 03:08:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jMc6Kesp";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jMc6Kesp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfCMDIk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 23:08:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43330 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfCMDIk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 23:08:40 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BD98360A43; Wed, 13 Mar 2019 03:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552446519;
        bh=w/oa3ozzXFC20BirKzqeEO/aMbnEbQR47GvQe4T+L+I=;
        h=From:To:Cc:Subject:Date:From;
        b=jMc6Kespsq9orbES8caS4sENC/3cltbtuBgQHD3QY5cPT0PAYeYPjy/hxvprFO+sy
         /+wmovqeXJh/M5mx4k6/ZuBDVHJJzw1cmpyG7dMM8yJTlLQ7M79FX/n1OLhcV4iOjB
         x62hEs0M+w3L6W6UpcWGBu1MEg7Vl/2maEVAEEqI=
Received: from ybzhao-Latitude-E5440.ap.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: yiboz@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 147A96013C;
        Wed, 13 Mar 2019 03:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552446519;
        bh=w/oa3ozzXFC20BirKzqeEO/aMbnEbQR47GvQe4T+L+I=;
        h=From:To:Cc:Subject:Date:From;
        b=jMc6Kespsq9orbES8caS4sENC/3cltbtuBgQHD3QY5cPT0PAYeYPjy/hxvprFO+sy
         /+wmovqeXJh/M5mx4k6/ZuBDVHJJzw1cmpyG7dMM8yJTlLQ7M79FX/n1OLhcV4iOjB
         x62hEs0M+w3L6W6UpcWGBu1MEg7Vl/2maEVAEEqI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 147A96013C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=yiboz@codeaurora.org
From:   Yibo Zhao <yiboz@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, Yibo Zhao <yiboz@codeaurora.org>
Subject: [PATCH v2] fq: fix fq_tin tx bytes overflow
Date:   Wed, 13 Mar 2019 11:08:25 +0800
Message-Id: <1552446505-15444-1-git-send-email-yiboz@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently, we are using u32 for tx_bytes in fq_tin.
If the throughput stays more than 1.2Gbps, tx_bytes
statistics overflow in about 1 min.

In order to allow us to trace the tx_bytes statistics
for longer time in high throughput, change its type
from u32 to u64.

Signed-off-by: Yibo Zhao <yiboz@codeaurora.org>
---
 include/net/fq.h              | 2 +-
 net/mac80211/debugfs_netdev.c | 2 +-
 net/mac80211/debugfs_sta.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/fq.h b/include/net/fq.h
index ac944a6..70f8b12 100644
--- a/include/net/fq.h
+++ b/include/net/fq.h
@@ -53,7 +53,7 @@ struct fq_tin {
 	u32 overlimit;
 	u32 collisions;
 	u32 flows;
-	u32 tx_bytes;
+	u64 tx_bytes;
 	u32 tx_packets;
 };
 
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index cff0fb3..8d66f41 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -499,7 +499,7 @@ static ssize_t ieee80211_if_fmt_aqm(
 	len = scnprintf(buf,
 			buflen,
 			"ac backlog-bytes backlog-packets new-flows drops marks overlimit collisions tx-bytes tx-packets\n"
-			"%u %u %u %u %u %u %u %u %u %u\n",
+			"%u %u %u %u %u %u %u %u %llu %u\n",
 			txqi->txq.ac,
 			txqi->tin.backlog_bytes,
 			txqi->tin.backlog_packets,
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 3aa618d..e54a6d6 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -168,7 +168,7 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 			continue;
 		txqi = to_txq_info(sta->sta.txq[i]);
 		p += scnprintf(p, bufsz+buf-p,
-			       "%d %d %u %u %u %u %u %u %u %u %u 0x%lx(%s%s%s)\n",
+			       "%d %d %u %u %u %u %u %u %u %llu %u 0x%lx(%s%s%s)\n",
 			       txqi->txq.tid,
 			       txqi->txq.ac,
 			       txqi->tin.backlog_bytes,
-- 
1.9.1

