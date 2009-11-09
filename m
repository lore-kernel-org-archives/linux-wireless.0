Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35804 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbZKIMkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:40:45 -0500
Received: by mail-bw0-f227.google.com with SMTP id 27so3395312bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 04:40:50 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH 11/21] mac80211: add WLAN_EID_RANN
Date: Mon,  9 Nov 2009 12:39:31 +0000
Message-Id: <1257770381-7680-12-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
References: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Process the RX of RANN information elements.

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 include/linux/ieee80211.h  |    1 +
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/util.c        |    4 ++++
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 50c684d..59ec228 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1070,6 +1070,7 @@ enum ieee80211_eid {
 	WLAN_EID_PREQ = 68,
 	WLAN_EID_PREP = 69,
 	WLAN_EID_PERR = 70,
+	WLAN_EID_RANN = 49,	/* compatible with FreeBSD */
 	/* 802.11h */
 	WLAN_EID_PWR_CONSTRAINT = 32,
 	WLAN_EID_PWR_CAPABILITY = 33,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1f4f88a..dd3e2ec 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -799,6 +799,7 @@ struct ieee802_11_elems {
 	u8 *preq;
 	u8 *prep;
 	u8 *perr;
+	u8 *rann;
 	u8 *ch_switch_elem;
 	u8 *country_elem;
 	u8 *pwr_constr_elem;
@@ -826,6 +827,7 @@ struct ieee802_11_elems {
 	u8 preq_len;
 	u8 prep_len;
 	u8 perr_len;
+	u8 rann_len;
 	u8 ch_switch_elem_len;
 	u8 country_elem_len;
 	u8 pwr_constr_elem_len;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index aedbaaa..60ccba4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -685,6 +685,10 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			elems->perr = pos;
 			elems->perr_len = elen;
 			break;
+		case WLAN_EID_RANN:
+			elems->rann = pos;
+			elems->rann_len = elen;
+			break;
 		case WLAN_EID_CHANNEL_SWITCH:
 			elems->ch_switch_elem = pos;
 			elems->ch_switch_elem_len = elen;
-- 
1.5.6.5

