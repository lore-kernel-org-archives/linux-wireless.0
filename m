Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:64082 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab2ACT0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 14:26:53 -0500
Received: by eaak10 with SMTP id k10so307010eaa.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2012 11:26:51 -0800 (PST)
Received: from ushik.mtv.corp.google.com (ushik.mtv.corp.google.com [172.18.102.96])
	by hpza9.eem.corp.google.com (Postfix) with ESMTP id 67E075C0060
	for <linux-wireless@vger.kernel.org>; Tue,  3 Jan 2012 11:26:51 -0800 (PST)
From: Dmitry Shmidt <dimitrysh@google.com>
Date: Mon, 19 Dec 2011 12:32:21 -0800
Subject: [PATCH] wireless: Protect regdomain change by mutex
To: linux-wireless@vger.kernel.org
Message-Id: <20120103192650.C025B3835D@ushik.mtv.corp.google.com> (sfid-20120103_202656_800887_874FDF20)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>
---
 net/wireless/reg.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 379574c..7b0add2 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1759,6 +1759,7 @@ static void restore_alpha2(char *alpha2, bool reset_user)
 static void restore_regulatory_settings(bool reset_user)
 {
 	char alpha2[2];
+	char world_alpha2[2];
 	struct reg_beacon *reg_beacon, *btmp;
 	struct regulatory_request *reg_request, *tmp;
 	LIST_HEAD(tmp_reg_req_list);
@@ -1809,11 +1810,13 @@ static void restore_regulatory_settings(bool reset_user)
 
 	/* First restore to the basic regulatory settings */
 	cfg80211_regdomain = cfg80211_world_regdom;
+	world_alpha2[0] = cfg80211_regdomain->alpha2[0];
+	world_alpha2[1] = cfg80211_regdomain->alpha2[1];
 
 	mutex_unlock(&reg_mutex);
 	mutex_unlock(&cfg80211_mutex);
 
-	regulatory_hint_core(cfg80211_regdomain->alpha2);
+	regulatory_hint_core(world_alpha2);
 
 	/*
 	 * This restores the ieee80211_regdom module parameter
-- 
1.7.3.1

