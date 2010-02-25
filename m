Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:49036 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab0BYNHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 08:07:53 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: fix direct probe loop on ieee80211_work_purge
Date: Thu, 25 Feb 2010 15:05:38 +0200
Message-Id: <1267103138-6353-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If authentication has already been performed when the WLAN interface is
stopped, (sometimes) the ieee80211_work_purge would corrupt some
ieee80211_work-structures. The outcome is this (cleaned up):

[ 2252.398681] WARNING: at net/mac80211/work.c:995 ieee80211_work_purge
[ 2252.466430] Backtrace:
[ 2252.529266] (ieee80211_work_purge+0x0/0xcc [mac80211])
[ 2252.546875] (ieee80211_stop+0x0/0x4c0 [mac80211])

Additionally, one would get this, going on regarless of the WLAN interface
state, going on forever:

[ 2252.859985] wlan0: direct probe to 00:90:4c:60:04:00 (try -996717525)
[ 2253.055419] wlan0: direct probe to 00:90:4c:60:04:00 (try -996717524)
[ 2253.250610] wlan0: direct probe to 00:90:4c:60:04:00 (try -996717523)
[ 2253.446014] wlan0: direct probe to 00:90:4c:60:04:00 (try -996717522)
[ 2253.641357] wlan0: direct probe to 00:90:4c:60:04:00 (try -996717521)

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/mac80211/work.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 7e708d5..1e1ea30 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -869,6 +869,7 @@ static void ieee80211_work_work(struct work_struct *work)
 			break;
 		case IEEE80211_WORK_ABORT:
 			rma = WORK_ACT_TIMEOUT;
+			break;
 		case IEEE80211_WORK_DIRECT_PROBE:
 			rma = ieee80211_direct_probe(wk);
 			break;
-- 
1.6.3.3

