Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:55209 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbbASEE6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 23:04:58 -0500
Received: by mail-pd0-f177.google.com with SMTP id y13so9175971pdi.8
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2015 20:04:58 -0800 (PST)
From: Fred Chou <fred.chou.nd@gmail.com>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: Fred Chou <fred.chou.nd@gmail.com>
Subject: [PATCH] mac80211: correct header length calculation
Date: Mon, 19 Jan 2015 12:07:40 +0800
Message-Id: <1421640460-5094-1-git-send-email-fred.chou.nd@gmail.com> (sfid-20150119_050502_087999_EF99FC2E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fred Chou <fred.chou.nd@gmail.com>

HT Control field may also be present in management frames, as defined
in 8.2.4.1.10 of 802.11-2012. Account for this in calculation of 
header length.

Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>
---
 net/wireless/util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 1d2fcfa..ce9617c 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -297,6 +297,12 @@ unsigned int __attribute_const__ ieee80211_hdrlen(__le16 fc)
 {
 	unsigned int hdrlen = 24;
 
+	if (ieee80211_is_mgmt(fc)) {
+		if (ieee80211_has_order(fc))
+			hdrlen += IEEE80211_HT_CTL_LEN;
+		goto out;
+	}
+
 	if (ieee80211_is_data(fc)) {
 		if (ieee80211_has_a4(fc))
 			hdrlen = 30;
-- 
1.9.1

