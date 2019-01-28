Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07AAC282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C2EB20815
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548697131;
	bh=9tDo+KytNMo44euHDmGqM9epA/4MQGasBbMDcWQ+hmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=k8+NtvUk1aBbBj7jrTT+ggokbv8AHVn4Q+wQgCjt/dx6gb0j4lTMZzDIuQh6IihBg
	 jmpILOMClI9/bqTFAFrcOvcDYtKhKZ8cUph4C3TRTBMBV+1kDMAucFGHvU+8MLFZ+I
	 TLgre+t4tj4DpU0J7IQV7kOFX85/QOtvBDzljWjY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbfA1Pxz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:53:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729532AbfA1Pxy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:53:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C88920855;
        Mon, 28 Jan 2019 15:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548690833;
        bh=9tDo+KytNMo44euHDmGqM9epA/4MQGasBbMDcWQ+hmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwIpM53dZMGXHIydVY1Gbw3N7TFPi9l7gf1lEhXEwxxQ15vc4U4W3MoIwt9Cv8n8H
         x4T5a3uc0wRixpCY3v0rSWkicurj0OdeILHwdBq5HEbT1zxySIM/Eaddl3hdPMWZ2Q
         Io7yc/jm8RBz5euXKpO+JDF6uAPSymj0Zh37DFhw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 207/304] mac80211: Properly handle SKB with radiotap only
Date:   Mon, 28 Jan 2019 10:42:04 -0500
Message-Id: <20190128154341.47195-207-sashal@kernel.org>
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

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 8020919a9b99d6c990dc6a50e8215e291fbbe5a6 ]

The monitor interface Rx handling of SKBs that contain only
radiotap information was buggy as it tried to access the
SKB assuming it contains a frame.

To fix this, check the RX_FLAG_NO_PSDU flag in the Rx status
(indicting that the SKB contains only radiotap information),
and do not perform data path specific processing when the flag
is set.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 428f7ad5f9b5..77d996a60f12 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -753,6 +753,7 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	struct ieee80211_sub_if_data *monitor_sdata =
 		rcu_dereference(local->monitor_sdata);
 	bool only_monitor = false;
+	unsigned int min_head_len;
 
 	if (status->flag & RX_FLAG_RADIOTAP_HE)
 		rtap_space += sizeof(struct ieee80211_radiotap_he);
@@ -766,6 +767,8 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 		rtap_space += sizeof(*rtap) + rtap->len + rtap->pad;
 	}
 
+	min_head_len = rtap_space;
+
 	/*
 	 * First, we may need to make a copy of the skb because
 	 *  (1) we need to modify it for radiotap (if not present), and
@@ -775,18 +778,23 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	 * the SKB because it has a bad FCS/PLCP checksum.
 	 */
 
-	if (ieee80211_hw_check(&local->hw, RX_INCLUDES_FCS)) {
-		if (unlikely(origskb->len <= FCS_LEN)) {
-			/* driver bug */
-			WARN_ON(1);
-			dev_kfree_skb(origskb);
-			return NULL;
+	if (!(status->flag & RX_FLAG_NO_PSDU)) {
+		if (ieee80211_hw_check(&local->hw, RX_INCLUDES_FCS)) {
+			if (unlikely(origskb->len <= FCS_LEN + rtap_space)) {
+				/* driver bug */
+				WARN_ON(1);
+				dev_kfree_skb(origskb);
+				return NULL;
+			}
+			present_fcs_len = FCS_LEN;
 		}
-		present_fcs_len = FCS_LEN;
+
+		/* also consider the hdr->frame_control */
+		min_head_len += 2;
 	}
 
-	/* ensure hdr->frame_control and vendor radiotap data are in skb head */
-	if (!pskb_may_pull(origskb, 2 + rtap_space)) {
+	/* ensure that the expected data elements are in skb head */
+	if (!pskb_may_pull(origskb, min_head_len)) {
 		dev_kfree_skb(origskb);
 		return NULL;
 	}
-- 
2.19.1

