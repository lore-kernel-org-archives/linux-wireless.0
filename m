Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C1FC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 21:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C871A20855
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 21:32:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bobcopeland-com.20150623.gappssmtp.com header.i=@bobcopeland-com.20150623.gappssmtp.com header.b="y0e35ijb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbfAQVc5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 16:32:57 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:34816 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfAQVc5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 16:32:57 -0500
Received: by mail-it1-f195.google.com with SMTP id p197so3202312itp.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2019 13:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bobcopeland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EjtuqvuYka0FtsNuAJcGMBJTdM8yYScDGvHH1CBu7rw=;
        b=y0e35ijbYx35MCCgKbRlc7vN6nIc1HIyFF3GtvyTNNZccSIC/vYe2MviVz7CkroZcD
         95sikBUJAxgBkrXPu0rW6tYypeSytYPOlMq1eNkKPBnCEE3peR6Z1m1NAdP10LVMV2uK
         m5aVruq151L4BJTt03YsZ+vYHOIVr8rBkGZndmJhr+bOLZAbUy7cAv7bljVgaXaODoFi
         /lfIz+1AStJMRk1I5fhZID/9mhOPwtDT31r3wzz99jOzJVBU08gHmE9qHWFCI43biobZ
         1wsFGfkrNOtFL3fvfQ07Ah9gGu+KeZMpJJfT7XmZICbw85Nb3hk8a4yDUVblWT1YnZ60
         SeOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EjtuqvuYka0FtsNuAJcGMBJTdM8yYScDGvHH1CBu7rw=;
        b=L+htOFpOZndQwD5ldP4wzf+TyHdOowD11X3lcp+KV94UatM6LMZZOHu/hl3s8/1Wq4
         Cnz0mKlikq0TPnnr8Ber45tAzmCXTg8Xfm0iqi9j3jYXVuIARwBJ72kUbWFAMR4H1ngH
         HPgoBlBjAsPrO5pIRzr8K8I8u+HvW2TSk2JIbsMl0c0+bG6TUT3+XoMIDbwGpoaqFWty
         mTwZAFT0B9QAd5ylHpFT6Hoe7n4RAz8ccK5SIKm+xEjCQA6T/v8zgCD6AjDfV7icA0jp
         bEE8TZitEy/UjzGxFzC0DJxwdNJ/vXS9H9PcYtZ++d1lX2RhZHyZa9ZS8Wkr3ERlPTAD
         LxyA==
X-Gm-Message-State: AJcUukdGv+ld730S8FD3HHkggUIRTjPeF1LciDoFYdsZMHK3V8u0I5XY
        qSdDdefrbVDb1yb42fdpnCeAov95Mag=
X-Google-Smtp-Source: ALg8bN4ZJemiZZC3qHnUsa2Y9Fu/wzjDjHcBImTfmIeU2+NghBDwZjs7yJ/EINl1kZqK4aB0PcyN7Q==
X-Received: by 2002:a24:5c90:: with SMTP id q138mr8955375itb.32.1547760776886;
        Thu, 17 Jan 2019 13:32:56 -0800 (PST)
Received: from hash (CPE30b5c2fb365b-CM18593342f28f.cpe.net.cable.rogers.com. [99.232.51.173])
        by smtp.gmail.com with ESMTPSA id j7sm949870iom.80.2019.01.17.13.32.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 17 Jan 2019 13:32:56 -0800 (PST)
Received: from bob by hash with local (Exim 4.92-RC4)
        (envelope-from <me@bobcopeland.com>)
        id 1gkFHT-0008EN-H0; Thu, 17 Jan 2019 16:32:55 -0500
From:   Bob Copeland <me@bobcopeland.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, kernel-team@fb.com,
        Bob Copeland <me@bobcopeland.com>,
        Bob Copeland <bobcopeland@fb.com>
Subject: [PATCH] mac80211: fix miscounting of ttl-dropped frames
Date:   Thu, 17 Jan 2019 16:32:42 -0500
Message-Id: <20190117213242.31588-1-me@bobcopeland.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In ieee80211_rx_h_mesh_fwding, we increment the 'dropped_frames_ttl'
counter when we decrement the ttl to zero.  For unicast frames
destined for other hosts, we stop processing the frame at that point.

For multicast frames, we do not rebroadcast it in this case, but we
do pass the frame up the stack to process it on this STA.  That
doesn't match the usual definition of "dropped," so don't count
those as such.

With this change, something like `ping6 -i0.2 ff02::1%mesh0` from a
peer in a ttl=1 network no longer increments the counter rapidly.

Signed-off-by: Bob Copeland <bobcopeland@fb.com>
---
 net/mac80211/rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index dddd498e1338..ffd312b8c432 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2531,7 +2531,9 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	skb_set_queue_mapping(skb, q);
 
 	if (!--mesh_hdr->ttl) {
-		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_ttl);
+		if (!is_multicast_ether_addr(hdr->addr1))
+			IEEE80211_IFSTA_MESH_CTR_INC(ifmsh,
+						     dropped_frames_ttl);
 		goto out;
 	}
 
-- 
2.20.1

