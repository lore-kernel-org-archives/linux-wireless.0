Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7989EC43614
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CF402084D
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbeLOJDi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:03:38 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42226 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729029AbeLOJDh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:03:37 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rD-0002oc-T7; Sat, 15 Dec 2018 11:03:36 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 15 Dec 2018 11:03:08 +0200
Message-Id: <20181215090325.31604-8-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/24] mac80211: document RCU requirements for ieee80211_tx_dequeue()
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In the iwlwifi conversion, we sometimes call this from outside
of the wake_tx_queue() method, and in those cases must be in an
RCU critical section. Document this requirement.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1553152b77e0..40ad390f0f6a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6106,6 +6106,14 @@ void ieee80211_unreserve_tid(struct ieee80211_sta *sta, u8 tid);
  * @txq: pointer obtained from station or virtual interface
  *
  * Returns the skb if successful, %NULL if no frame was available.
+ *
+ * Note that this must be called in an rcu_read_lock() critical section,
+ * which can only be released after the SKB was handled. Some pointers in
+ * skb->cb, e.g. the key pointer, are protected by by RCU and thus the
+ * critical section must persist not just for the duration of this call
+ * but for the duration of the frame handling.
+ * However, also note that while in the wake_tx_queue() method,
+ * rcu_read_lock() is already held.
  */
 struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 				     struct ieee80211_txq *txq);
-- 
2.19.2

