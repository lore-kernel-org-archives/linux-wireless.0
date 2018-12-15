Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED69C43612
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22D212084D
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbeLOJDg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:03:36 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42186 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729029AbeLOJDf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:03:35 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rA-0002oc-FW; Sat, 15 Dec 2018 11:03:32 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 15 Dec 2018 11:03:03 +0200
Message-Id: <20181215090325.31604-3-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/24] ieee80211: add bits for TWT in Extended Capabilities IE
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

These bits are defined in ieee802.11ax to advertise support
for TWT in addition to the bits in the HE IE.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/linux/ieee80211.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 407d6fd66fa9..a9484b3e898d 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2687,6 +2687,10 @@ enum ieee80211_tdls_actioncode {
  */
 #define WLAN_EXT_CAPA9_FTM_INITIATOR	BIT(7)
 
+/* Defines support for TWT Requester and TWT Responder */
+#define WLAN_EXT_CAPA10_TWT_REQUESTER_SUPPORT	BIT(5)
+#define WLAN_EXT_CAPA10_TWT_RESPONDER_SUPPORT	BIT(6)
+
 /* TDLS specific payload type in the LLC/SNAP header */
 #define WLAN_TDLS_SNAP_RFTYPE	0x2
 
-- 
2.19.2

