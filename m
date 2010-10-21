Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:35232 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376Ab0JUNrk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 09:47:40 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 06:47:30 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Easwar Krishnan <easwar.krishnan@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH v2 6/7] cfg80211: add debug print when processing a channel
Date: Thu, 21 Oct 2010 19:17:04 +0530
Message-ID: <1287668824-3096-2-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1287668824-3096-1-git-send-email-senthilkumar@atheros.com>
References: <1287668824-3096-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <lrodriguez@atheros.com>

In the worst case you are seeing really odd things you want
more information than what is provided right now, for those
that insist and want debug info through CONFIG_CFG80211_REG_DEBUG
provide a print of when we are processing a channel and with what
regulatory rule.

Cc: Easwar Krishnan <easwar.krishnan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
v2 -- fixed compilation error if REG_DEBUG is not defined.

 net/wireless/reg.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6e7a9d8..5556c5f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -728,6 +728,41 @@ static const char *reg_initiator_name(enum nl80211_reg_initiator initiator)
 		return "Set by bug";
 	}
 }
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
+static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
+				    u32 desired_bw_khz,
+				    const struct ieee80211_reg_rule *reg_rule)
+{
+	return;
+}
 #endif

 /*
@@ -790,6 +825,8 @@ static void handle_channel(struct wiphy *wiphy,
 		return;
 	}

+	chan_reg_rule_print_dbg(chan, desired_bw_khz, reg_rule);
+
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;

@@ -1134,6 +1171,8 @@ static void handle_channel_custom(struct wiphy *wiphy,
 		return;
 	}

+	chan_reg_rule_print_dbg(chan, desired_bw_khz, reg_rule);
+
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;

--
1.7.2.1

