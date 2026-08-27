Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931B6246770
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 05:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787809533; cv=none; b=a19feJwupOlyIdTiZLJeZI4KeZBCM9Bg9wErwD0/kgwkp1Al0bwc8wGGM4CrhM4o7jdQbb/GF0x5SeAMS5yCYLgUbW5Nuk9lM1Soo4y5az8yBOhyWZxcDutby+MyyG9sL5S/Af1xLMAbgyjAWTnp/zUvwlf8jL4fl2tSPSBXrHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787809533; c=relaxed/simple;
	bh=7SSnnPit51jJsNMBuGlT1MsH9UMeAI442blVyfnnuw0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LCkVYzdynNbpxF7ymQEvGsq622gXrOpzJhheckKaVODms7/P+38B4/WdY7Oa2OgTHTmFpIdP6ZXNLyG0ZxGYjMJVResuTRXemgnLpI1xQFYzgR1cdSwSwvOxTFRpabVTZUIlcNBmb6JgMVo4eEeRSPp3tlossLGwQe+p0rqSOY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=gC4Nz42p; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="gC4Nz42p"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-39675172593so1542153a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 22:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1787809531; x=1788414331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SvTdEyQ+cDxiYOnLiahR8FnrUmN9qQwWqq/UzalQraQ=;
        b=gC4Nz42pL/GQoQ9zRbC7BFAY+TekqWQOXmDdp4iEIBF3JUqj9O5xwmt3vK6AHbH3r3
         IaSZAtOIulo8xbkOOBeHf+VfRo/7LNFu+FuTDWzeaMRGkGGx5NlvYggqPil5ewoloz/L
         jm8r1jlWxhfb+MLxVbzIzLDFFIU6E608CFp790VfsbijBmMlU+XWmHw3mCX1OZwOXnTq
         CbBnzPbMXW67XgdwXTLE67APr5QntkkIvttE5ficN2o/g8d9NiWCXZRnm507ejDZ948v
         EBQxXAqpmsML/+AQcafD3F6rFr/UxBXNyAvfLli7749TohklkwRFYV3EpDoehCYI5etg
         kbAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787809531; x=1788414331;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SvTdEyQ+cDxiYOnLiahR8FnrUmN9qQwWqq/UzalQraQ=;
        b=QQK/7AmatyG4qiQUmptRfrmHyZZwQ4BnNheU8O6RqK9wCUhBqHEvdk30FsbsUYuvJq
         zMxvnmEBrozPINqk2EVMyED1kh864yrG2xAmA3rcbC0/kiQLhmGes9G0yL2HkMBTlOLi
         vkXAQwqSrFTvy6M+IWWDqtuaogYdJ5RLN0XrsawfyMZxg9MMlFJukIKNu/66lb9XW8qC
         +ZCPh8Rr5inz1MAUsy1rp2B//r0v0vn4VqXRaph8X5Px3V98GktYu+LKkj+rSO2mCqbo
         zupiQdHMFXkTaLe3x/Zw63mXnMZyPT3UVn3fcLJM6nG8+QyzuFtGA/seAnNSrPx/Hqjo
         MZzQ==
X-Gm-Message-State: AFuF++kevahzvtOZvrru44u7FXnr0WccLuS1fhOLNHHcYXXB/hv207Lv
	VzzZQdneeMwMAXUAP6l/6EW3r4KCyFkh6vKQyYNzYPyPVX4NOPqYRuiJMaoWEeQBYPc=
X-Gm-Gg: AR+sD10etYsDtsOuHr9brbLa9rgrlR92ChO94VUpwxYkB2+yq/DxlN0cay/LlH/j8Qu
	YqffyK+p9zbjUbTnzeErbEmWBe0yxCAtwgBiTXvMzyyfI9PPxb0D7zwYAkJHw07hoFP5wVjNUKC
	FQEjBkz1/AUPbrlgQIEZEorhuoGH18tdT1bLXPU2YoJhroXVgjuKZh+1goPGElWqOEwLob/xaa3
	SlUWtIfJIMlHRXXxlA5GWpi2JQu7VWpQuNNWjmNxBXeQGb2j36RM0P3a4QugR+uK0MaWInx7Ioc
	NahleJIUgc7TEn06UdIgVPQO+M0/L0A+eDRmI5Gz6K75bOCpIYYSysXKssx0/nDCpI1jW2VBZOI
	4KLZhvBcxB/mobahc+adkNaiNq56DsnF7KqQfY0yyDKqcQ4nXeQ0B6ujGo2aKTE67NQESIjWV1g
	J1MAaRpw4IYF0dx6jIaKCBjHeYVE00jMfcDbSKrUNjPRM6bJSnWtjj3bUh1ZJOUIHZVZHjBAoeb
	qx5YywtgHGCeOiugqFHoINU9QD0CW5Qj7LR44q3/GHwnDDQXocIAbRct6rUwOnTMHaQAQXBT3jF
X-Received: by 2002:a17:90b:3c12:b0:395:4de4:92c8 with SMTP id 98e67ed59e1d1-3966d484268mr27834691a91.15.1787809530759;
        Wed, 26 Aug 2026 22:45:30 -0700 (PDT)
Received: from localhost.localdomain (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141a8f20095sm13388120c88.6.2026.08.26.22.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 22:45:30 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>
Subject: [PATCH wireless-next] wifi: mac80211: don't seed an S1G sta's last_rate
Date: Thu, 27 Aug 2026 15:44:56 +1000
Message-ID: <20260827054456.254573-1-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When initialising the rate control system, ieee80211_s1g_sta_rate_init()
is called for S1G stations during association where it initialises a
last rate of type STA_STATS_RATE_TYPE_S1G but does not initialise
nss, mcs bw etc. Since the last_rate no longer has a value equivalent
to STA_STATS_RATE_INVALID, the invalid rate will be decoded and
the NL80211_STA_INFO_RX_BITRATE flag will be set.

As a result, there is a period during association before the first
data frame is rx'ed where the seeded value is overwritten by
ieee80211_rx_h_sta_process() while this invalid last_rate lives. If
the sta is desroyed during this process, nl80211_put_sta_rate() will
call into cfg80211_calculate_bitrate() and attempt to calculate
the bitrate using the invalid last_rate leading to a WARN:

4,336,675067400,-;------------[ cut here ]------------
4,337,675067524,-;WARNING: net/wireless/util.c:1960 at cfg80211_calculate_bitrate+0x4d8/0x8b0 [cfg80211], CPU#3: kworker/u16:3/874
4,338,675068176,-;invalid rate bw=0, mcs=0, nss=0
[snip loaded modules]
4,341,675068954,-;Hardware name: BCM2711
4,342,675068961,-;Workqueue: events_unbound cfg80211_wiphy_work [cfg80211]
4,343,675069386,-;Call trace:
4,344,675069392,-; unwind_backtrace from show_stack+0x10/0x14
4,345,675069440,-; show_stack from dump_stack_lvl+0xa8/0xb8
4,346,675069475,-; dump_stack_lvl from __warn+0x90/0x224
4,347,675069517,-; __warn from warn_slowpath_fmt+0x130/0x1a8
4,348,675069559,-; warn_slowpath_fmt from cfg80211_calculate_bitrate+0x4d8/0x8b0 [cfg80211]
4,349,675070005,-; cfg80211_calculate_bitrate [cfg80211] from nl80211_put_sta_rate+0x48/0x590 [cfg80211]
4,350,675070819,-; nl80211_put_sta_rate [cfg80211] from nl80211_put_sta_info_common+0x4f4/0xd50 [cfg80211]
4,351,675071616,-; nl80211_put_sta_info_common [cfg80211] from nl80211_send_station.constprop.0+0x114/0x424 [cfg80211]
4,352,675072427,-; nl80211_send_station.constprop.0 [cfg80211] from cfg80211_del_sta_sinfo+0xc4/0x368 [cfg80211]
4,353,675073222,-; cfg80211_del_sta_sinfo [cfg80211] from __sta_info_destroy_part2+0x108/0x2c0 [mac80211]
4,354,675074178,-; __sta_info_destroy_part2 [mac80211] from sta_info_destroy_addr+0x4c/0x88 [mac80211]
4,355,675075243,-; sta_info_destroy_addr [mac80211] from ieee80211_destroy_assoc_data+0x194/0x2d8 [mac80211]
4,356,675075920,-; ieee80211_destroy_assoc_data [mac80211] from ieee80211_rx_mgmt_assoc_resp+0x220/0x1d4c [mac80211]
4,357,675076558,-; ieee80211_rx_mgmt_assoc_resp [mac80211] from ieee80211_iface_work+0x1c0/0x5d0 [mac80211]
4,358,675077187,-; ieee80211_iface_work [mac80211] from cfg80211_wiphy_work+0x110/0x368 [cfg80211]
4,359,675077763,-; cfg80211_wiphy_work [cfg80211] from process_one_work+0x260/0x868
4,360,675078022,-; process_one_work from worker_thread+0x1bc/0x3ec
4,361,675078042,-; worker_thread from kthread+0x120/0x154
4,362,675078060,-; kthread from ret_from_fork+0x14/0x20
4,363,675078074,-;Exception stack(0xf0ac1fb0 to 0xf0ac1ff8)
4,364,675078081,-;1fa0:                                     00000000 00000000 00000000 00000000
4,365,675078088,-;1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
4,366,675078093,-;1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
4,367,675080226,-;irq event stamp: 15780967
4,368,675080287,-;hardirqs last  enabled at (15780975): [<c050c154>] __up_console_sem+0x50/0x60
4,369,675080395,-;hardirqs last disabled at (15780982): [<c050c140>] __up_console_sem+0x3c/0x60
4,370,675080497,-;softirqs last  enabled at (15780966): [<c0476f14>] handle_softirqs+0x398/0x650
4,371,675080608,-;softirqs last disabled at (15780939): [<c0477388>] __irq_exit_rcu+0x150/0x1f0
4,372,675080715,-;---[ end trace 0000000000000000 ]---

To fix, we can simply not seed this psuedo rate. It was originally
implemented to avoid errornous paths that S1G shouldn't take, but those
have since been fixed / cleaned up. While we are here, we also don't
need to initialise the tx side's last rate with
IEEE80211_TX_RC_S1G_MCS (which is equivalent to
IEEE80211_TX_RC_VHT_MCS). The entire tx reporting side does not
support S1G widths and is assumed to be handled by the driver so
we can just remove the entire function.

Fixes: 12bf8fad4ca3 ("mac80211: initialize last_rate for S1G STAs")
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
This could go into wireless, but it is a really minor bug that is hard
to hit and doesn't really affect anything so I have targetted next.
---
 net/mac80211/ieee80211_i.h |  1 -
 net/mac80211/mlme.c        | 14 +++++---------
 net/mac80211/rate.c        |  1 -
 net/mac80211/s1g.c         |  8 --------
 4 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5761e9621491..d06cb8e7dfb3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2388,7 +2388,6 @@ ieee80211_he_op_ie_to_bss_conf(struct ieee80211_vif *vif,
 			const struct ieee80211_he_operation *he_op_ie_elem);
 
 /* S1G */
-void ieee80211_s1g_sta_rate_init(struct sta_info *sta);
 bool ieee80211_s1g_is_twt_setup(struct sk_buff *skb);
 void ieee80211_s1g_rx_twt_action(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f51167f0fc46..47ec703f1094 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6347,7 +6347,6 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 }
 
 static int ieee80211_mgd_setup_link_sta(struct ieee80211_link_data *link,
-					struct sta_info *sta,
 					struct link_sta_info *link_sta,
 					struct cfg80211_bss *cbss)
 {
@@ -6362,11 +6361,9 @@ static int ieee80211_mgd_setup_link_sta(struct ieee80211_link_data *link,
 	memcpy(link_sta->addr, cbss->bssid, ETH_ALEN);
 	memcpy(link_sta->pub->addr, cbss->bssid, ETH_ALEN);
 
-	/* TODO: S1G Basic Rate Set is expressed elsewhere */
-	if (cbss->channel->band == NL80211_BAND_S1GHZ) {
-		ieee80211_s1g_sta_rate_init(sta);
+	/* S1G does not use basic rates */
+	if (cbss->channel->band == NL80211_BAND_S1GHZ)
 		return 0;
-	}
 
 	sband = local->hw.wiphy->bands[cbss->channel->band];
 
@@ -7107,7 +7104,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 			}
 		}
 
-		err = ieee80211_mgd_setup_link_sta(link, sta, link_sta,
+		err = ieee80211_mgd_setup_link_sta(link, link_sta,
 						   assoc_data->link[link_id].bss);
 		if (err)
 			goto out_err;
@@ -9699,8 +9696,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 			goto out_err;
 		}
 
-		err = ieee80211_mgd_setup_link_sta(link, new_sta,
-						   link_sta, cbss);
+		err = ieee80211_mgd_setup_link_sta(link, link_sta, cbss);
 		if (err) {
 			rcu_read_unlock();
 			sta_info_free(local, new_sta);
@@ -11090,7 +11086,7 @@ ieee80211_process_ml_reconf_resp(struct ieee80211_sub_if_data *sdata,
 			goto disconnect;
 		}
 
-		if (ieee80211_mgd_setup_link_sta(link, sta, link_sta,
+		if (ieee80211_mgd_setup_link_sta(link, link_sta,
 						 add_links_data->link[link_id].bss))
 			goto disconnect;
 
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 64768abb0a5f..bcc6c4167395 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -57,7 +57,6 @@ void rate_control_rate_init(struct link_sta_info *link_sta)
 
 	/* TODO: check for minstrel_s1g ? */
 	if (sband->band == NL80211_BAND_S1GHZ) {
-		ieee80211_s1g_sta_rate_init(sta);
 		rcu_read_unlock();
 		return;
 	}
diff --git a/net/mac80211/s1g.c b/net/mac80211/s1g.c
index 825fcf3f909b..7f897552c686 100644
--- a/net/mac80211/s1g.c
+++ b/net/mac80211/s1g.c
@@ -9,14 +9,6 @@
 #include "ieee80211_i.h"
 #include "driver-ops.h"
 
-void ieee80211_s1g_sta_rate_init(struct sta_info *sta)
-{
-	/* avoid indicating legacy bitrates for S1G STAs */
-	sta->deflink.tx_stats.last_rate.flags |= IEEE80211_TX_RC_S1G_MCS;
-	sta->deflink.rx_stats.last_rate =
-			STA_STATS_FIELD(TYPE, STA_STATS_RATE_TYPE_S1G);
-}
-
 bool ieee80211_s1g_is_twt_setup(struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
-- 
2.43.0

