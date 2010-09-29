Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:43707 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab0I2PPn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 11:15:43 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 5/6] nl80211: allow drivers to indicate whether the survey data channel is in use
Date: Wed, 29 Sep 2010 17:15:30 +0200
Message-Id: <1285773331-73439-5-git-send-email-nbd@openwrt.org>
In-Reply-To: <1285773331-73439-4-git-send-email-nbd@openwrt.org>
References: <1285773331-73439-1-git-send-email-nbd@openwrt.org>
 <1285773331-73439-2-git-send-email-nbd@openwrt.org>
 <1285773331-73439-3-git-send-email-nbd@openwrt.org>
 <1285773331-73439-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some user space applications only want to display survey data for
the operating channel, however there is no API to get that yet.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/linux/nl80211.h |    2 ++
 include/net/cfg80211.h  |    2 ++
 net/wireless/nl80211.c  |    2 ++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index f0518b0..edd21ae 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1400,6 +1400,7 @@ enum nl80211_reg_rule_flags {
  * @__NL80211_SURVEY_INFO_INVALID: attribute number 0 is reserved
  * @NL80211_SURVEY_INFO_FREQUENCY: center frequency of channel
  * @NL80211_SURVEY_INFO_NOISE: noise level of channel (u8, dBm)
+ * @NL80211_SURVEY_INFO_IN_USE: channel is currently being used
  * @NL80211_SURVEY_INFO_MAX: highest survey info attribute number
  *	currently defined
  * @__NL80211_SURVEY_INFO_AFTER_LAST: internal use
@@ -1408,6 +1409,7 @@ enum nl80211_survey_info {
 	__NL80211_SURVEY_INFO_INVALID,
 	NL80211_SURVEY_INFO_FREQUENCY,
 	NL80211_SURVEY_INFO_NOISE,
+	NL80211_SURVEY_INFO_IN_USE,
 
 	/* keep last */
 	__NL80211_SURVEY_INFO_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a0613ff..ecc0403 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -293,12 +293,14 @@ struct key_params {
  * enum survey_info_flags - survey information flags
  *
  * @SURVEY_INFO_NOISE_DBM: noise (in dBm) was filled in
+ * @SURVEY_INFO_IN_USE: channel is currently being used
  *
  * Used by the driver to indicate which info in &struct survey_info
  * it has filled in during the get_survey().
  */
 enum survey_info_flags {
 	SURVEY_INFO_NOISE_DBM = 1<<0,
+	SURVEY_INFO_IN_USE = 1<<1,
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9c84825..0087c43 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3489,6 +3489,8 @@ static int nl80211_send_survey(struct sk_buff *msg, u32 pid, u32 seq,
 	if (survey->filled & SURVEY_INFO_NOISE_DBM)
 		NLA_PUT_U8(msg, NL80211_SURVEY_INFO_NOISE,
 			    survey->noise);
+	if (survey->filled & SURVEY_INFO_IN_USE)
+		NLA_PUT_FLAG(msg, NL80211_SURVEY_INFO_IN_USE);
 
 	nla_nest_end(msg, infoattr);
 
-- 
1.7.2.2

