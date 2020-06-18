Return-Path: <SRS0=fa1V=77=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CFF5C433E0
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Jun 2020 09:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19FFE21974
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Jun 2020 09:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbgFRJg3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Jun 2020 05:36:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42470 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729060AbgFRJg3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jun 2020 05:36:29 -0400
Received: by mail-wr1-f68.google.com with SMTP id p5so5287417wrw.9
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2020 02:36:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3Y+4bGmxUuBrJ2wELVbf7b/jmN3ZRc9RtHKxx4HqB5o=;
        b=Fywi3+OtMk/W/HGWwGMSeBciS8lOE36K8gK9AnzM0AUtyFHMNJ0aS+Z+NeuaY+gBIu
         CcERG2e5t5SFwTmcWWl5qscaIGLYPdtTFJxkMCW2Jop8exFl5iOB8JBYF3YmL053dmSW
         ntLG3FdSx4jKrADYye5z5kGrE8oiYrw6r69tJKvX3mL0hHy022RIBQwaHM9kqUozPNh5
         /tcA2km8SuGab2NnxtaRnzLUZWO+U6pABWjCLPvPLMawoh7XMHgQjrRNiRk9DJebLaED
         gjnjqLi8K0XQdFAlAo5d3FJ+0ro863ACnzenW4rkF4ost97nZGX4YFrfNjCCPFR5n2k5
         Ttcg==
X-Gm-Message-State: AOAM530MzUzd7Q2TAEbEEjzCwuAWmLiRSFnz4GWQ0rMopxF+QqD4/lEv
        /fSRkGWumWS6Gxh+jkT1VNRs6znn
X-Google-Smtp-Source: ABdhPJzOlAy3DVXA5A0gTmx0uZiUvk8PEuc93/EN5ZAVWVnMTU0dCHUrLdMVtWSAhag9ORgqq+VuBQ==
X-Received: by 2002:adf:f552:: with SMTP id j18mr3466415wrp.279.1592472987038;
        Thu, 18 Jun 2020 02:36:27 -0700 (PDT)
Received: from localhost.localdomain ([87.70.42.213])
        by smtp.gmail.com with ESMTPSA id g18sm2859190wme.17.2020.06.18.02.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 02:36:26 -0700 (PDT)
From:   Shay Bar <shay.bar@celeno.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, shay.bar@celeno.com
Subject: [PATCH] mac80211: Send deauth to STA's upon AP stop
Date:   Thu, 18 Jun 2020 12:36:09 +0300
Message-Id: <20200618093609.16514-1-shay.bar@celeno.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In current code, AP is not informing STA when its going down.
So STA keep looking the AP (Null function etc.) and can't find it (it is down).

Fix is to send deauth to all associated STA's upon AP stop.
__sta_info_flush() with a true bool is only called from ieee80211_stop_ap().
Rename "vlans" -> "ap_stop".

Signed-off-by: Shay Bar <shay.bar@celeno.com>
---
 net/mac80211/sta_info.c | 20 ++++++++++++++++----
 net/mac80211/sta_info.h |  5 +++--
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index cd8487bc6fc2..46b26e66430a 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1179,7 +1179,7 @@ void sta_info_stop(struct ieee80211_local *local)
 }
 
 
-int __sta_info_flush(struct ieee80211_sub_if_data *sdata, bool vlans)
+int __sta_info_flush(struct ieee80211_sub_if_data *sdata, bool ap_stop)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta, *tmp;
@@ -1188,13 +1188,25 @@ int __sta_info_flush(struct ieee80211_sub_if_data *sdata, bool vlans)
 
 	might_sleep();
 
-	WARN_ON(vlans && sdata->vif.type != NL80211_IFTYPE_AP);
-	WARN_ON(vlans && !sdata->bss);
+	WARN_ON(ap_stop && sdata->vif.type != NL80211_IFTYPE_AP);
+	WARN_ON(ap_stop && !sdata->bss);
 
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
 		if (sdata == sta->sdata ||
-		    (vlans && sdata->bss == sta->sdata->bss)) {
+		    (ap_stop && sdata->bss == sta->sdata->bss)) {
+			if (ap_stop) {
+				u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
+				u16 stype = IEEE80211_STYPE_DEAUTH;
+				u16 reason = WLAN_REASON_DEAUTH_LEAVING;
+				ieee80211_send_deauth_disassoc(sdata,
+							       sta->sta.addr,
+							       sdata->vif.addr,
+							       stype,
+							       reason,
+							       true,
+							       frame_buf);
+			}
 			if (!WARN_ON(__sta_info_destroy_part1(sta)))
 				list_add(&sta->free_list, &free_list);
 			ret++;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 49728047dfad..f0aedfa221c2 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -789,9 +789,10 @@ void sta_info_stop(struct ieee80211_local *local);
  * Returns the number of removed STA entries.
  *
  * @sdata: sdata to remove all stations from
- * @vlans: if the given interface is an AP interface, also flush VLANs
+ * @ap_stop: if the given interface is an AP being stopped, we should send
+ * deauth to STA's and flush VLANs
  */
-int __sta_info_flush(struct ieee80211_sub_if_data *sdata, bool vlans);
+int __sta_info_flush(struct ieee80211_sub_if_data *sdata, bool ap_stop);
 
 static inline int sta_info_flush(struct ieee80211_sub_if_data *sdata)
 {
-- 
2.17.1

