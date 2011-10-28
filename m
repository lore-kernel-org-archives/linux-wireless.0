Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40091 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1J1KIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 06:08:51 -0400
Received: by wwn22 with SMTP id 22so2075421wwn.1
        for <linux-wireless@vger.kernel.org>; Fri, 28 Oct 2011 03:08:49 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH] orinoco: release BSS structures returned by cfg80211_inform_bss()
Date: Fri, 28 Oct 2011 11:00:03 +0100
Message-Id: <1319796003-404-1-git-send-email-kilroyd@googlemail.com> (sfid-20111028_120854_823825_84190D26)
In-Reply-To: <1319719502.3944.5.camel@jlt3.sipsolutions.net>
References: <1319719502.3944.5.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The pointer returned by cfg80211_inform_bss is a referenced
struct. The orinoco driver does not need to keep the struct, so
we just release it.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/scan.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/orinoco/scan.c b/drivers/net/wireless/orinoco/scan.c
index e99ca1c..93674d9 100644
--- a/drivers/net/wireless/orinoco/scan.c
+++ b/drivers/net/wireless/orinoco/scan.c
@@ -76,6 +76,7 @@ static void orinoco_add_hostscan_result(struct orinoco_private *priv,
 {
 	struct wiphy *wiphy = priv_to_wiphy(priv);
 	struct ieee80211_channel *channel;
+	struct cfg80211_bss *cbss;
 	u8 *ie;
 	u8 ie_buf[46];
 	u64 timestamp;
@@ -121,9 +122,11 @@ static void orinoco_add_hostscan_result(struct orinoco_private *priv,
 	beacon_interval = le16_to_cpu(bss->a.beacon_interv);
 	signal = SIGNAL_TO_MBM(le16_to_cpu(bss->a.level));
 
-	cfg80211_inform_bss(wiphy, channel, bss->a.bssid, timestamp,
-			    capability, beacon_interval, ie_buf, ie_len,
-			    signal, GFP_KERNEL);
+	cbss = cfg80211_inform_bss(wiphy, channel, bss->a.bssid, timestamp,
+				   capability, beacon_interval, ie_buf, ie_len,
+				   signal, GFP_KERNEL);
+	if (cbss)
+		cfg80211_put_bss(cbss);
 }
 
 void orinoco_add_extscan_result(struct orinoco_private *priv,
@@ -132,6 +135,7 @@ void orinoco_add_extscan_result(struct orinoco_private *priv,
 {
 	struct wiphy *wiphy = priv_to_wiphy(priv);
 	struct ieee80211_channel *channel;
+	struct cfg80211_bss *cbss;
 	const u8 *ie;
 	u64 timestamp;
 	s32 signal;
@@ -152,9 +156,11 @@ void orinoco_add_extscan_result(struct orinoco_private *priv,
 	ie = bss->data;
 	signal = SIGNAL_TO_MBM(bss->level);
 
-	cfg80211_inform_bss(wiphy, channel, bss->bssid, timestamp,
-			    capability, beacon_interval, ie, ie_len,
-			    signal, GFP_KERNEL);
+	cbss = cfg80211_inform_bss(wiphy, channel, bss->bssid, timestamp,
+				   capability, beacon_interval, ie, ie_len,
+				   signal, GFP_KERNEL);
+	if (cbss)
+		cfg80211_put_bss(cbss);
 }
 
 void orinoco_add_hostscan_results(struct orinoco_private *priv,
-- 
1.7.4.1

