Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95271C282D7
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61D4F2080D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbfBFLRg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 06:17:36 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55728 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729827AbfBFLRe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 06:17:34 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grLCu-0001ED-GP; Wed, 06 Feb 2019 13:17:32 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  6 Feb 2019 13:17:13 +0200
Message-Id: <20190206111721.29283-8-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206111721.29283-1-luca@coelho.fi>
References: <20190206111721.29283-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/15] mac80211: fix position of vendor_data read
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Liad Kaufman <liad.kaufman@intel.com>

The ieee80211_vendor_radiotap was read from the beginning
of the skb->data regardless of the existence of other
elements in radiotap that would cause it to move to another
position. Fix this by taking into account where it really
should be.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/rx.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bb4d71efb6fb..c97018dd17fe 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -5,7 +5,7 @@
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018-2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -208,7 +208,24 @@ ieee80211_rx_radiotap_hdrlen(struct ieee80211_local *local,
 	}
 
 	if (status->flag & RX_FLAG_RADIOTAP_VENDOR_DATA) {
-		struct ieee80211_vendor_radiotap *rtap = (void *)skb->data;
+		struct ieee80211_vendor_radiotap *rtap;
+		int vendor_data_offset = 0;
+
+		/*
+		 * The position to look at depends on the existence (or non-
+		 * existence) of other elements, so take that into account...
+		 */
+		if (status->flag & RX_FLAG_RADIOTAP_HE)
+			vendor_data_offset +=
+				sizeof(struct ieee80211_radiotap_he);
+		if (status->flag & RX_FLAG_RADIOTAP_HE_MU)
+			vendor_data_offset +=
+				sizeof(struct ieee80211_radiotap_he_mu);
+		if (status->flag & RX_FLAG_RADIOTAP_LSIG)
+			vendor_data_offset +=
+				sizeof(struct ieee80211_radiotap_lsig);
+
+		rtap = (void *)&skb->data[vendor_data_offset];
 
 		/* alignment for fixed 6-byte vendor data header */
 		len = ALIGN(len, 2);
-- 
2.20.1

