Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:38170 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757098AbeEJLuP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 07:50:15 -0400
Received: by mail-wm0-f65.google.com with SMTP id y189-v6so3846854wmc.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2018 04:50:14 -0700 (PDT)
Subject: [RESEND PATCH] cfg80211: dynamically allocate per-tid stats for
 station info
References: <5AF430B2.2060903@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AF431F4.9060408@broadcom.com> (sfid-20180510_135019_562987_33757727)
Date: Thu, 10 May 2018 13:50:12 +0200
MIME-Version: 1.0
In-Reply-To: <5AF430B2.2060903@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <aspriel@gmail.com>

With the addition of TXQ stats in the per-tid statistics the struct
station_info grew significantly. This resulted in stack limit warnings
like below:

   CC [M]  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.o
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:
	In function ‘brcmf_notify_connect_status_ap’:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:5530:1:
	error: the frame size of 1592 bytes is larger than 1024 bytes

This patch adds an allocation function that those who want to provide
per-tid stats should use to allocate the tid array, ie.
struct station_info::pertid.

Cc: Toke Høiland-Jørgensen <toke@toke.dk>
Fixes: 52539ca89f36 ("cfg80211: Expose TXQ stats and parameters to
userspace")
Signed-off-by: Arend van Spriel <aspriel@gmail.com>
---
+ linux-wireless list

Johannes, Toke,

Here an alternative approach. Currently the only cfg80211-based driver
providing per-tid stats is mac80211. This patch only changes mac80211
and the other driver can keep using stack allocation. Even mac80211 could
if wanted, but I left that part as is.

I considered making the new helper more generic and allocate 'pertid' based
on filled flags, ie.:

int cfg80211_sinfo_prepare(struct station_info *sinfo, gfp_t gfp)
{
	:
	if (sinfo->filled & BIT(NL80211_STA_INFO_TID_STATS)) {
		sinfo->pertid = kzalloc(..., gfp);
		if (!pertid)
			return -ENOMEM;
	}
	:
	return 0;
}

but decided to stick close to the issue.

Regards,
Arend
---
  include/net/cfg80211.h  |  9 ++++++++-
  net/mac80211/sta_info.c | 11 ++++++-----
  net/wireless/nl80211.c  |  4 +++-
  net/wireless/util.c     | 12 ++++++++++++
  4 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8db6071..784377a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1230,7 +1230,7 @@ struct station_info {
  	u64 rx_beacon;
  	u64 rx_duration;
  	u8 rx_beacon_signal_avg;
-	struct cfg80211_tid_stats pertid[IEEE80211_NUM_TIDS + 1];
+	struct cfg80211_tid_stats *pertid;
  	s8 ack_signal;
  	s8 avg_ack_signal;
  };
@@ -5701,6 +5701,13 @@ void cfg80211_remain_on_channel_expired(struct
wireless_dev *wdev, u64 cookie,
  					struct ieee80211_channel *chan,
  					gfp_t gfp);

+/**
+ * cfg80211_sinfo_alloc_tid_stats - allocate per-tid statistics.
+ *
+ * @sinfo: the station information
+ * @gfp: allocation flags
+ */
+int cfg80211_sinfo_alloc_tid_stats(struct station_info *sinfo, gfp_t gfp);

  /**
   * cfg80211_new_sta - notify userspace about station
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 43f34aa..25e8b15 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2233,11 +2233,12 @@ void sta_set_sinfo(struct sta_info *sta, struct
station_info *sinfo)
  			sinfo->filled |= BIT(NL80211_STA_INFO_RX_BITRATE);
  	}

-	sinfo->filled |= BIT(NL80211_STA_INFO_TID_STATS);
-	for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++) {
-		struct cfg80211_tid_stats *tidstats = &sinfo->pertid[i];
-
-		sta_set_tidstats(sta, tidstats, i);
+	if (!cfg80211_sinfo_alloc_tid_stats(sinfo, GFP_KERNEL)) {
+		for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++) {
+			struct cfg80211_tid_stats *tidstats = &sinfo->pertid[i];
+	
+			sta_set_tidstats(sta, tidstats, i);
+		}
  	}

  	if (ieee80211_vif_is_mesh(&sdata->vif)) {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f7715b8..e51cae7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4663,7 +4663,7 @@ static int nl80211_send_station(struct sk_buff
*msg, u32 cmd, u32 portid,
  		int tid;

  		tidsattr = nla_nest_start(msg, NL80211_STA_INFO_TID_STATS);
-		if (!tidsattr)
+		if (!tidsattr || !sinfo->pertid)
  			goto nla_put_failure;

  		for (tid = 0; tid < IEEE80211_NUM_TIDS + 1; tid++) {
@@ -4702,6 +4702,8 @@ static int nl80211_send_station(struct sk_buff
*msg, u32 cmd, u32 portid,
  		}

  		nla_nest_end(msg, tidsattr);
+
+		kfree(sinfo->pertid);
  	}

  	nla_nest_end(msg, sinfoattr);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index d112e9a..b956c23fe 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1750,6 +1750,18 @@ int cfg80211_get_station(struct net_device *dev,
const u8 *mac_addr,
  }
  EXPORT_SYMBOL(cfg80211_get_station);

+int cfg80211_sinfo_alloc_tid_stats(struct station_info *sinfo, gfp_t gfp)
+{
+	sinfo->pertid = kcalloc(sizeof(*(sinfo->pertid)),
+				IEEE80211_NUM_TIDS + 1, gfp);
+	if (!sinfo->pertid)
+		return -ENOMEM;
+	
+	sinfo->filled |= NL80211_STA_INFO_TID_STATS;
+	return 0;
+}
+EXPORT_SYMBOL(cfg80211_sinfo_alloc_tid_stats);
+
  void cfg80211_free_nan_func(struct cfg80211_nan_func *f)
  {
  	int i;
-- 
2.7.4
