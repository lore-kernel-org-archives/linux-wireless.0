Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:45050 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab1CRQdk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 12:33:40 -0400
Date: Fri, 18 Mar 2011 09:33:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] wireless: fix 80211 kernel-doc warnings
Message-Id: <20110318093302.9e4a0d44.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix many of each of these warnings:

Warning(include/net/cfg80211.h:519): No description found for parameter 'rxrate'
Warning(include/net/mac80211.h:1163): bad line: 

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
Corrections welcome.

 include/net/cfg80211.h |    3 ++-
 include/net/mac80211.h |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.38-git4.orig/include/net/cfg80211.h
+++ linux-2.6.38-git4/include/net/cfg80211.h
@@ -486,7 +486,8 @@ struct rate_info {
  * @plink_state: mesh peer link state
  * @signal: signal strength of last received packet in dBm
  * @signal_avg: signal strength average in dBm
- * @txrate: current unicast bitrate to this station
+ * @txrate: current unicast bitrate from this station
+ * @rxrate: current unicast bitrate to this station
  * @rx_packets: packets received from this station
  * @tx_packets: packets transmitted to this station
  * @tx_retries: cumulative retry counts
--- linux-2.6.38-git4.orig/include/net/mac80211.h
+++ linux-2.6.38-git4/include/net/mac80211.h
@@ -1160,7 +1160,7 @@ enum ieee80211_hw_flags {
  * @napi_weight: weight used for NAPI polling.  You must specify an
  *	appropriate value here if a napi_poll operation is provided
  *	by your driver.
-
+ *
  * @max_rx_aggregation_subframes: maximum buffer size (number of
  *	sub-frames) to be used for A-MPDU block ack receiver
  *	aggregation.
