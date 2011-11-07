Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:53656 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab1KGHrU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 02:47:20 -0500
From: <Janusz.Dziedzic@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>
Date: Mon, 7 Nov 2011 09:47:47 +0200
Subject: [PATCH] mac80211: uAPSD - fix IEEE80211_FCTL_MOREDATA bit setting
Message-ID: <3078A9B976EF864C8DDD0C499FFD07911E3B56E1EC@EXMB01.eu.tieto.com> (sfid-20111107_084724_135704_2E1482A3)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Set IEEE80211_FCTL_MOREDATA bit also in case we have buffered
frames (more than one) only for one AC.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/sta_info.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index ce962d2..8eaa746 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1354,12 +1354,12 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 			 * Use MoreData flag to indicate whether there are
 			 * more buffered frames for this STA
 			 */
-			if (!more_data)
-				hdr->frame_control &=
-					cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
-			else
+			if (more_data || !skb_queue_empty(&frames))
 				hdr->frame_control |=
 					cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+			else
+				hdr->frame_control &=
+					cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
 
 			if (ieee80211_is_data_qos(hdr->frame_control) ||
 			    ieee80211_is_qos_nullfunc(hdr->frame_control))
-- 
1.7.0.4
