Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A0BC43613
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB0FA2084D
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbeLOJDh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:03:37 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42206 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729245AbeLOJDg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:03:36 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rC-0002oc-IW; Sat, 15 Dec 2018 11:03:34 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 15 Dec 2018 11:03:06 +0200
Message-Id: <20181215090325.31604-6-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/24] mac80211: free skb fraglist before freeing the skb
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

mac80211 uses the frag list to build AMSDU. When freeing
the skb, it may not be really freed, since someone is still
holding a reference to it.
In that case, when TCP skb is being retransmitted, the
pointer to the frag list is being reused, while the data
in there is no longer valid.
Since we will never get frag list from the network stack,
as mac80211 doesn't advertise the capability, we can safely
free and nullify it before releasing the SKB.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/status.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index aa4afbf0abaf..267236297b2a 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -556,6 +556,11 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 	}
 
 	ieee80211_led_tx(local);
+
+	if (skb_has_frag_list(skb)) {
+		kfree_skb_list(skb_shinfo(skb)->frag_list);
+		skb_shinfo(skb)->frag_list = NULL;
+	}
 }
 
 /*
-- 
2.19.2

