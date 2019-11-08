Return-Path: <SRS0=s5sB=ZA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C152FC6195
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Nov 2019 19:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72CBE206A3
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Nov 2019 19:42:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="lMQADlGg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732087AbfKHTm0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Nov 2019 14:42:26 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:46176 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731422AbfKHTm0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Nov 2019 14:42:26 -0500
Received: from ben-dt4.candelatech.com (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        by mail3.candelatech.com (Postfix) with ESMTP id 42D0013C342;
        Fri,  8 Nov 2019 11:42:26 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 42D0013C342
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1573242146;
        bh=NV8g2arCv4enRYTpkjOzbuBqNX7QeHu72Lh1uVmAY4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lMQADlGgFZ6p+Mnq4ILUbTJC31gETgiVAt/LV7XzhuibcPFkrPARxoN9MbYyH2lBv
         JR9xYxDhpRZ+ejwVTyI+GSsepC7y/58lNgyabnPxp6m3Iv2MHhLr7r3UmplXlGScHS
         Ec7/OGO/0EfRqFs2vD1hFy8RHdEYucw7OIY9wuss=
From:   greearb@candelatech.com
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 06/10] mac80211: Make max-auth-tries configurable as module option
Date:   Fri,  8 Nov 2019 11:42:07 -0800
Message-Id: <20191108194210.23618-7-greearb@candelatech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108194210.23618-1-greearb@candelatech.com>
References: <20191108194210.23618-1-greearb@candelatech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

In some cases, one might wish to have more retries before giving up
on auth.  For instance, ath10k 9984 radios take about 270ms to
(re)calibrate when moving channels, and auth will not go out during
that calibration period.  I think that might be part of the issue
I see with roaming stations on that radio.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/mlme.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6a458aac331d..64336433925d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -35,13 +35,17 @@
 #define IEEE80211_AUTH_TIMEOUT_LONG	(HZ / 2)
 #define IEEE80211_AUTH_TIMEOUT_SHORT	(HZ / 10)
 #define IEEE80211_AUTH_TIMEOUT_SAE	(HZ * 2)
-#define IEEE80211_AUTH_MAX_TRIES	3
 #define IEEE80211_AUTH_WAIT_ASSOC	(HZ * 5)
 #define IEEE80211_ASSOC_TIMEOUT		(HZ / 5)
 #define IEEE80211_ASSOC_TIMEOUT_LONG	(HZ / 2)
 #define IEEE80211_ASSOC_TIMEOUT_SHORT	(HZ / 10)
 #define IEEE80211_ASSOC_MAX_TRIES	3
 
+static int max_auth_tries = 3;
+module_param(max_auth_tries, int, 0644);
+MODULE_PARM_DESC(max_auth_tries,
+		 "Maximum auth tries before giving up (default is 3).");
+
 static int max_nullfunc_tries = 2;
 module_param(max_nullfunc_tries, int, 0644);
 MODULE_PARM_DESC(max_nullfunc_tries,
@@ -4189,9 +4193,9 @@ static int ieee80211_auth(struct ieee80211_sub_if_data *sdata)
 
 	auth_data->tries++;
 
-	if (auth_data->tries > IEEE80211_AUTH_MAX_TRIES) {
-		sdata_info(sdata, "authentication with %pM timed out\n",
-			   auth_data->bss->bssid);
+	if (auth_data->tries > max_auth_tries) {
+		sdata_info(sdata, "authentication with %pM timed out after %d tries\n",
+			   auth_data->bss->bssid, max_auth_tries);
 
 		/*
 		 * Most likely AP is not in the range so remove the
@@ -4210,7 +4214,7 @@ static int ieee80211_auth(struct ieee80211_sub_if_data *sdata)
 
 	sdata_info(sdata, "send auth to %pM (try %d/%d)\n",
 		   auth_data->bss->bssid, auth_data->tries,
-		   IEEE80211_AUTH_MAX_TRIES);
+		   max_auth_tries);
 
 	auth_data->expected_transaction = 2;
 
-- 
2.20.1

