Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C96BC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 08:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAFD121A80
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 08:52:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ncr6rHh+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LiWGnQUk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391620AbfBOIw6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 03:52:58 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51304 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbfBOIw5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 03:52:57 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4E3B860AD4; Fri, 15 Feb 2019 08:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550220772;
        bh=8uMc//+b3pGm0fSbwJy9xlfOHtzKzrL3aCXgxiRM+0k=;
        h=From:To:Cc:Subject:Date:From;
        b=ncr6rHh+18/ZZfOYlFYUudyS9dlBSzGuz6VNAxD4sgkV/YN7LSjfMsM87m+ySdVdR
         2mPJ6iGpJ2JOAThJ9uf2vsYaxalBrXOKawR9UxGoZfbqOiI2sS4jDS7AKdI7PhkWkc
         5PhvqP8Jkgi8iPATi8rhj7WwYS3ysFxSs0rBqkV0=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 32E9760AA2;
        Fri, 15 Feb 2019 08:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550220385;
        bh=8uMc//+b3pGm0fSbwJy9xlfOHtzKzrL3aCXgxiRM+0k=;
        h=From:To:Cc:Subject:Date:From;
        b=LiWGnQUkTONyWThYySBhnNpQ3yFlpx2KW0M7lZZQhVy9qj6VPAoM1RmM/zATAHep2
         LK+T+3ngqfJ4bUMhXQwqLhYIryy8VwcnG3mOHq6ezyX7fZOo6wDVgM/y98xDu+4AIf
         tfuFCEvz2qT4+e3g70hZgzPr09r7zcetn+LUVrhU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 32E9760AA2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH] mac80211: Restore vif beacon interval if start ap fails
Date:   Fri, 15 Feb 2019 14:16:02 +0530
Message-Id: <1550220362-5573-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The starting of AP interface can fail due to invalid
beacon interval, which does not match the minimum gcd
requirement set by the wifi driver. In such case, the
beacon interval of that interface gets updated with
that invalid beacon interval.

The next time that interface is brought up in AP mode,
an interface combination check is performed and the
beacon interval is taken from the previously set value.

In a case where an invalid beacon interval, i.e. a beacon
interval value which does not satisfy the minimum gcd criteria
set by the driver, is set, all the subsequent trials to
bring that interface in AP mode will fail, even if the
subsequent trials have a valid beacon interval.

To avoid this, in case of a failure in bringing up an
interface in AP mode due to interface combination error,
the interface beacon interval which is stored in bss
conf, needs to be restored with the last working value
of beacon interval.

Tested on ath10k using WCN3990.

Fixes: 0c317a02ca98 ("cfg80211: support virtual interfaces with different beacon intervals")
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 net/mac80211/cfg.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d65aa01..09dd1c2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -941,6 +941,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		      BSS_CHANGED_P2P_PS |
 		      BSS_CHANGED_TXPOWER;
 	int err;
+	int prev_beacon_int;
 
 	old = sdata_dereference(sdata->u.ap.beacon, sdata);
 	if (old)
@@ -963,6 +964,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	sdata->needed_rx_chains = sdata->local->rx_chains;
 
+	prev_beacon_int = sdata->vif.bss_conf.beacon_int;
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 
 	if (params->he_cap)
@@ -974,8 +976,10 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (!err)
 		ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
 	mutex_unlock(&local->mtx);
-	if (err)
+	if (err) {
+		sdata->vif.bss_conf.beacon_int = prev_beacon_int;
 		return err;
+	}
 
 	/*
 	 * Apply control port protocol, this allows us to
-- 
2.7.4

