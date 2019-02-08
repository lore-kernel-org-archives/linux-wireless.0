Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F18ECC169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB6E720869
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfBHNYP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:24:15 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:48856 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbfBHNYO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 08:24:14 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gs60R-0008Jb-Iw; Fri, 08 Feb 2019 14:15:47 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v8 15/15] cfg80211: add missing kernel-doc for multi-BSSID fields
Date:   Fri,  8 Feb 2019 14:15:39 +0100
Message-Id: <20190208131539.6813-15-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190208131539.6813-1-johannes@sipsolutions.net>
References: <20190208131539.6813-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Add the missing kernel-doc for the new multi-BSSID fields
in struct cfg80211_bss.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 76efdc3a2200..b61b71f369c7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2035,6 +2035,10 @@ struct cfg80211_bss_ies {
  *	a BSS that hides the SSID in its beacon, this points to the BSS struct
  *	that holds the beacon data. @beacon_ies is still valid, of course, and
  *	points to the same data as hidden_beacon_bss->beacon_ies in that case.
+ * @transmitted_bss: pointer to the transmitted BSS, if this is a
+ *	non-transmitted one (multi-BSSID support)
+ * @nontrans_list: list of non-transmitted BSS, if this is a transmitted one
+ *	(multi-BSSID support)
  * @signal: signal strength value (type depends on the wiphy's signal_type)
  * @chains: bitmask for filled values in @chain_signal.
  * @chain_signal: per-chain signal strength of last received BSS in dBm.
-- 
2.17.2

