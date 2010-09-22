Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43069 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab0IVReY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 13:34:24 -0400
Message-ID: <4C9A3E1C.8070306@candelatech.com>
Date: Wed, 22 Sep 2010 10:34:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
References: <1285071310-11440-1-git-send-email-greearb@candelatech.com>	 <4C98DC5D.2000108@candelatech.com>	 <1285086618.12764.3.camel@jlt3.sipsolutions.net>	 <4C98E05B.8050609@candelatech.com>	 <1285088605.12764.5.camel@jlt3.sipsolutions.net>	 <1285091341.12764.7.camel@jlt3.sipsolutions.net>	 <4C9A35FD.8060201@candelatech.com> <1285174896.3684.71.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285174896.3684.71.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/22/2010 10:01 AM, Johannes Berg wrote:
> On Wed, 2010-09-22 at 09:59 -0700, Ben Greear wrote:
>
>>> maybe the stations should be moved from phy0/stations/ to
>>> phy0/wlan0/stations/ instead?
>>
>> It doesn't matter either way to me, but I'd like to get one or another
>> patch upstream.
>>
>> If you want me to change it to put stations under netdev:wlan0/ instead,
>> please just let me know.
>
> I'd prefer that, if you want to do this.
>
> johannes

Something like this?

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index e81ef4e..ebd5b69 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -368,7 +368,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
         if (!phyd)
                 return;

-       local->debugfs.stations = debugfs_create_dir("stations", phyd);
         local->debugfs.keys = debugfs_create_dir("keys", phyd);

         DEBUGFS_ADD(frequency);
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 76839d4..dea24e6 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -300,7 +300,7 @@ STA_OPS(ht_capa);

  void ieee80211_sta_debugfs_add(struct sta_info *sta)
  {
-       struct dentry *stations_dir = sta->local->debugfs.stations;
+       struct dentry *stations_dir = sta->sdata->debugfs.dir;
         u8 mac[3*ETH_ALEN];

         sta->debugfs.add_has_run = true;
@@ -308,7 +308,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
         if (!stations_dir)
                 return;

-       snprintf(mac, sizeof(mac), "%pM", sta->sta.addr);
+       snprintf(mac, sizeof(mac), "sta-%pM", sta->sta.addr);

         /*
          * This might fail due to a race condition:
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9346a6b..d03191c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -899,7 +899,6 @@ struct ieee80211_local {
  #ifdef CONFIG_MAC80211_DEBUGFS
         struct local_debugfsdentries {
                 struct dentry *rcdir;
-               struct dentry *stations;
                 struct dentry *keys;
         } debugfs;
  #endif


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

