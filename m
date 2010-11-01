Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.ext.nokia.com ([147.243.128.24]:26097 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab0KAMZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 08:25:59 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oA1BqGcO020116
	for <linux-wireless@vger.kernel.org>; Mon, 1 Nov 2010 13:52:28 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 12/15] cfg80211: add ssid support to periodic scan
Date: Mon,  1 Nov 2010 13:52:13 +0200
Message-Id: <1288612336-2830-13-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just add ssids in the periodic_request structure.  This is needed in order to
pass the desired ssids to filter down to the mac.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 include/net/cfg80211.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 218e59f..3ac6fc9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -721,12 +721,16 @@ struct cfg80211_scan_request {
 /**
  * struct cfg80211_periodic_request - periodic scan request description
  *
+ * @ssids: SSIDs to report (other SSIDs will be filtered out)
+ * @n_ssids: number of SSIDs
  * @n_channels: total number of channels to scan
  * @wiphy: the wiphy this was for
  * @dev: the interface
  * @channels: channels to scan
  */
 struct cfg80211_periodic_request {
+	struct cfg80211_ssid *ssids;
+	int n_ssids;
 	u32 n_channels;
 
 	/* internal */
@@ -1436,6 +1440,8 @@ struct ieee80211_txrx_stypes {
  * @max_scan_ie_len: maximum length of user-controlled IEs device can
  *	add to probe request frames transmitted during a scan, must not
  *	include fixed IEs like supported rates
+ * @max_periodic_ssids: maximum number of SSIDs the device can use in
+ *	periodic scans
  * @coverage_class: current coverage class
  * @fw_version: firmware version for ethtool reporting
  * @hw_version: hardware version for ethtool reporting
@@ -1472,6 +1478,8 @@ struct wiphy {
 	u8 max_scan_ssids;
 	u16 max_scan_ie_len;
 
+	u8 max_periodic_ssids;
+
 	int n_cipher_suites;
 	const u32 *cipher_suites;
 
-- 
1.7.0.4

