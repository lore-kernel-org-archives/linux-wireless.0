Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42823 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbXIFNqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 09:46:10 -0400
Message-Id: <20070905234631.159874000@sipsolutions.net>
References: <20070905234209.108005000@sipsolutions.net>
Date: Thu, 06 Sep 2007 01:42:29 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 20/21] mac80211: kill IE parse typedef
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The parse result typedef isn't needed.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211_sta.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-09-06 01:35:21.734453431 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-09-06 01:35:29.454453431 +0200
@@ -117,11 +117,10 @@ struct ieee802_11_elems {
 	u8 tspec_len;
 };
 
-typedef enum { ParseOK = 0, ParseUnknown = 1, ParseFailed = -1 } ParseRes;
+enum ParseRes { ParseOK = 0, ParseUnknown = 1, ParseFailed = -1 };
 
-
-static ParseRes ieee802_11_parse_elems(u8 *start, size_t len,
-				       struct ieee802_11_elems *elems)
+static enum ParseRes ieee802_11_parse_elems(u8 *start, size_t len,
+					    struct ieee802_11_elems *elems)
 {
 	size_t left = len;
 	u8 *pos = start;

-- 

