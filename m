Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71207C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 21:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1319020870
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 21:22:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QSbfPj5Q";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bHc4+PnJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1319020870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbeJKEqC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 00:46:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38508 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbeJKEpy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 00:45:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EFAC460C89; Wed, 10 Oct 2018 21:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539206513;
        bh=FdUyj0Kk8glyuQvxo9pcQLqKLOW4zqxY/HQ00MFVL3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSbfPj5QghcC7ZGTuPY4wsARhEw0lRdlbd8P9UDLaU99eaTJTrPIlbZErRzl0v9cJ
         AqD4bLSXL7IVyrprOhdAiT0yKiuy5LrSJy6Y/8xSX4/sABH4TYWJURg2pMK5hqeXd9
         uVMDoper+SjDMVWHnOCiDBIQYsoQnUbY1AcKyVb4=
Received: from jouni.codeaurora.org (188-67-66-156.bb.dnainternet.fi [188.67.66.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jouni@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B050360C86;
        Wed, 10 Oct 2018 21:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539206507;
        bh=FdUyj0Kk8glyuQvxo9pcQLqKLOW4zqxY/HQ00MFVL3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHc4+PnJ1UrPp+EmL6A3HBP+mWp7aN6Om4/mWOU74FsfWq8sCs7N9OPJME4147/cY
         gCXdE72cVrvODanR+1Wj1+ZeDUkI4A8ZIxSrZyYkF7/m6I5W00jn9XuyH5nP2skaKc
         XbZGMGu8dIDiwtRBZ50Y+xwl+lCSy53jH0NdwI4s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B050360C86
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=jouni@codeaurora.org
From:   Jouni Malinen <jouni@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH 3/3] mac80211: Extend SAE authentication in infra BSS STA mode
Date:   Thu, 11 Oct 2018 00:21:21 +0300
Message-Id: <1539206481-8798-3-git-send-email-jouni@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1539206481-8798-1-git-send-email-jouni@codeaurora.org>
References: <1539206481-8798-1-git-send-email-jouni@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Previous implementation of SAE authentication in infrastructure BSS was
somewhat restricting and not exactly clean way of handling the two
auth() operations. This ended up removing and re-adding the STA entry
for the AP in the middle of authentication and also messing up
authentication state tracking through the sequence of four
Authentication frames. Furthermore, this did not work if the AP ended up
sending out SAE Confirm (auth trans #2) immediately after SAE Commit
(auth trans #1) before the station had time to transmit its SAE Confirm.

Clean up authentication state handling for the SAE case to allow two
rounds of auth() calls without dropping all state between those
operations. Track peer Confirmed status and mark authentication
completed only once both ends have confirmed.

ieee80211_mgd_auth() check for EBUSY cases is now handling only the
pending association (ifmgd->assoc_data) while all pending authentication
(ifmgd->auth_data) cases are allowed to proceed to allow user space to
start a new connection attempt from scratch even if the previously
requested authentication is still waiting completion. This is needed to
avoid making SAE error cases with retries take excessive amount of time
with no means for the user space to stop that (apart from setting the
netdev down).

As an extra bonus, the end of ieee80211_rx_mgmt_auth() can be cleaned up
to avoid the extra copy of the cfg80211_rx_mlme_mgmt() call for ongoing
SAE authentication since the new ieee80211_mark_sta_auth() helper
function can handle both completion of authentication and updates to the
STA entry under the same condition and there is no need to return from
the function between those operations.

Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mlme.c        | 70 +++++++++++++++++++++++++++++++---------------
 2 files changed, 48 insertions(+), 23 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f40a216..10a0506 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -377,6 +377,7 @@ struct ieee80211_mgd_auth_data {
 	u8 key[WLAN_KEY_LEN_WEP104];
 	u8 key_len, key_idx;
 	bool done;
+	bool peer_confirmed;
 	bool timeout_started;
 
 	u16 sae_trans, sae_status;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1818dbc..d2bc8d5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2764,8 +2764,15 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 static bool ieee80211_mark_sta_auth(struct ieee80211_sub_if_data *sdata,
 				    const u8 *bssid)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct sta_info *sta;
 
+	sdata_info(sdata, "authenticated\n");
+	ifmgd->auth_data->done = true;
+	ifmgd->auth_data->timeout = jiffies + IEEE80211_AUTH_WAIT_ASSOC;
+	ifmgd->auth_data->timeout_started = true;
+	run_again(sdata, ifmgd->auth_data->timeout);
+
 	/* move station state to auth */
 	mutex_lock(&sdata->local->sta_mtx);
 	sta = sta_info_get(sdata, bssid);
@@ -2811,7 +2818,11 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	status_code = le16_to_cpu(mgmt->u.auth.status_code);
 
 	if (auth_alg != ifmgd->auth_data->algorithm ||
-	    auth_transaction != ifmgd->auth_data->expected_transaction) {
+	    (auth_alg != WLAN_AUTH_SAE &&
+	     auth_transaction != ifmgd->auth_data->expected_transaction) ||
+	    (auth_alg == WLAN_AUTH_SAE &&
+	     (auth_transaction < ifmgd->auth_data->expected_transaction ||
+	      auth_transaction > 2))) {
 		sdata_info(sdata, "%pM unexpected authentication state: alg %d (expected %d) transact %d (expected %d)\n",
 			   mgmt->sa, auth_alg, ifmgd->auth_data->algorithm,
 			   auth_transaction,
@@ -2854,25 +2865,17 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 
 	event.u.mlme.status = MLME_SUCCESS;
 	drv_event_callback(sdata->local, sdata, &event);
-	sdata_info(sdata, "authenticated\n");
-	ifmgd->auth_data->done = true;
-	ifmgd->auth_data->timeout = jiffies + IEEE80211_AUTH_WAIT_ASSOC;
-	ifmgd->auth_data->timeout_started = true;
-	run_again(sdata, ifmgd->auth_data->timeout);
-
-	if (ifmgd->auth_data->algorithm == WLAN_AUTH_SAE &&
-	    ifmgd->auth_data->expected_transaction != 2) {
-		/*
-		 * Report auth frame to user space for processing since another
-		 * round of Authentication frames is still needed.
-		 */
-		cfg80211_rx_mlme_mgmt(sdata->dev, (u8 *)mgmt, len);
-		return;
+	if (ifmgd->auth_data->algorithm != WLAN_AUTH_SAE ||
+	    (auth_transaction == 2 &&
+	     ifmgd->auth_data->expected_transaction == 2)) {
+		if (!ieee80211_mark_sta_auth(sdata, bssid))
+			goto out_err;
+	} else if (ifmgd->auth_data->algorithm == WLAN_AUTH_SAE &&
+		   auth_transaction == 2) {
+		sdata_info(sdata, "SAE peer confirmed\n");
+		ifmgd->auth_data->peer_confirmed = true;
 	}
 
-	if (!ieee80211_mark_sta_auth(sdata, bssid))
-		goto out_err;
-
 	cfg80211_rx_mlme_mgmt(sdata->dev, (u8 *)mgmt, len);
 	return;
  out_err:
@@ -4888,6 +4891,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_mgd_auth_data *auth_data;
 	u16 auth_alg;
 	int err;
+	bool cont_auth;
 
 	/* prepare auth data structure */
 
@@ -4922,8 +4926,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 		return -EOPNOTSUPP;
 	}
 
-	if ((ifmgd->auth_data && !ifmgd->auth_data->done) ||
-	    ifmgd->assoc_data)
+	if (ifmgd->assoc_data)
 		return -EBUSY;
 
 	auth_data = kzalloc(sizeof(*auth_data) + req->auth_data_len +
@@ -4945,6 +4948,13 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 		auth_data->data_len += req->auth_data_len - 4;
 	}
 
+	/* Check if continuing authentication or trying to authenticate with the
+	 * same BSS that we were in the process of authenticating with and avoid
+	 * removal and re-addition of the STA entry in
+	 * ieee80211_prep_connection().
+	 */
+	cont_auth = ifmgd->auth_data && req->bss == ifmgd->auth_data->bss;
+
 	if (req->ie && req->ie_len) {
 		memcpy(&auth_data->data[auth_data->data_len],
 		       req->ie, req->ie_len);
@@ -4961,12 +4971,26 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 
 	/* try to authenticate/probe */
 
-	if (ifmgd->auth_data)
-		ieee80211_destroy_auth_data(sdata, false);
+	if (ifmgd->auth_data) {
+		if (cont_auth && req->auth_type == NL80211_AUTHTYPE_SAE) {
+			auth_data->peer_confirmed =
+				ifmgd->auth_data->peer_confirmed;
+		}
+		ieee80211_destroy_auth_data(sdata, cont_auth);
+	}
 
 	/* prep auth_data so we don't go into idle on disassoc */
 	ifmgd->auth_data = auth_data;
 
+	/* If this is continuation of an ongoing SAE authentication exchange
+	 * (i.e., request to send SAE Confirm) and the peer has already
+	 * confirmed, mark authentication completed since we are about to send
+	 * out SAE Confirm.
+	 */
+	if (cont_auth && req->auth_type == NL80211_AUTHTYPE_SAE &&
+	    auth_data->peer_confirmed && auth_data->sae_trans == 2)
+		ieee80211_mark_sta_auth(sdata, req->bss->bssid);
+
 	if (ifmgd->associated) {
 		u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
@@ -4984,7 +5008,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 
 	sdata_info(sdata, "authenticate with %pM\n", req->bss->bssid);
 
-	err = ieee80211_prep_connection(sdata, req->bss, false, false);
+	err = ieee80211_prep_connection(sdata, req->bss, cont_auth, false);
 	if (err)
 		goto err_clear;
 
-- 
2.7.4

