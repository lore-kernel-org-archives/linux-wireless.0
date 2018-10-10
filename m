Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1AB9C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 21:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0D6820870
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 21:21:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DnwXCmSm";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cy2w9Esb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0D6820870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbeJKEps (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 00:45:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38372 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbeJKEps (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 00:45:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EB32D60C7E; Wed, 10 Oct 2018 21:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539206508;
        bh=tFPteFBlNfN0muu+Rux2207GOaQMORFJ+IXmlOyi6sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnwXCmSmGvPYv8bJXJtDpxYeMKBGWyoQyGepGnRfvnGscmjBprqasC1ICOvDRgsJW
         dHIy55VBw3diClB7z5j4lGR0dxROJIivfibNjV+JTsJHDHFqYyJnmGKoG1lOyGvVO3
         KxqQrGByBOqRtDNVFpg8k3SupDfNYs6LaiHJDLdk=
Received: from jouni.codeaurora.org (188-67-66-156.bb.dnainternet.fi [188.67.66.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jouni@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D67CE60C8E;
        Wed, 10 Oct 2018 21:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539206503;
        bh=tFPteFBlNfN0muu+Rux2207GOaQMORFJ+IXmlOyi6sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cy2w9EsbfFtc1/2NX7j+WZoRQUaTDg5Qd3ZSF2Uo0wYioBiG0MECxPAwVbZEdGml3
         dLY/YY0e14PRqvXD1UbEN66bVikqCoh7W8R3KWL+UkE18PLxorWFOANMmBWGDv435N
         7ceBVdr+Zf3v47ag5h1OQ79Z3mCj4ZunGeJOL9xM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D67CE60C8E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=jouni@codeaurora.org
From:   Jouni Malinen <jouni@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH 2/3] mac80211: Move ieee80211_mgd_auth() EBUSY check to be before allocation
Date:   Thu, 11 Oct 2018 00:21:20 +0300
Message-Id: <1539206481-8798-2-git-send-email-jouni@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1539206481-8798-1-git-send-email-jouni@codeaurora.org>
References: <1539206481-8798-1-git-send-email-jouni@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This makes it easier to conditionally replace full allocation of
auth_data to use reallocation for the case of continuing SAE
authentication. Furthermore, there was not really any point in having
this check done so late in the function after having already completed
number of steps that cannot be used anyway in the error case.

Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
---
 net/mac80211/mlme.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2d3ec01..1818dbc 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4922,6 +4922,10 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 		return -EOPNOTSUPP;
 	}
 
+	if ((ifmgd->auth_data && !ifmgd->auth_data->done) ||
+	    ifmgd->assoc_data)
+		return -EBUSY;
+
 	auth_data = kzalloc(sizeof(*auth_data) + req->auth_data_len +
 			    req->ie_len, GFP_KERNEL);
 	if (!auth_data)
@@ -4957,12 +4961,6 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 
 	/* try to authenticate/probe */
 
-	if ((ifmgd->auth_data && !ifmgd->auth_data->done) ||
-	    ifmgd->assoc_data) {
-		err = -EBUSY;
-		goto err_free;
-	}
-
 	if (ifmgd->auth_data)
 		ieee80211_destroy_auth_data(sdata, false);
 
@@ -5007,7 +5005,6 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	mutex_lock(&sdata->local->mtx);
 	ieee80211_vif_release_channel(sdata);
 	mutex_unlock(&sdata->local->mtx);
- err_free:
 	kfree(auth_data);
 	return err;
 }
-- 
2.7.4

