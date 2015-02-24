Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44392 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbbBXNm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 08:42:28 -0500
Received: by padet14 with SMTP id et14so36040970pad.11
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2015 05:42:28 -0800 (PST)
From: Masashi Honma <masashi.honma@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: me@bobcopeland.com, johannes@sipsolutions.net,
	Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH v5] mac80211: Allow 0 for NL80211_MESHCONF_PLINK_TIMEOUT to disable STA expiration
Date: Tue, 24 Feb 2015 22:42:16 +0900
Message-Id: <1424785336-3268-1-git-send-email-masashi.honma@gmail.com> (sfid-20150224_144231_799698_4A3CF89C)
In-Reply-To: <CAFk-A4=OJyzuQ04i=c5F2HpX+n8JK6RSbZrNKGU7M6J8EteH8w@mail.gmail.com>
References: <CAFk-A4=OJyzuQ04i=c5F2HpX+n8JK6RSbZrNKGU7M6J8EteH8w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both wpa_supplicant and mac80211 has inactivity timer. By default
wpa_supplicant will be timed out in 5 minutes and mac80211's it is 30 minutes.
If wpa_supplicant uses more long timer than mac80211, wpa_supplicant will get
unexpected disconnection by mac80211. This patch adds functionality of disabling
mac80211 inactivity timer to avoid to prevent wpa_supplicant inactivity timer.

I have thought setting 0xffffffff to NL80211_MESHCONF_PLINK_TIMEOUT will solve
this problem without this patch. But the approach does not work on 32 bit
system. To explain the reason, I will show STA expiration rule in kernel. This
is the expression.

(current jiffies) > (frame Rx jiffies + NL80211_MESHCONF_PLINK_TIMEOUT * 250)

On 32bit system, right side could be over flow and be unexpected small value if
NL80211_MESHCONF_PLINK_TIMEOUT is sufficiently large. STA expiration occurs by
this reason. So I made this patch.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 include/uapi/linux/nl80211.h | 3 ++-
 net/mac80211/mesh.c          | 3 ++-
 net/wireless/nl80211.c       | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1cbc3aa..0c71180 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3092,7 +3092,8 @@ enum nl80211_mesh_power_mode {
  *
  * @NL80211_MESHCONF_PLINK_TIMEOUT: If no tx activity is seen from a STA we've
  *	established peering with for longer than this time (in seconds), then
- *	remove it from the STA's list of peers.  Default is 30 minutes.
+ *	remove it from the STA's list of peers. You may set this to 0 to disable
+ *	the removal of the STA. Default is 30 minutes.
  *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 0c8b2a7..acf441f 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -574,7 +574,8 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u32 changed;
 
-	ieee80211_sta_expire(sdata, ifmsh->mshcfg.plink_timeout * HZ);
+	if (ifmsh->mshcfg.plink_timeout > 0)
+		ieee80211_sta_expire(sdata, ifmsh->mshcfg.plink_timeout * HZ);
 	mesh_path_expire(sdata);
 
 	changed = mesh_accept_plinks_update(sdata);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e9ad9d9..bef52af 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5261,7 +5261,7 @@ do {									    \
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshAwakeWindowDuration,
 				  0, 65535, mask,
 				  NL80211_MESHCONF_AWAKE_WINDOW, nla_get_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, plink_timeout, 1, 0xffffffff,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, plink_timeout, 0, 0xffffffff,
 				  mask, NL80211_MESHCONF_PLINK_TIMEOUT,
 				  nla_get_u32);
 	if (mask_out)
-- 
2.1.0

