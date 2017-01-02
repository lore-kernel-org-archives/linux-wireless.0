Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:32955 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754754AbdABH2o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 02:28:44 -0500
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: linux-doc@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 2/2] cfg80211: fix example REG_RULE usage in Documentation
Date: Mon,  2 Jan 2017 08:28:29 +0100
Message-Id: <20170102072829.9766-2-zajec5@gmail.com> (sfid-20170102_082850_570829_946553FE)
In-Reply-To: <20170102072829.9766-1-zajec5@gmail.com>
References: <20170102072829.9766-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

It's just an example, but lets make it look more real to don't confuse
people about possible REG_RULE usage. Channels are 20 MHz wide, so start
and end frequencies are 10 MHz away from the center one.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 Documentation/networking/regulatory.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/regulatory.txt b/Documentation/networking/regulatory.txt
index b4af93f..7818b5f 100644
--- a/Documentation/networking/regulatory.txt
+++ b/Documentation/networking/regulatory.txt
@@ -156,12 +156,12 @@ struct ieee80211_regdomain mydriver_jp_regdom = {
 	//.alpha2 =  "99", /* If I have no alpha2 to map it to */
 	.reg_rules = {
 		/* IEEE 802.11b/g, channels 1..14 */
-		REG_RULE(2412-20, 2484+20, 40, 6, 20, 0),
+		REG_RULE(2412-10, 2484+10, 40, 6, 20, 0),
 		/* IEEE 802.11a, channels 34..48 */
-		REG_RULE(5170-20, 5240+20, 40, 6, 20,
+		REG_RULE(5170-10, 5240+10, 40, 6, 20,
 			NL80211_RRF_NO_IR),
 		/* IEEE 802.11a, channels 52..64 */
-		REG_RULE(5260-20, 5320+20, 40, 6, 20,
+		REG_RULE(5260-10, 5320+10, 40, 6, 20,
 			NL80211_RRF_NO_IR|
 			NL80211_RRF_DFS),
 	}
-- 
2.10.1
