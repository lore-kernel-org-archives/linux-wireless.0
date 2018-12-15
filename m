Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF751C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A0D62084D
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbeLOJFc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:05:32 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42310 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729465AbeLOJFc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:05:32 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rK-0002oc-GB; Sat, 15 Dec 2018 11:03:42 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 15 Dec 2018 11:03:17 +0200
Message-Id: <20181215090325.31604-17-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 16/24] mac80211: Properly handle SKB with radiotap only
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

The monitor interface Rx handling of SKBs that contain only
radiotap information was buggy as it tried to access the
SKB assuming it contains a frame.

To fix this, check the RX_FLAG_NO_PSDU flag in the Rx status
(indicting that the SKB contains only radiotap information),
and do not perform data path specific processing when the flag
is set.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/rx.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 60d179bf2585..85c365fc7a0c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -754,6 +754,7 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	struct ieee80211_sub_if_data *monitor_sdata =
 		rcu_dereference(local->monitor_sdata);
 	bool only_monitor = false;
+	unsigned int min_head_len;
 
 	if (status->flag & RX_FLAG_RADIOTAP_HE)
 		rtap_space += sizeof(struct ieee80211_radiotap_he);
@@ -767,6 +768,8 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 		rtap_space += sizeof(*rtap) + rtap->len + rtap->pad;
 	}
 
+	min_head_len = rtap_space;
+
 	/*
 	 * First, we may need to make a copy of the skb because
 	 *  (1) we need to modify it for radiotap (if not present), and
@@ -776,18 +779,23 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
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
2.19.2

