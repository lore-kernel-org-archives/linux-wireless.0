Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out05.msg.oleane.net ([62.161.7.3]:43318 "EHLO
	smtp-out05.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaGVPPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 11:15:54 -0400
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: "'Felix Fietkau'" <nbd@openwrt.org>,
	<linux-wireless@vger.kernel.org>
References: <004101cfa58c$e0ccb3f0$a2661bd0$@acksys.fr> <53CE6B6F.3090503@openwrt.org>
In-Reply-To: <53CE6B6F.3090503@openwrt.org>
Subject: RE: get_expected_throughput introduces a kernel oops on sta_set_sinfo calls
Date: Tue, 22 Jul 2014 16:55:22 +0200
Message-ID: <005001cfa5bc$f6befc60$e43cf520$@acksys.fr> (sfid-20140722_171557_476218_74DA7BAB)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Great, it works! No more oops, and my debug printk never appears anymore.

But it looks like one line is missing in your patch, 12/15 lines announced
but only 11/14 lines present?

Thanks you so much!

-----Message d'origine-----
De : Felix Fietkau [mailto:nbd@openwrt.org] 
Envoyé : mardi 22 juillet 2014 15:47
À : Jean-Pierre Tosoni; linux-wireless@vger.kernel.org
Objet : Re: get_expected_throughput introduces a kernel oops on
sta_set_sinfo calls

On 2014-07-22 11:11, Jean-Pierre Tosoni wrote:
> Hi list,
> 
> I am using compat-wireless-20132-04-16 with kernel 3.3.8.
> I experienced a kernel oops after applying the "get_expected_throughput"
> patches series from Antonio Quartulli.
> It happens when a station_dump is issued from userspace while an 
> association has begun but does not complete immediately due to bad
channel.
> After some debugging I made this patch which solves the issue:
Please try this patch:
---
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -472,12 +472,15 @@ static void sta_set_sinfo(struct sta_info *sta, struct
station_info *sinfo)  {
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

