Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25125 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbYLVSU6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 13:20:58 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 10:20:58 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v2 05/18] wireless: allow for private channel area
Date: Mon, 22 Dec 2008 10:20:26 -0800
Message-ID: <1229970039-10561-6-git-send-email-lrodriguez@atheros.com> (sfid-20081222_192101_399448_1D6FAB89)
In-Reply-To: <1229970039-10561-5-git-send-email-lrodriguez@atheros.com>
References: <1229970039-10561-1-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-2-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-3-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-4-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-5-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wireless drivers tend to require calibration or noise floor
checks. Some of these operations are channel specific. Instead
of forcing each driver to keep a separate map for these values
per channel allow for a private area on the ieee80211_channel to
reduce code overhead and size.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/wireless.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/net/wireless.h b/include/net/wireless.h
index aedefa5..ecb5cf1 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -71,6 +71,8 @@ enum ieee80211_channel_flags {
  * @max_power: maximum transmission power (in dBm)
  * @orig_mag: internal use
  * @orig_mpwr: internal use
+ * @priv: used by the driver for any of its own needs,
+ * 	could be used for example for calibration data.
  */
 struct ieee80211_channel {
 	enum ieee80211_band band;
@@ -82,6 +84,7 @@ struct ieee80211_channel {
 	int max_power;
 	u32 orig_flags;
 	int orig_mag, orig_mpwr;
+	void *priv;
 };
 
 /**
-- 
1.6.1.rc3.51.g5832d

