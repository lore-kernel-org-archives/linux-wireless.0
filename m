Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:45796 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbZGJMyz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 08:54:55 -0400
Received: by bwz25 with SMTP id 25so848503bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2009 05:54:52 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] cfg80211: update misleading comment
Date: Fri, 10 Jul 2009 14:54:58 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200907101454.59716.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In cfg80211_scan_request n_channels refers to the total number
of channels to scan. Update the misleading comment accordingly.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Maybe the comment is correct and it is just me who thinks it is
misleading ;) but I just stumbled over that.

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index dba7874..d458972 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -538,7 +538,7 @@ struct cfg80211_ssid {
  * @ssids: SSIDs to scan for (active scan only)
  * @n_ssids: number of SSIDs
  * @channels: channels to scan on.
- * @n_channels: number of channels for each band
+ * @n_channels: total number of channels to scan
  * @ie: optional information element(s) to add into Probe Request or %NULL
  * @ie_len: length of ie in octets
  * @wiphy: the wiphy this was for
