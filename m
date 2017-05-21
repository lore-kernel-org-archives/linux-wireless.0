Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:36606 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbdEUIpH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 May 2017 04:45:07 -0400
Received: by mail-pg0-f43.google.com with SMTP id x64so55021383pgd.3
        for <linux-wireless@vger.kernel.org>; Sun, 21 May 2017 01:45:06 -0700 (PDT)
MIME-Version: 1.0
From: Kirill Obukhov <kirill.obukhov@gmail.com>
Date: Sun, 21 May 2017 11:45:05 +0300
Message-ID: <CAP3TkT3VE6FWBXm0K4=-pWLrmsCk4a7wuqc24KdcgYNBRQRyoA@mail.gmail.com> (sfid-20170521_104520_619810_117DDB95)
Subject: [PATCH] nl80211: Add association id to station response
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are unique association id attribute must be passed in station add request.
But we have no way to retrieve ids already in use. To solve issue
association id attribute added to station response.
---

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b083e6c..3c270a5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1098,6 +1098,7 @@ struct cfg80211_tid_stats {
  *
  * @filled: bitflag of flags using the bits of &enum nl80211_sta_info to
  *     indicate the relevant values in this struct for them
+ * @aid: station association id
  * @connected_time: time(in secs) since a station is last connected
  * @inactive_time: time since last station activity (tx/rx) in milliseconds
  * @rx_bytes: bytes (size of MPDUs) received from this station
@@ -1146,6 +1147,7 @@ struct cfg80211_tid_stats {
  */
 struct station_info {
        u64 filled;
+       u16 aid;
        u32 connected_time;
        u32 inactive_time;
        u64 rx_bytes;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 7cdf7a8..ce41299 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2091,6 +2091,7 @@ void sta_set_sinfo(struct sta_info *sta, struct
station_info *sinfo)
                sinfo->filled |= BIT(NL80211_STA_INFO_BEACON_LOSS);
        }

+       sinfo->aid = sta->sta.aid;
        sinfo->connected_time = ktime_get_seconds() - sta->last_connected;
        sinfo->inactive_time =
                jiffies_to_msecs(jiffies - ieee80211_sta_last_active(sta));
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c3bc9da..b08df75 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4303,6 +4303,7 @@ static int nl80211_send_station(struct sk_buff
*msg, u32 cmd, u32 portid,

        if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
            nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr) ||
+           nla_put_u16(msg, NL80211_ATTR_STA_AID, sinfo->aid) ||
            nla_put_u32(msg, NL80211_ATTR_GENERATION, sinfo->generation))
                goto nla_put_failure;
