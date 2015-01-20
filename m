Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:40203 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbbATCOq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 21:14:46 -0500
Received: by mail-pd0-f175.google.com with SMTP id fl12so6929961pdb.6
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2015 18:14:46 -0800 (PST)
From: Fred Chou <fred.chou.nd@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Fred Chou <fred.chou.nd@gmail.com>
Subject: [PATCH v2] mac80211: correct header length calculation
Date: Tue, 20 Jan 2015 10:17:27 +0800
Message-Id: <1421720247-19787-1-git-send-email-fred.chou.nd@gmail.com> (sfid-20150120_031456_615514_A5B72059)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fred Chou <fred.chou.nd@gmail.com>

HT Control field may also be present in management frames, as defined
in 8.2.4.1.10 of 802.11-2012. Account for this in calculation of header
length.

Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>
---
v2: insert management frame header length calculation after data

 net/wireless/util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 3535e8a..e2ae2d7 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -308,6 +308,12 @@ unsigned int __attribute_const__ ieee80211_hdrlen(__le16 fc)
 		goto out;
 	}
 
+	if (ieee80211_is_mgmt(fc)) {
+		if (ieee80211_has_order(fc))
+			hdrlen += IEEE80211_HT_CTL_LEN;
+		goto out;
+	}
+
 	if (ieee80211_is_ctl(fc)) {
 		/*
 		 * ACK and CTS are 10 bytes, all others 16. To see how
-- 
1.9.1

