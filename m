Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55355 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab0AMVP4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 16:15:56 -0500
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	stable@kernel.org
Subject: [PATCH v3] cfg80211: fix channel setting for wext
Date: Wed, 13 Jan 2010 13:23:14 -0800
Message-Id: <1263417794-13021-1-git-send-email-abhijeet.kolekar@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch fixes the bug at
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2139

Currently we cannot set the channel using wext extension
if we have already associated and disconnected. As
cfg80211_mgd_wext_siwfreq will not switch the channel if ssid is set.
This fixes it by clearing the ssid.
Following is the sequence which it tries to fix.
modprobe iwlagn
iwconfig wlan0 essid ""
ifconfig wlan0 down
iwconfig wlan0 chan X

wext is marked as deprecate.If we use nl80211 we can easily play with
setting the channel.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
cc: stable@kernel.org
---
v2: Changed mac80211 to cfg80211
v3: Added stable as cc. 
John Please take this patch for 2.6.33
 net/wireless/sme.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 2333d78..dc0fc49 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -655,6 +655,7 @@ void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 	memset(&wrqu, 0, sizeof(wrqu));
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+	wdev->wext.connect.ssid_len = 0;
 #endif
 }
 
-- 
1.6.3.3

