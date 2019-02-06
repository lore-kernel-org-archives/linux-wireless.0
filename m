Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C84CC282C2
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 630432080D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbfBFLVL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 06:21:11 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55798 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727580AbfBFLVL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 06:21:11 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grLCy-0001ED-ID; Wed, 06 Feb 2019 13:17:36 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Adiel Aloni <adiel.aloni@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  6 Feb 2019 13:17:18 +0200
Message-Id: <20190206111721.29283-13-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206111721.29283-1-luca@coelho.fi>
References: <20190206111721.29283-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/15] mac80211: shorten debug print to avoid warning
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Adiel Aloni <adiel.aloni@intel.com>

Signed-off-by: Adiel Aloni <adiel.aloni@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6d1e7e6f1c21..0b27e52daf43 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -184,7 +184,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 		 * it should be OK.
 		 */
 		sdata_info(sdata,
-			   "Wrong control channel: center-freq: %d ht-cfreq: %d ht->primary_chan: %d band: %d - Disabling HT\n",
+			   "mismatch: center-freq: %d ht-cfreq: %d ht->primary_chan: %d band: %d - Disable HT\n",
 			   channel->center_freq, ht_cfreq,
 			   ht_oper->primary_chan, channel->band);
 		ret = IEEE80211_STA_DISABLE_HT | IEEE80211_STA_DISABLE_VHT;
-- 
2.20.1

