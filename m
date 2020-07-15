Return-Path: <SRS0=DhnA=A2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15479C433E2
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Jul 2020 16:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCEE220672
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Jul 2020 16:46:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="Eiorew4I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgGOQqE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 15 Jul 2020 12:46:04 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:37108 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgGOQpk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Jul 2020 12:45:40 -0400
Received: from ben-dt4.candelatech.com (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        by mail3.candelatech.com (Postfix) with ESMTP id 3C6E813C2B3;
        Wed, 15 Jul 2020 09:45:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 3C6E813C2B3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1594831537;
        bh=Ioro6PnyBxtE4lDkAhkDnjgJ+vat24fCfF+9kyPFDmc=;
        h=From:To:Cc:Subject:Date:From;
        b=Eiorew4IM5MH5nphqICDyplqIQJsSZ3dzaQo/LZQIcjhNF2ArVq+k/cu1rvaz1OYV
         LCxQ2NooaF0Ph69hAEm4902YEgzIrkT/wzsBz+D/xdN/FrjZ790MlVy1nLFCvL7U66
         AKPxCOVTpY4Zr+8c+/5mW88F9ArGBK4bE2FgDK9w=
From:   greearb@candelatech.com
To:     linux-wireless@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Remove vdevs from driver when firmware is unrecoverable.
Date:   Wed, 15 Jul 2020 09:45:31 -0700
Message-Id: <20200715164531.24883-1-greearb@candelatech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

While testing ax200 (backport version hacked into a 5.4 kernel),
I noticed a KASAN use-after-free.  I think this is because the
old logic would clear the SDATA_IN_DRIVER flag without actually
removing it from the driver.  Then a bit later, the driver would
try to access some sdata memory.

So instead, tell the driver to remove the vdevs.  The kernel still
splats a lot of warnings in this case, but I did not see a KASAN
error and the system recovered and continued running on the remaining
radio (the one w/out fatal firmware error).

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/util.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d8b411a13784..0f5869954df3 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2190,7 +2190,7 @@ static void ieee80211_flush_completed_scan(struct ieee80211_local *local,
 
 static void ieee80211_handle_reconfig_failure(struct ieee80211_local *local)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata, *sdata_tmp;
 	struct ieee80211_chanctx *ctx;
 
 	/*
@@ -2214,8 +2214,9 @@ static void ieee80211_handle_reconfig_failure(struct ieee80211_local *local)
 	 */
 	ieee80211_sched_scan_end(local);
 
-	list_for_each_entry(sdata, &local->interfaces, list)
-		sdata->flags &= ~IEEE80211_SDATA_IN_DRIVER;
+	list_for_each_entry_safe(sdata, sdata_tmp, &local->interfaces, list)
+		if (check_sdata_in_driver(sdata))
+			drv_remove_interface(local, sdata);
 
 	/* Mark channel contexts as not being in the driver any more to avoid
 	 * removing them from the driver during the shutdown process...
@@ -2381,6 +2382,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			WARN(1, "Hardware became unavailable upon resume. This could be a software issue prior to suspend or a hardware issue.\n");
 		else
 			WARN(1, "Hardware became unavailable during restart.\n");
+		/* TODO: Requires driver reload and/or reboot to recover at this point.  Need
+		 * to notify user-space or set debugfs flag to WDT can be kicked in non-attended
+		 * devices such as APs... --Ben
+		 */
 		ieee80211_handle_reconfig_failure(local);
 		return res;
 	}
@@ -2425,12 +2430,6 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	 * report failure.
 	 */
 	if (res) {
-		list_for_each_entry_continue_reverse(sdata, &local->interfaces,
-						     list)
-			if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-			    sdata->vif.type != NL80211_IFTYPE_MONITOR &&
-			    ieee80211_sdata_running(sdata))
-				drv_remove_interface(local, sdata);
 		ieee80211_handle_reconfig_failure(local);
 		return res;
 	}
-- 
2.20.1

