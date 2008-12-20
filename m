Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32077 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbYLTFzj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 00:55:39 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 21:55:39 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>,
	<johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<kalle.valo@nokia.com>
Subject: [PATCH 05/16] wireless: allow for private channel area
Date: Fri, 19 Dec 2008 21:55:11 -0800
Message-ID: <1229752522-1917-6-git-send-email-lrodriguez@atheros.com> (sfid-20081220_065605_625660_6912E235)
In-Reply-To: <1229752522-1917-5-git-send-email-lrodriguez@atheros.com>
References: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-2-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-3-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-4-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-5-git-send-email-lrodriguez@atheros.com>
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
1.5.6.rc2.15.g457bb.dirty

