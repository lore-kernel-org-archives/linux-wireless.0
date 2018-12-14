Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA94C67839
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 03:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0260C20879
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 03:55:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SBJ5r/+8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0260C20879
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbeLNDza (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 22:55:30 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33398 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbeLNDza (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 22:55:30 -0500
Received: by mail-pf1-f196.google.com with SMTP id c123so2166037pfb.0;
        Thu, 13 Dec 2018 19:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=33Ivcg+zKY4IJSFpoQuC8WL+BVd4+yqFaZLhoC52gcU=;
        b=SBJ5r/+8Ucd7I1Er4MOSSxKGDufo5jX5ud9DtvGEeeuDeN9IvB8O8DbWca9QppOKrC
         TwxfKWY2RjbPqRipsvKIEIJEl9vEyd0qUxVZClHBUtljQqoSoNpG4eH3gKvVuTn1hwpS
         2MQa8CaWuFayaceex662ogdcUWBkO7XnFs6VBuHxJwAgZyeu5iOirf4FOPYN6UI/wIZn
         AKcT3McOoTh0cnUTDM4gHzx2BOPr73k23KhmtMBkWDJP7aq0y6oyXtDjc1EtjxR5aKVx
         PSNVLnAV+FHwLK9S9oeTSumA/xCjkMCcWJqZFOs4gOTPQyMIhx+Sx9IIY6vkc2BEsgcr
         c+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=33Ivcg+zKY4IJSFpoQuC8WL+BVd4+yqFaZLhoC52gcU=;
        b=er85f83he9KLwzL/HexXduLTac89LdfiKVOVD0ibtO6qs91w54srczSM8TaHlJOGK2
         yU1ZGeuFe5G27YTUXFpQ9ERlFttXmiOaDMXNG4x+BCiZP7ozXUPaBmu+/IYv89ejSFKx
         DRdyZbiAqrCuvO7f94B72qdKCBxJIJ8PQqRT3Kkrl4D9/sCcbj330kfM66PKo6xSOmRz
         yh8wEzZts+UDCYOV3LgkykUeIEd2wX32FBuARGR/sKpb21v7cb0WoM9HJGU8Ng0jLWSg
         WaIGT0Axl2kRg/Xitha7YTyP/Go25/Xaj631Y4Ln3iEVb8qiBa/JxiFOeQ31cQzgCwm+
         RreQ==
X-Gm-Message-State: AA+aEWZffp4sI6V4DUlWYQEr+vpHp8c4Baa7HjaXmPIu5COHL+XhfNBq
        f6JoXU/V/UgWaLxwcjjLcHc=
X-Google-Smtp-Source: AFSGD/V+a6oN10NcSN1A0mNAEqoLZ3rEGJxrv+M+DDU2elQcy7KmDiP8TtBcEZg61e5AwnbGcZWU+A==
X-Received: by 2002:a63:bd51:: with SMTP id d17mr1342112pgp.443.1544759729682;
        Thu, 13 Dec 2018 19:55:29 -0800 (PST)
Received: from localhost.localdomain ([2402:f000:1:4414:74ca:bc02:ba8b:bd9e])
        by smtp.gmail.com with ESMTPSA id z62sm6285757pfi.4.2018.12.13.19.55.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 19:55:28 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     pizza@shaftnet.org, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] cw1200: Fix concurrency use-after-free bugs in cw1200_hw_scan()
Date:   Fri, 14 Dec 2018 11:55:21 +0800
Message-Id: <20181214035521.30388-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The function cw1200_bss_info_changed() and cw1200_hw_scan() can be
concurrently executed.
The two functions both access a possible shared variable "frame.skb".

This shared variable is freed by dev_kfree_skb() in cw1200_upload_beacon(), 
which is called by cw1200_bss_info_changed(). The free operation is 
protected by a mutex lock "priv->conf_mutex" in cw1200_bss_info_changed().

In cw1200_hw_scan(), this shared variable is accessed without the
protection of the mutex lock "priv->conf_mutex". 
Thus, concurrency use-after-free bugs may occur.

To fix these bugs, the original calls to mutex_lock(&priv->conf_mutex) and 
mutex_unlock(&priv->conf_mutex) are moved to the places, which can 
protect the accesses to the shared variable.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/st/cw1200/scan.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/scan.c b/drivers/net/wireless/st/cw1200/scan.c
index 67213f11acbd..0a9eac93dd01 100644
--- a/drivers/net/wireless/st/cw1200/scan.c
+++ b/drivers/net/wireless/st/cw1200/scan.c
@@ -78,6 +78,10 @@ int cw1200_hw_scan(struct ieee80211_hw *hw,
 	if (req->n_ssids > WSM_SCAN_MAX_NUM_OF_SSIDS)
 		return -EINVAL;
 
+	/* will be unlocked in cw1200_scan_work() */
+	down(&priv->scan.lock);
+	mutex_lock(&priv->conf_mutex);
+
 	frame.skb = ieee80211_probereq_get(hw, priv->vif->addr, NULL, 0,
 		req->ie_len);
 	if (!frame.skb)
@@ -86,19 +90,15 @@ int cw1200_hw_scan(struct ieee80211_hw *hw,
 	if (req->ie_len)
 		skb_put_data(frame.skb, req->ie, req->ie_len);
 
-	/* will be unlocked in cw1200_scan_work() */
-	down(&priv->scan.lock);
-	mutex_lock(&priv->conf_mutex);
-
 	ret = wsm_set_template_frame(priv, &frame);
 	if (!ret) {
 		/* Host want to be the probe responder. */
 		ret = wsm_set_probe_responder(priv, true);
 	}
 	if (ret) {
+		dev_kfree_skb(frame.skb);
 		mutex_unlock(&priv->conf_mutex);
 		up(&priv->scan.lock);
-		dev_kfree_skb(frame.skb);
 		return ret;
 	}
 
@@ -120,10 +120,9 @@ int cw1200_hw_scan(struct ieee80211_hw *hw,
 		++priv->scan.n_ssids;
 	}
 
-	mutex_unlock(&priv->conf_mutex);
-
 	if (frame.skb)
 		dev_kfree_skb(frame.skb);
+	mutex_unlock(&priv->conf_mutex);
 	queue_work(priv->workqueue, &priv->scan.work);
 	return 0;
 }
-- 
2.17.0

