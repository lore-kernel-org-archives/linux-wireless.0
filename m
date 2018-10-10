Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655F9C46463
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 21:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E34E2087A
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 21:21:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O6i7ouiB";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nVWTrikr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E34E2087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbeJKEpp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 00:45:45 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38268 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbeJKEpp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 00:45:45 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C090B60C5F; Wed, 10 Oct 2018 21:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539206504;
        bh=VfrUAVOs/fI+UopPWSMHFdn2SB770pkuVDUqVSdZ//g=;
        h=From:To:Cc:Subject:Date:From;
        b=O6i7ouiBH3VvIvXUXmQzrW3ald+ri9uyxIP2UurObBl0L1UTFA9ZeT1kcD2b3mQjY
         3oUBj3b0O0oxYjL1sufn8Dah/XoLgytsBlWmJXPbN1e8KRnfrWc13pkWXyxx+iXV4V
         2Y3KL7Nr93Y/4oQer5NqRRKNfYF1LZuPz96tJVpg=
Received: from jouni.codeaurora.org (188-67-66-156.bb.dnainternet.fi [188.67.66.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jouni@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9455560C60;
        Wed, 10 Oct 2018 21:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539206501;
        bh=VfrUAVOs/fI+UopPWSMHFdn2SB770pkuVDUqVSdZ//g=;
        h=From:To:Cc:Subject:Date:From;
        b=nVWTrikr8W7QvtdoZK07C9Rx9E5ets9k2JRiMTqCQ7DBl4vM7+ceUyKydWU81ZEu8
         tD1i9Qnxrcje5MCydMuJZN4ZYSEMgSYOwCs2nJOcVvMxSjHEH8VpYJGLsdOx2800m4
         yDD5soqrBQdwzb9K6CEWJTB6YWOy6LA6qK1w1l+Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9455560C60
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=jouni@codeaurora.org
From:   Jouni Malinen <jouni@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH 1/3] mac80211: Helper function for marking STA authenticated
Date:   Thu, 11 Oct 2018 00:21:19 +0300
Message-Id: <1539206481-8798-1-git-send-email-jouni@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Authentication exchange can be completed in both TX and RX paths for
SAE, so move this common functionality into a helper function to avoid
having to implement practically the same operations in two places when
extending SAE implementation in the following commits.

Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
---
 net/mac80211/mlme.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 89dac79..2d3ec01 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2761,13 +2761,33 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 			    auth_data->key_idx, tx_flags);
 }
 
+static bool ieee80211_mark_sta_auth(struct ieee80211_sub_if_data *sdata,
+				    const u8 *bssid)
+{
+	struct sta_info *sta;
+
+	/* move station state to auth */
+	mutex_lock(&sdata->local->sta_mtx);
+	sta = sta_info_get(sdata, bssid);
+	if (!sta) {
+		WARN_ONCE(1, "%s: STA %pM not found", sdata->name, bssid);
+		return false;
+	}
+	if (sta_info_move_state(sta, IEEE80211_STA_AUTH)) {
+		sdata_info(sdata, "failed moving %pM to auth\n", bssid);
+		return false;
+	}
+	mutex_unlock(&sdata->local->sta_mtx);
+
+	return true;
+}
+
 static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 				   struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 bssid[ETH_ALEN];
 	u16 auth_alg, auth_transaction, status_code;
-	struct sta_info *sta;
 	struct ieee80211_event event = {
 		.type = MLME_EVENT,
 		.u.mlme.data = AUTH_EVENT,
@@ -2850,18 +2870,8 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
-	/* move station state to auth */
-	mutex_lock(&sdata->local->sta_mtx);
-	sta = sta_info_get(sdata, bssid);
-	if (!sta) {
-		WARN_ONCE(1, "%s: STA %pM not found", sdata->name, bssid);
+	if (!ieee80211_mark_sta_auth(sdata, bssid))
 		goto out_err;
-	}
-	if (sta_info_move_state(sta, IEEE80211_STA_AUTH)) {
-		sdata_info(sdata, "failed moving %pM to auth\n", bssid);
-		goto out_err;
-	}
-	mutex_unlock(&sdata->local->sta_mtx);
 
 	cfg80211_rx_mlme_mgmt(sdata->dev, (u8 *)mgmt, len);
 	return;
-- 
2.7.4

