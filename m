Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.234]:50657 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYGINEH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 09:04:07 -0400
Received: by wr-out-0506.google.com with SMTP id 69so2127384wri.5
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 06:04:07 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh beacons
Date: Wed, 9 Jul 2008 15:11:45 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
References: <200807091511.14288.IvDoorn@gmail.com>
In-Reply-To: <200807091511.14288.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807091511.45779.IvDoorn@gmail.com> (sfid-20080709_150410_736940_4861158D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently only beacons generated in AP mode have the software
sequence number inserted. This means IBSS and Mesh mode are broken
for all hardware that require software sequence numbers.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/mac80211/tx.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 359cb36..0e7e1f3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1876,6 +1876,8 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 		hdr->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
 						  IEEE80211_STYPE_BEACON);
 
+		ieee80211_include_sequence(sdata, hdr);
+
 		num_beacons = &ifsta->num_beacons;
 	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		/* headroom, head length, tail length and maximum TIM length */
@@ -1896,6 +1898,9 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 			cpu_to_le16(local->hw.conf.beacon_int);
 		mgmt->u.beacon.capab_info = 0x0; /* 0x0 for MPs */
 
+		ieee80211_include_sequence(sdata,
+					   (struct ieee80211_hdr *)skb->data);
+
 		pos = skb_put(skb, 2);
 		*pos++ = WLAN_EID_SSID;
 		*pos++ = 0x0;
-- 
1.5.6.1

