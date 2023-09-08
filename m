Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDB1EEB56C
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Sep 2023 18:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343950AbjIHSSH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Sep 2023 14:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343898AbjIHSR5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2023 14:17:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B941FC9;
        Fri,  8 Sep 2023 11:17:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B3EC116B7;
        Fri,  8 Sep 2023 18:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694196912;
        bh=W16OcVSKs5ccAz3e1l46OfV/3zF/e5jNDDgw0J5WPgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DS0/awohiZ/7rrGL1a3MuZC/LFneSMY0kHzbBZXbjTeTbnWAOsefi1ztWT1PjTyad
         6svqhP+s0GSuTaUmlRs2V56hRtra+5Difvyz+LlmEbaosnTdoZ+H1RvZPN0giCeN32
         7rOIhgMoELMIsCpBTVDM3qg05dqRM3HDkdGPxkbnSv+nQhsriTHArGod59mf1Ir0lO
         mTWgk83pQDGvFk3Ua035iXBlo2yUpgXcCww1+geq4fA2uc5wHELfRs+2rSEJBlLtBk
         X45+IKV9DXMqPU+Uos0GAX+1Ixn2oeL4bfHMeEava+0Brz4ILx9eKJmRL7GwBRL4/z
         ZDj5Qbzo6MqOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+b2645b5bf1512b81fa22@syzkaller.appspotmail.com,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        kvalo@kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH AUTOSEL 6.5 37/45] wifi: mac80211_hwsim: drop short frames
Date:   Fri,  8 Sep 2023 14:13:18 -0400
Message-Id: <20230908181327.3459042-37-sashal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230908181327.3459042-1-sashal@kernel.org>
References: <20230908181327.3459042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.5.2
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit fba360a047d5eeeb9d4b7c3a9b1c8308980ce9a6 ]

While technically some control frames like ACK are shorter and
end after Address 1, such frames shouldn't be forwarded through
wmediumd or similar userspace, so require the full 3-address
header to avoid accessing invalid memory if shorter frames are
passed in.

Reported-by: syzbot+b2645b5bf1512b81fa22@syzkaller.appspotmail.com
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index f446fd0e8cd0d..dd516cec41973 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -5626,14 +5626,15 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	frame_data_len = nla_len(info->attrs[HWSIM_ATTR_FRAME]);
 	frame_data = (void *)nla_data(info->attrs[HWSIM_ATTR_FRAME]);
 
+	if (frame_data_len < sizeof(struct ieee80211_hdr_3addr) ||
+	    frame_data_len > IEEE80211_MAX_DATA_LEN)
+		goto err;
+
 	/* Allocate new skb here */
 	skb = alloc_skb(frame_data_len, GFP_KERNEL);
 	if (skb == NULL)
 		goto err;
 
-	if (frame_data_len > IEEE80211_MAX_DATA_LEN)
-		goto err;
-
 	/* Copy the data */
 	skb_put_data(skb, frame_data, frame_data_len);
 
-- 
2.40.1

