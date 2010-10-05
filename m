Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:26882 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932725Ab0JEJz0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 05:55:26 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-033782524
	for <linux-wireless@vger.kernel.org>; Tue,  5 Oct 2010 18:55:25 +0900 (JST)
Subject: [PATCH 4/5] nl80211/mac80211: Add channel utilization to survey
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, adrian@freebsd.org,
	vasanth@atheros.com
Date: Tue, 05 Oct 2010 18:55:26 +0900
Message-ID: <20101005095526.3083.82322.stgit@tt-desk>
In-Reply-To: <20101005095510.3083.46174.stgit@tt-desk>
References: <20101005095510.3083.46174.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds three new values to the survey results:

  * BUSY - percentage of time the channel was busy
  * BUSY_TX - percentage of time spent transmitting frames
  * BUSY_RX - percentage of time spent receiving frames

They are defined to be a percentage of time, normalized to 255. That way they
match the Channel Utilization of the BSS Load IE of 802.11-2007, chapter
7.3.2.28, in case we want to use that later.

I admit that these three values are ath[59]k centric - it's what is available
there, and i don't know if other chipsets have similar information.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 include/linux/nl80211.h |   10 ++++++++++
 include/net/cfg80211.h  |    6 ++++++
 net/wireless/nl80211.c  |    9 +++++++++
 3 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index f0518b0..2cc74a2 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1400,6 +1400,13 @@ enum nl80211_reg_rule_flags {
  * @__NL80211_SURVEY_INFO_INVALID: attribute number 0 is reserved
  * @NL80211_SURVEY_INFO_FREQUENCY: center frequency of channel
  * @NL80211_SURVEY_INFO_NOISE: noise level of channel (u8, dBm)
+ * @NL80211_SURVEY_INFO_BUSY: channel busy ratio (u8, percentage of time,
+ *	normalized to 255 so it matches Channel Utilization of the BSS Load IE
+ *	of 802.11-2007 chapter 7.3.2.28)
+ * @NL80211_SURVEY_INFO_BUSY_TX: percentage of time spent transmitting frames
+ *	(u8, percent 0-255, see above)
+ * @NL80211_SURVEY_INFO_BUSY_RX: percentage of time spent receiving frames
+ *	(u8, percent 0-255, see above)
  * @NL80211_SURVEY_INFO_MAX: highest survey info attribute number
  *	currently defined
  * @__NL80211_SURVEY_INFO_AFTER_LAST: internal use
@@ -1408,6 +1415,9 @@ enum nl80211_survey_info {
 	__NL80211_SURVEY_INFO_INVALID,
 	NL80211_SURVEY_INFO_FREQUENCY,
 	NL80211_SURVEY_INFO_NOISE,
+	NL80211_SURVEY_INFO_BUSY,
+	NL80211_SURVEY_INFO_BUSY_TX,
+	NL80211_SURVEY_INFO_BUSY_RX,
 
 	/* keep last */
 	__NL80211_SURVEY_INFO_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a0613ff..e86c890 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -299,6 +299,9 @@ struct key_params {
  */
 enum survey_info_flags {
 	SURVEY_INFO_NOISE_DBM = 1<<0,
+	SURVEY_INFO_BUSY = 1<<1,
+	SURVEY_INFO_BUSY_TX = 1<<2,
+	SURVEY_INFO_BUSY_RX = 1<<3,
 };
 
 /**
@@ -318,6 +321,9 @@ struct survey_info {
 	struct ieee80211_channel *channel;
 	u32 filled;
 	s8 noise;
+	u8 busy;
+	u8 busy_rx;
+	u8 busy_tx;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9c84825..26062e1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3489,6 +3489,15 @@ static int nl80211_send_survey(struct sk_buff *msg, u32 pid, u32 seq,
 	if (survey->filled & SURVEY_INFO_NOISE_DBM)
 		NLA_PUT_U8(msg, NL80211_SURVEY_INFO_NOISE,
 			    survey->noise);
+	if (survey->filled & SURVEY_INFO_BUSY)
+		NLA_PUT_U8(msg, NL80211_SURVEY_INFO_BUSY,
+			    survey->busy);
+	if (survey->filled & SURVEY_INFO_BUSY_TX)
+		NLA_PUT_U8(msg, NL80211_SURVEY_INFO_BUSY_TX,
+			    survey->busy_tx);
+	if (survey->filled & SURVEY_INFO_BUSY_RX)
+		NLA_PUT_U8(msg, NL80211_SURVEY_INFO_BUSY_RX,
+			    survey->busy_rx);
 
 	nla_nest_end(msg, infoattr);
 

