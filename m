Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3983BC10F12
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 17:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07C4D2075B
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 17:05:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="VxOYy06j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfDORFq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:05:46 -0400
Received: from [208.74.158.174] ([208.74.158.174]:44372 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfDORFq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 13:05:46 -0400
Received: from ben-dt4.candelatech.com (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        by mail3.candelatech.com (Postfix) with ESMTP id 1744B13755B;
        Mon, 15 Apr 2019 10:05:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 1744B13755B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1555347946;
        bh=GC7JcBoBRT0o3MBDQiRlwYWp+MRpipmiaQifmIL4aaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxOYy06jtwLFP2SkCPgaLVr4ZoCJMTxlTri2zBhuUmRW5K18a3jpQiLexpkIk6n44
         y87OYFGvJAcX0jVBzvcIQhy8L1fWiQwbHqnFA2vlcs5wWGn8AtxBu2ZwdHb340K54t
         Foz5sQ23iJkExeLHCLz1YVvbSUeLZk7nn3OXZwP4=
From:   greearb@candelatech.com
To:     linux-wireless@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>
Subject: [PATCH-v2 2/2] mac80211:  add assoc-at-ms support.
Date:   Mon, 15 Apr 2019 10:05:43 -0700
Message-Id: <20190415170543.21728-2-greearb@candelatech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190415170543.21728-1-greearb@candelatech.com>
References: <20190415170543.21728-1-greearb@candelatech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

Report when sta becomes associated.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/sta_info.c | 3 +++
 net/mac80211/sta_info.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 044120c45950..6dab7abe1603 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1980,6 +1980,7 @@ int sta_info_move_state(struct sta_info *sta,
 		break;
 	case IEEE80211_STA_AUTHORIZED:
 		if (sta->sta_state == IEEE80211_STA_ASSOC) {
+			sta->auth_at_ms = ktime_to_ms(ktime_get_real());
 			ieee80211_vif_inc_num_mcast(sta->sdata);
 			set_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
 			ieee80211_check_fast_xmit(sta);
@@ -2197,6 +2198,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 			 BIT_ULL(NL80211_STA_INFO_STA_FLAGS) |
 			 BIT_ULL(NL80211_STA_INFO_BSS_PARAM) |
 			 BIT_ULL(NL80211_STA_INFO_CONNECTED_TIME) |
+			 BIT_ULL(NL80211_STA_INFO_AUTH_AT_MS) |
 			 BIT_ULL(NL80211_STA_INFO_RX_DROP_MISC);
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
@@ -2205,6 +2207,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 	}
 
 	sinfo->connected_time = ktime_get_seconds() - sta->last_connected;
+	sinfo->auth_at_ms = sta->auth_at_ms;
 	sinfo->inactive_time =
 		jiffies_to_msecs(jiffies - ieee80211_sta_last_active(sta));
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index c5d557032be5..97777978b8f5 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -455,6 +455,7 @@ struct ieee80211_sta_rx_stats {
  *	the station when it leaves powersave or polls for frames
  * @driver_buffered_tids: bitmap of TIDs the driver has data buffered on
  * @txq_buffered_tids: bitmap of TIDs that mac80211 has txq data buffered on
+ * @auth_at_ms: time (in ms) of last assoc -> auth transition
  * @last_connected: time (in seconds) when a station got connected
  * @last_seq_ctrl: last received seq/frag number from this STA (per TID
  *	plus one for non-QoS frames)
@@ -531,6 +532,7 @@ struct sta_info {
 	unsigned long driver_buffered_tids;
 	unsigned long txq_buffered_tids;
 
+	unsigned long auth_at_ms;
 	long last_connected;
 
 	/* Updated from RX path only, no locking requirements */
-- 
2.20.1

