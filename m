Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CFAC282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 910752147A
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548697040;
	bh=Ya31zp4FLM1EhnlCS2TEnTvVz+C2ZIUHpbNTsNW9rzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=nkIPpeKz77Pssr+++jQloo8GD9tDKU0zG2b3fK3mBkToKBZKlp5kWOwysiauRVIXO
	 xwE7ejabj1Eym4/EaPwk/ICEHSn1s5ZK+9dazDYkJnEqpznZo2rozzo0bx7rZPJR/w
	 neOYutEMGRE/TjN6miNjkdeQ7dI8ys3MPpA98Ay0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730168AbfA1RhO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 12:37:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:41054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728475AbfA1PzB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:55:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A9C82147A;
        Mon, 28 Jan 2019 15:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548690901;
        bh=Ya31zp4FLM1EhnlCS2TEnTvVz+C2ZIUHpbNTsNW9rzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PliWLXwfjCN7EkYQFyLNmUl5YyUcdX0+2JBrdRf3d+yz9QuohOkxxxG6058Ib36S1
         Mla/Y5zX/ChjqOvCWPIETit89l3nDpSVRHUKuIJ5hD/a2/WBeJmJZWY5BrdRxnGc7a
         u3YNl7chdUOeRH6zM6IISsDghwaY6975aN+oqvn8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 229/304] cw1200: Fix concurrency use-after-free bugs in cw1200_hw_scan()
Date:   Mon, 28 Jan 2019 10:42:26 -0500
Message-Id: <20190128154341.47195-229-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 4f68ef64cd7feb1220232bd8f501d8aad340a099 ]

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
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.19.1

