Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56814 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727178AbeHaMRW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:17:22 -0400
Date: Fri, 31 Aug 2018 11:10:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] cfg80211: fix a type issue in
 ieee80211_chandef_to_operating_class()
Message-ID: <20180831081055.kvbe3k56c2slonzt@kili.mountain> (sfid-20180831_101112_766912_4EAB2494)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "chandef->center_freq1" variable is a u32 but "freq" is a u16 so we
are truncating away the high bits.  I noticed this bug because in commit
9cf0a0b4b64a ("cfg80211: Add support for 60GHz band channels 5 and 6")
we made "freq <= 56160 + 2160 * 6" a valid requency when before it was
only "freq <= 56160 + 2160 * 4" that was valid.  It introduces a static
checker warning:

    net/wireless/util.c:1571 ieee80211_chandef_to_operating_class()
    warn: always true condition '(freq <= 56160 + 2160 * 6) => (0-u16max <= 69120)'

But really we probably shouldn't have been truncating the high bits
away to begin with.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 2a89db5f2db7..4293f980e9c4 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1456,7 +1456,7 @@ bool ieee80211_chandef_to_operating_class(struct cfg80211_chan_def *chandef,
 					  u8 *op_class)
 {
 	u8 vht_opclass;
-	u16 freq = chandef->center_freq1;
+	u32 freq = chandef->center_freq1;
 
 	if (freq >= 2412 && freq <= 2472) {
 		if (chandef->width > NL80211_CHAN_WIDTH_40)
