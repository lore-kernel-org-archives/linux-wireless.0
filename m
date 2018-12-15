Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9577C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91F95206A2
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbeLOJRS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:17:18 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42368 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726030AbeLOJRS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:17:18 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rQ-0002oc-BN; Sat, 15 Dec 2018 11:03:48 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 15 Dec 2018 11:03:25 +0200
Message-Id: <20181215090325.31604-25-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 24/24] mac80211: Properly access radiotap vendor data
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

The radiotap vendor data might be placed after some other
radiotap elements, and thus when accessing it, need to access
the correct offset in the skb data. Fix the code accordingly.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/rx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 85c365fc7a0c..45aad3d3108c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -762,8 +762,12 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	if (status->flag & RX_FLAG_RADIOTAP_HE_MU)
 		rtap_space += sizeof(struct ieee80211_radiotap_he_mu);
 
+	if (status->flag & RX_FLAG_RADIOTAP_LSIG)
+		rtap_space += sizeof(struct ieee80211_radiotap_lsig);
+
 	if (unlikely(status->flag & RX_FLAG_RADIOTAP_VENDOR_DATA)) {
-		struct ieee80211_vendor_radiotap *rtap = (void *)origskb->data;
+		struct ieee80211_vendor_radiotap *rtap =
+			(void *)(origskb->data + rtap_space);
 
 		rtap_space += sizeof(*rtap) + rtap->len + rtap->pad;
 	}
-- 
2.19.2

