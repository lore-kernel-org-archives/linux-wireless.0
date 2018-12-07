Return-Path: <SRS0=Y8Bh=OQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24465C65BAF
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 12:11:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF83E20892
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 12:11:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Yrj4rK8r";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KedorpX/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF83E20892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbeLGMLF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Dec 2018 07:11:05 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37420 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbeLGMLE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Dec 2018 07:11:04 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 420B0606DD; Fri,  7 Dec 2018 12:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544184663;
        bh=hLpthe/KgJbaRbXkH9u3BlmtGeRZCchbz6y5a+EjZLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yrj4rK8r7Te2fLewn8+jpVobqakMWPu9Gg+fYrF7srgllWp3wSHsylVsjGdSI5PYU
         DmngiSGoMa80bN4BhhI6faGHJ+xPezW61keGyFcnkB6hYtd+5iPPPSGLAqkBRvsVof
         1fO7I7aK+lhOlkFbZYEupouX3AddQx+qdZmPha4o=
Received: from jouni.codeaurora.org (37-33-76-121.bb.dnainternet.fi [37.33.76.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jouni@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0EB35606DD;
        Fri,  7 Dec 2018 12:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544184661;
        bh=hLpthe/KgJbaRbXkH9u3BlmtGeRZCchbz6y5a+EjZLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KedorpX/izM8/aPQUFAwoFI0t0LPiCFfUTxYIvpZYiXYLTBxlxX7rmoeyWbBLax+l
         atyPUkHxiVg9ZAjYC67C7OzqYTiwc7ft118Iz0/CZsDdMvtrZZtb8+rh/LM4kfHaVm
         68PkZ487J3HOgfz2WqXihA8wUK+rVBirOzGFOOjA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0EB35606DD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=jouni@codeaurora.org
From:   Jouni Malinen <jouni@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH 4/5] mac80211: Declare support for Multi-BSSID if driver supports it
Date:   Fri,  7 Dec 2018 14:10:49 +0200
Message-Id: <1544184650-14124-4-git-send-email-jouni@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1544184650-14124-1-git-send-email-jouni@codeaurora.org>
References: <1544184650-14124-1-git-send-email-jouni@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Define bits and flags for indicating support of Multi-BSSID feature and
indicate support for this if the driver supports it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
---
 include/linux/ieee80211.h | 6 ++++++
 include/net/mac80211.h    | 3 +++
 net/mac80211/debugfs.c    | 1 +
 net/mac80211/main.c       | 4 ++++
 4 files changed, 14 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 407d6fd..0a84f4e 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2656,6 +2656,12 @@ enum ieee80211_tdls_actioncode {
  */
 #define WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING	BIT(2)
 
+/* Multiple BSSID capability is set in the 6th bit of the 3rd byte of the
+ * @WLAN_EID_EXT_CAPABILITY information element
+ */
+#define WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT	BIT(6)
+
+
 /* TDLS capabilities in the the 4th byte of @WLAN_EID_EXT_CAPABILITY */
 #define WLAN_EXT_CAPA4_TDLS_BUFFER_STA		BIT(4)
 #define WLAN_EXT_CAPA4_TDLS_PEER_PSM		BIT(5)
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9386cf9..e7c4e11 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2181,6 +2181,8 @@ struct ieee80211_txq {
  *	MMPDUs on station interfaces. This of course requires the driver to use
  *	TXQs to start with.
  *
+ * @IEEE80211_HW_SUPPORTS_MULTI_BSSID: Hardware supports multi BSSID
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2229,6 +2231,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_BUFF_MMPDU_TXQ,
 	IEEE80211_HW_SUPPORTS_VHT_EXT_NSS_BW,
 	IEEE80211_HW_STA_MMPDU_TXQ,
+	IEEE80211_HW_SUPPORTS_MULTI_BSSID,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 3fe541e..28a7e60 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -218,6 +218,7 @@ static const char *hw_flag_names[] = {
 	FLAG(BUFF_MMPDU_TXQ),
 	FLAG(SUPPORTS_VHT_EXT_NSS_BW),
 	FLAG(STA_MMPDU_TXQ),
+	FLAG(SUPPORTS_MULTI_BSSID),
 #undef FLAG
 };
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 83e71e6..6ad4288 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1104,6 +1104,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (ieee80211_hw_check(&local->hw, CHANCTX_STA_CSA))
 		local->ext_capa[0] |= WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING;
 
+	/* mac80211 supports multi BSSID, if the driver supports it */
+	if (ieee80211_hw_check(&local->hw, SUPPORTS_MULTI_BSSID))
+		local->ext_capa[2] |= WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT;
+
 	local->hw.wiphy->max_num_csa_counters = IEEE80211_MAX_CSA_COUNTERS_NUM;
 
 	result = wiphy_register(local->hw.wiphy);
-- 
2.7.4

