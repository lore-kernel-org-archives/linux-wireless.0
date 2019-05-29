Return-Path: <SRS0=kjT+=T5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0ABC28CC0
	for <linux-wireless@archiver.kernel.org>; Wed, 29 May 2019 12:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6292721019
	for <linux-wireless@archiver.kernel.org>; Wed, 29 May 2019 12:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbfE2MZu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 29 May 2019 08:25:50 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54298 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726842AbfE2MZt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 May 2019 08:25:49 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hVxeO-0007wy-4W; Wed, 29 May 2019 15:25:48 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 06/10] ieee80211: Add a missing extended capability flag definition
Date:   Wed, 29 May 2019 15:25:33 +0300
Message-Id: <20190529122537.8564-7-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190529122537.8564-1-luca@coelho.fi>
References: <20190529122537.8564-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

Add the "OBSS Narrow Bandwidth RU In OFDMA Tolerance Support" flag
definition to the definitions of the flags covered by the Extended
Capability IE.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/linux/ieee80211.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 61f0a316c6ac..902812bec11d 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2712,6 +2712,13 @@ enum ieee80211_tdls_actioncode {
 #define WLAN_EXT_CAPA10_TWT_REQUESTER_SUPPORT	BIT(5)
 #define WLAN_EXT_CAPA10_TWT_RESPONDER_SUPPORT	BIT(6)
 
+/*
+ * When set, indicates that the AP is able to tolerate 26-tone RU UL
+ * OFDMA transmissions using HE TB PPDU from OBSS (not falsely classify the
+ * 26-tone RU UL OFDMA transmissions as radar pulses).
+ */
+#define WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT BIT(7)
+
 /* Defines support for enhanced multi-bssid advertisement*/
 #define WLAN_EXT_CAPA11_EMA_SUPPORT	BIT(1)
 
-- 
2.20.1

