Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07461C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 23:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF5E0218FE
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 23:14:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ToJQAE9G";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ToJQAE9G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390302AbeLTXOP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 18:14:15 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37690 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390299AbeLTXOO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 18:14:14 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DC7A760915; Thu, 20 Dec 2018 23:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545347653;
        bh=1cOWtfmuHDBbrZaGUSiQfjbYU1tF2g/OWIqoyygSu3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToJQAE9GQSQnivrTCCGcY4G9kk/gtQx8QQLQDlj8TpsZqH/wb5jhFgSPrOxI47yJm
         1MG7FRdyyFK8bQal1b5d8W+YJlc3skuyFC6s9kWT7Y3UQ1yAJ4m7GhoUae3QjOyl6+
         slUMQNUOkcwFNldIuuW39o5d/csuXVs8l2txTKkw=
Received: from jouni.codeaurora.org (87-95-219-4.bb.dnainternet.fi [87.95.219.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jouni@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B386D60907;
        Thu, 20 Dec 2018 23:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545347653;
        bh=1cOWtfmuHDBbrZaGUSiQfjbYU1tF2g/OWIqoyygSu3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToJQAE9GQSQnivrTCCGcY4G9kk/gtQx8QQLQDlj8TpsZqH/wb5jhFgSPrOxI47yJm
         1MG7FRdyyFK8bQal1b5d8W+YJlc3skuyFC6s9kWT7Y3UQ1yAJ4m7GhoUae3QjOyl6+
         slUMQNUOkcwFNldIuuW39o5d/csuXVs8l2txTKkw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B386D60907
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=jouni@codeaurora.org
From:   Jouni Malinen <jouni@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH v2 4/5] mac80211: Declare support for Multi-BSSID if driver supports it
Date:   Fri, 21 Dec 2018 01:13:55 +0200
Message-Id: <1545347636-5076-4-git-send-email-jouni@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1545347636-5076-1-git-send-email-jouni@codeaurora.org>
References: <1545347636-5076-1-git-send-email-jouni@codeaurora.org>
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
 include/linux/ieee80211.h | 5 +++++
 include/net/mac80211.h    | 3 +++
 net/mac80211/debugfs.c    | 1 +
 net/mac80211/main.c       | 4 ++++
 4 files changed, 13 insertions(+)

v2:
- remove an extra empty line to silence checkpatch.pl --strict

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 407d6fd..bd23436 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2656,6 +2656,11 @@ enum ieee80211_tdls_actioncode {
  */
 #define WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING	BIT(2)
 
+/* Multiple BSSID capability is set in the 6th bit of the 3rd byte of the
+ * @WLAN_EID_EXT_CAPABILITY information element
+ */
+#define WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT	BIT(6)
+
 /* TDLS capabilities in the the 4th byte of @WLAN_EID_EXT_CAPABILITY */
 #define WLAN_EXT_CAPA4_TDLS_BUFFER_STA		BIT(4)
 #define WLAN_EXT_CAPA4_TDLS_PEER_PSM		BIT(5)
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index aecbdf3..659c94f 100644
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
index ada8e16..2e3136b 100644
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

