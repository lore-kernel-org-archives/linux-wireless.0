Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab2JELqK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 07:46:10 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 6/7] rt2800: allow to reduce tx power on devices not exporting power limit
Date: Fri,  5 Oct 2012 13:44:14 +0200
Message-Id: <1349437455-18754-6-git-send-email-sgruszka@redhat.com> (sfid-20121005_134613_870783_ECD045FE)
In-Reply-To: <1349437455-18754-1-git-send-email-sgruszka@redhat.com>
References: <1349437455-18754-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some rt2800 devices don't have their calibrated max eirp tx power in
their calibration data. For those devices reduce tx power according to
difference between regulatory max channel power and requested tx power.

This patch is based on Helmut Schaa work.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9c2c647..3f62204 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2520,6 +2520,27 @@ static int rt2800_get_txpower_bw_comp(struct rt2x00_dev *rt2x00dev,
 	return comp_value;
 }
 
+static int rt2800_get_txpower_reg_delta(struct rt2x00_dev *rt2x00dev,
+					int power_level, int max_power)
+{
+	int delta;
+
+	if (test_bit(CAPABILITY_POWER_LIMIT, &rt2x00dev->cap_flags))
+		return 0;
+
+	/*
+	 * XXX: We don't know the maximum transmit power of our hardware since
+	 * the EEPROM doesn't expose it. We only know that we are calibrated
+	 * to 100% tx power.
+	 *
+	 * Hence, we assume the regulatory limit that cfg80211 calulated for
+	 * the current channel is our maximum and if we are requested to lower
+	 * the value we just reduce our tx power accordingly.
+	 */
+	delta = power_level - max_power;
+	return min(delta, 0);
+}
+
 static u8 rt2800_compensate_txpower(struct rt2x00_dev *rt2x00dev, int is_rate_b,
 				   enum ieee80211_band band, int power_level,
 				   u8 txpower, int delta)
@@ -2586,6 +2607,12 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 	delta += rt2800_get_gain_calibration_delta(rt2x00dev);
 
 	/*
+	 * Apply regulatory delta.
+	 */
+	delta += rt2800_get_txpower_reg_delta(rt2x00dev, power_level,
+					      chan->max_power);
+
+	/*
 	 * BBP_R1 controls TX power for all rates, it allow to set the following
 	 * gains -12, -6, 0, +6 dBm by setting values 2, 1, 0, 3 respectively.
 	 *
-- 
1.7.1

