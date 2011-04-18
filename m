Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56443 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab1DRPF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 11:05:26 -0400
Subject: [PATCH] mac80211: explain padding in place of rate field
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 17:05:21 +0200
Message-ID: <1303139121.3812.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Apparently this was confusing still ... add a
note that the byte is needed as padding.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/rx.c	2011-04-18 17:02:40.000000000 +0200
+++ b/net/mac80211/rx.c	2011-04-18 17:04:07.000000000 +0200
@@ -143,7 +143,8 @@ ieee80211_add_rx_radiotap_header(struct
 	if (status->flag & RX_FLAG_HT) {
 		/*
 		 * MCS information is a separate field in radiotap,
-		 * added below.
+		 * added below. The byte here is needed as padding
+		 * for the channel though, so initialise it to 0.
 		 */
 		*pos = 0;
 	} else {


