Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46576 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbaGVNrb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 09:47:31 -0400
Message-ID: <53CE6B6F.3090503@openwrt.org> (sfid-20140722_154734_740938_6B78252B)
Date: Tue, 22 Jul 2014 15:47:27 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Jean-Pierre Tosoni <jp.tosoni@acksys.fr>,
	linux-wireless@vger.kernel.org
Subject: Re: get_expected_throughput introduces a kernel oops on sta_set_sinfo
 calls
References: <004101cfa58c$e0ccb3f0$a2661bd0$@acksys.fr>
In-Reply-To: <004101cfa58c$e0ccb3f0$a2661bd0$@acksys.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-07-22 11:11, Jean-Pierre Tosoni wrote:
> Hi list,
> 
> I am using compat-wireless-20132-04-16 with kernel 3.3.8.
> I experienced a kernel oops after applying the "get_expected_throughput"
> patches series from Antonio Quartulli.
> It happens when a station_dump is issued from userspace while an association
> has begun but does not complete immediately due to bad channel.
> After some debugging I made this patch which solves the issue:
Please try this patch:
---
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -472,12 +472,15 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
-	struct rate_control_ref *ref = local->rate_ctrl;
+	struct rate_control_ref *ref = NULL;
 	struct timespec uptime;
 	u64 packets = 0;
 	u32 thr = 0;
 	int i, ac;
 
+	if (test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
+		ref = local->rate_ctrl;
+
 	sinfo->generation = sdata->local->sta_generation;
 
 	sinfo->filled = STATION_INFO_INACTIVE_TIME |
