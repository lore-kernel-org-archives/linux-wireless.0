Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D28C4161D
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 12:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB6162064A
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 12:42:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eIrNsHgG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kaNu7SYj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB6162064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbeJKUJG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 16:09:06 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40430 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbeJKUJG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 16:09:06 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 18684602D7; Thu, 11 Oct 2018 12:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539261723;
        bh=ps6xgvsCOJMtSFlyXdoXQe/bza0B8VVvKiSem0Zl4KM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eIrNsHgGJjdIFtlGy6cMqmDDa6KRE6bY8WZzh649yVhtZxvCprDo+dWpJ1SZSyUNV
         mRwNpUcUVmBle/dJYm3ThC29n89sm6NabdMILGceoGT6S9gmtFtB4X+yvE35YAOykn
         fDvBmA9nG1rpdcHnPyZZWcEiRT9blpuvg9qNT0wg=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: akolli@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 10EB56072E;
        Thu, 11 Oct 2018 12:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539261722;
        bh=ps6xgvsCOJMtSFlyXdoXQe/bza0B8VVvKiSem0Zl4KM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaNu7SYjLyAj6v4Z25ouQi3LTfL7o48YSCwZoba1P/suoTgMXP9pRFqctm7hIdl7I
         /xBWcV3B/qR740AzYuNnAYYv0ZEY9F+8PFq/+ulWMqktIy12YWNwRIXV5Z3pLbYiFk
         kL9F7iZW9axp3ZBW1hSzB9pCFSahteCRtpow2ASM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 10EB56072E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=akolli@codeaurora.org
From:   Anilkumar Kolli <akolli@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [PATCH 1/2] mac80211: implement ieee80211_tx_rate_update to update rate
Date:   Thu, 11 Oct 2018 18:15:03 +0530
Message-Id: <1539261904-9016-2-git-send-email-akolli@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1539261904-9016-1-git-send-email-akolli@codeaurora.org>
References: <1539261904-9016-1-git-send-email-akolli@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Current mac80211 has provision to update tx status through
ieee80211_tx_status() and ieee80211_tx_status_ext(). But
drivers like ath10k updates the tx status from the skb except
txrate, txrate will be updated from a different path, peer stats.

Using ieee80211_tx_status_ext() in two different paths
  - (one for the stats, one for the tx rate) will duplicate the stats.

To avoid this stats duplication, ieee80211_tx_rate_update() is implemented.

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
 include/net/mac80211.h |   15 +++++++++++++++
 net/mac80211/status.c  |   22 ++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c4fadbafbf21..86a6b1117a16 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4352,6 +4352,21 @@ void ieee80211_sta_set_expected_throughput(struct ieee80211_sta *pubsta,
 					   u32 thr);
 
 /**
+ * ieee80211_tx_rate_update - transmit rate update callback
+ *
+ * Drivers should call this functions with a non-NULL pub sta
+ * This function can be used in drivers that does not have provision
+ * in updating the tx rate in data path.
+ *
+ * @hw: the hardware the frame was transmitted by
+ * @pubsta: the station to update the tx rate for.
+ * @info: tx status information
+ */
+void ieee80211_tx_rate_update(struct ieee80211_hw *hw,
+			      struct ieee80211_sta *pubsta,
+			      struct ieee80211_tx_info *info);
+
+/**
  * ieee80211_tx_status - transmit status callback
  *
  * Call this function for all transmitted frames after they have been
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 91d7c0cd1882..6272fe1b351d 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -987,6 +987,28 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_tx_status_ext);
 
+void ieee80211_tx_rate_update(struct ieee80211_hw *hw,
+			      struct ieee80211_sta *pubsta,
+			      struct ieee80211_tx_info *info)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_supported_band *sband;
+	struct sta_info *sta;
+	struct ieee80211_tx_status status;
+
+	sband = hw->wiphy->bands[info->band];
+
+	sta = container_of(pubsta, struct sta_info, sta);
+	status.skb = NULL;
+	status.info = info;
+	status.sta = pubsta;
+
+	rate_control_tx_status(local, sband, &status);
+	if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL))
+		sta->tx_stats.last_rate = info->status.rates[0];
+}
+EXPORT_SYMBOL(ieee80211_tx_rate_update);
+
 void ieee80211_report_low_ack(struct ieee80211_sta *pubsta, u32 num_packets)
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
-- 
1.7.9.5

