Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6082C433ED
	for <linux-wireless@archiver.kernel.org>; Mon, 17 May 2021 16:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5DC46108D
	for <linux-wireless@archiver.kernel.org>; Mon, 17 May 2021 16:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345495AbhEQQ1a (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 May 2021 12:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344215AbhEQQ1R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 May 2021 12:27:17 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3FAC0611E9
        for <linux-wireless@vger.kernel.org>; Mon, 17 May 2021 08:04:45 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lienT-00ANWX-Qw; Mon, 17 May 2021 17:04:43 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+a063bbf0b15737362592@syzkaller.appspotmail.com
Subject: [PATCH] mac80211_hwsim: drop pending frames on stop
Date:   Mon, 17 May 2021 17:04:31 +0200
Message-Id: <20210517170429.b0f85ab0eda1.Ie42a6ec6b940c971f3441286aeaaae2fe368e29a@changeid>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Syzbot reports that we may be able to get into a situation where
mac80211 has pending ACK frames on shutdown with hwsim. It appears
that the reason for this is that syzbot uses the wmediumd hooks to
intercept/injection frames, and may shut down hwsim, removing the
radio(s), while frames are pending in the air simulation.

Clean out the pending queue when the interface is stopped, after
this the frames can't be reported back to mac80211 properly anyway.

Reported-by: syzbot+a063bbf0b15737362592@syzkaller.appspotmail.com
#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ master
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 51ce767eaf88..7a6fd46d0c6e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1693,8 +1693,13 @@ static int mac80211_hwsim_start(struct ieee80211_hw *hw)
 static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
+
 	data->started = false;
 	hrtimer_cancel(&data->beacon_timer);
+
+	while (!skb_queue_empty(&data->pending))
+		ieee80211_free_txskb(hw, skb_dequeue(&data->pending));
+
 	wiphy_dbg(hw->wiphy, "%s\n", __func__);
 }
 
-- 
2.31.1

