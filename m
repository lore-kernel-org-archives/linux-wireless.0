Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39368 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab0IVTp5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 15:45:57 -0400
Message-ID: <4C9A5CEB.9010708@candelatech.com>
Date: Wed, 22 Sep 2010 12:45:47 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
References: <1285071310-11440-1-git-send-email-greearb@candelatech.com> <4C98DC5D.2000108@candelatech.com> <1285086618.12764.3.camel@jlt3.sipsolutions.net> <4C98E05B.8050609@candelatech.com> <1285088605.12764.5.camel@jlt3.sipsolutions.net> <1285091341.12764.7.camel@jlt3.sipsolutions.net> <4C9A35FD.8060201@candelatech.com> <1285174896.3684.71.camel@jlt3.sipsolutions.net> <4C9A3E1C.8070306@candelatech.com> <1285180265.3684.74.camel@jlt3.sipsolutions.net> <20100922184846.GI5515@tuxdriver.com>
In-Reply-To: <20100922184846.GI5515@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/22/2010 11:48 AM, John W. Linville wrote:
> On Wed, Sep 22, 2010 at 08:31:05PM +0200, Johannes Berg wrote:
>> On Wed, 2010-09-22 at 10:34 -0700, Ben Greear wrote:
>>
>>> @@ -308,7 +308,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
>>>           if (!stations_dir)
>>>                   return;
>>>
>>> -       snprintf(mac, sizeof(mac), "%pM", sta->sta.addr);
>>> +       snprintf(mac, sizeof(mac), "sta-%pM", sta->sta.addr);
>>
>> Wouldn't a stations/ subdirectory in netdev:wlan0 be nicer? I don't
>> really care too much -- what do others think?
>
> Sounds better that way to me too...
>

This look better?

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
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 20b2998..3e12430 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -409,6 +409,9 @@ void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata)
         sprintf(buf, "netdev:%s", sdata->name);
         sdata->debugfs.dir = debugfs_create_dir(buf,
                 sdata->local->hw.wiphy->debugfsdir);
+       if (sdata->debugfs.dir)
+               sdata->debugfs.subdir_stations = debugfs_create_dir("stations",
+                       sdata->debugfs.dir);
         add_files(sdata);
  }

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 76839d4..6b7ff9f 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -300,7 +300,7 @@ STA_OPS(ht_capa);

  void ieee80211_sta_debugfs_add(struct sta_info *sta)
  {
-       struct dentry *stations_dir = sta->local->debugfs.stations;
+       struct dentry *stations_dir = sta->sdata->debugfs.subdir_stations;
         u8 mac[3*ETH_ALEN];

         sta->debugfs.add_has_run = true;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9346a6b..3c7c230 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -564,6 +564,7 @@ struct ieee80211_sub_if_data {
  #ifdef CONFIG_MAC80211_DEBUGFS
         struct {
                 struct dentry *dir;
+               struct dentry *subdir_stations;
                 struct dentry *default_key;
                 struct dentry *default_mgmt_key;
         } debugfs;
@@ -899,7 +900,6 @@ struct ieee80211_local {
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

