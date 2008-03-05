Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.182]:21633 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348AbYCEJkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 04:40:09 -0500
Received: by el-out-1112.google.com with SMTP id v27so1942602ele.17
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2008 01:40:08 -0800 (PST)
From: Joonwoo Park <joonwpark81@gmail.com>
Cc: Joonwoo Park <joonwpark81@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: fix races between siwessid and siwencode
Date: Wed,  5 Mar 2008 18:40:09 +0900
Message-Id: <1204710009-10040-1-git-send-email-joonwpark81@gmail.com> (sfid-20080305_094021_590968_FB9842FB)
To: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

resolve: http://bughost.org/bugzilla/show_bug.cgi?id=1522

The function ieee80211_ioctl_siwencode shouldn't be called if
authentication process is not completed.
This patch makes the ieee80211_ioctl_siwessid to wait for authentication
is completed.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 net/mac80211/ieee80211_ioctl.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 5024d37..55a29f6 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -391,6 +391,7 @@ static int ieee80211_ioctl_siwessid(struct net_device *dev,
 	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
 	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		int ret;
+		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 		if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME) {
 			if (len > IEEE80211_MAX_SSID_LEN)
 				return -EINVAL;
@@ -405,8 +406,15 @@ static int ieee80211_ioctl_siwessid(struct net_device *dev,
 		ret = ieee80211_sta_set_ssid(dev, ssid, len);
 		if (ret)
 			return ret;
+
+		set_bit(IEEE80211_STA_REQ_RUN, &sdata->u.sta.request);
+
 		ieee80211_sta_req_auth(dev, &sdata->u.sta);
-		return 0;
+
+		ret = wait_event_interruptible_timeout(wq,
+			!test_bit(IEEE80211_STA_REQ_RUN, &sdata->u.sta.request),
+				HZ);
+		return (ret == HZ) ? 0 : ret;
 	}
 
 	if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
-- 
1.5.4

