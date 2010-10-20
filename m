Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33451 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab0JTRTL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 13:19:11 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 10:19:01 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <easwar.krishnan@atheros.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 6/7] cfg80211: add debug print when processing a channel
Date: Wed, 20 Oct 2010 10:18:58 -0700
Message-ID: <1287595139-10761-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1287595139-10761-1-git-send-email-lrodriguez@atheros.com>
References: <1287595139-10761-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the worst case you are seeing really odd things you want
more information than what is provided right now, for those
that insist and want debug info through CONFIG_CFG80211_REG_DEBUG
provide a print of when we are processing a channel and with what
regulatory rule.

Cc: Easwar Krishnan <easwar.krishnan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 62396b2..f0ff146 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -728,6 +728,42 @@ static const char *reg_initiator_name(enum nl80211_reg_initiator initiator)
 	}
 }
 
+#ifdef CONFIG_CFG80211_REG_DEBUG
+
+static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
+				    u32 desired_bw_khz,
+				    const struct ieee80211_reg_rule *reg_rule)
+{
+	const struct ieee80211_power_rule *power_rule;
+	const struct ieee80211_freq_range *freq_range;
+	char max_antenna_gain[32];
+
+	power_rule = &reg_rule->power_rule;
+	freq_range = &reg_rule->freq_range;
+
+	if (!power_rule->max_antenna_gain)
+		snprintf(max_antenna_gain, 32, "N/A");
+	else
+		snprintf(max_antenna_gain, 32, "%d", power_rule->max_antenna_gain);
+
+	REG_DBG_PRINT("cfg80211: Updating information on frequency %d MHz "
+		      "for %d a MHz width channel with regulatory rule:\n",
+		      chan->center_freq,
+		      KHZ_TO_MHZ(desired_bw_khz));
+
+	REG_DBG_PRINT("cfg80211: %d KHz - %d KHz @  KHz), (%s mBi, %d mBm)\n",
+		      freq_range->start_freq_khz,
+		      freq_range->end_freq_khz,
+		      max_antenna_gain,
+		      power_rule->max_eirp);
+}
+#else
+static void reg_reg_rule_print_dbg(const struct ieee80211_reg_rule *reg_rule)
+{
+	return;
+}
+#endif
+
 /*
  * Note that right now we assume the desired channel bandwidth
  * is always 20 MHz for each individual channel (HT40 uses 20 MHz
@@ -788,6 +824,8 @@ static void handle_channel(struct wiphy *wiphy,
 		return;
 	}
 
+	chan_reg_rule_print_dbg(chan, desired_bw_khz, reg_rule);
+
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
 
@@ -1132,6 +1170,8 @@ static void handle_channel_custom(struct wiphy *wiphy,
 		return;
 	}
 
+	chan_reg_rule_print_dbg(chan, desired_bw_khz, reg_rule);
+
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
 
-- 
1.7.0.4

