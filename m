Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C4EC4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 15:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28C75205C9
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 15:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbfCOPjU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 11:39:20 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44128 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727619AbfCOPjU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 11:39:20 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4ovV-0004n1-SL; Fri, 15 Mar 2019 17:39:18 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 17:39:02 +0200
Message-Id: <20190315153907.16192-7-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315153907.16192-1-luca@coelho.fi>
References: <20190315153907.16192-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/11] cfg80211: don't skip multi-bssid index element
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

When creating the IEs for the nontransmitted BSS, the index
element is skipped. However, we need to get DTIM values from
it, so don't skip it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/scan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 287518c6caa4..49f700a1460b 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -269,8 +269,7 @@ static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 	tmp_new = sub_copy;
 	while (tmp_new + tmp_new[1] + 2 - sub_copy <= subie_len) {
 		if (!(tmp_new[0] == WLAN_EID_NON_TX_BSSID_CAP ||
-		      tmp_new[0] == WLAN_EID_SSID ||
-		      tmp_new[0] == WLAN_EID_MULTI_BSSID_IDX)) {
+		      tmp_new[0] == WLAN_EID_SSID)) {
 			memcpy(pos, tmp_new, tmp_new[1] + 2);
 			pos += tmp_new[1] + 2;
 		}
-- 
2.20.1

