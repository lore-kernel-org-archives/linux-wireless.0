Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [70.61.120.58] ([70.61.120.58]:33214 "EHLO smtp.tuxdriver.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab0G1TQF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 15:16:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Steve deRosier <steve@cozybit.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [RFC/PATCH] libertas_tf: add get_survey callback in order to get channel noise
Date: Wed, 28 Jul 2010 15:05:03 -0400
Message-Id: <1280343903-23290-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
_Is_ the noise floor actually reported in dBm?  Or some other unit?

 drivers/net/wireless/libertas_tf/libertas_tf.h |    3 +++
 drivers/net/wireless/libertas_tf/main.c        |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/libertas_tf.h b/drivers/net/wireless/libertas_tf/libertas_tf.h
index 737eac9..ad77b92 100644
--- a/drivers/net/wireless/libertas_tf/libertas_tf.h
+++ b/drivers/net/wireless/libertas_tf/libertas_tf.h
@@ -253,6 +253,9 @@ struct lbtf_private {
 	u8 fw_ready;
 	u8 surpriseremoved;
 	struct sk_buff_head bc_ps_buf;
+
+	/* Most recently reported noise in dBm */
+	s8 noise;
 };
 
 /* 802.11-related definitions */
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 817fffc..9278b3c 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -525,6 +525,22 @@ static void lbtf_op_bss_info_changed(struct ieee80211_hw *hw,
 	lbtf_deb_leave(LBTF_DEB_MACOPS);
 }
 
+static int lbtf_op_get_survey(struct ieee80211_hw *hw, int idx,
+				struct survey_info *survey)
+{
+	struct lbtf_private *priv = hw->priv;
+	struct ieee80211_conf *conf = &hw->conf;
+
+	if (idx != 0)
+		return -ENOENT;
+
+	survey->channel = conf->channel;
+	survey->filled = SURVEY_INFO_NOISE_DBM;
+	survey->noise = priv->noise;
+
+	return 0;
+}
+
 static const struct ieee80211_ops lbtf_ops = {
 	.tx			= lbtf_op_tx,
 	.start			= lbtf_op_start,
@@ -535,6 +551,7 @@ static const struct ieee80211_ops lbtf_ops = {
 	.prepare_multicast	= lbtf_op_prepare_multicast,
 	.configure_filter	= lbtf_op_configure_filter,
 	.bss_info_changed	= lbtf_op_bss_info_changed,
+	.get_survey		= lbtf_op_get_survey,
 };
 
 int lbtf_rx(struct lbtf_private *priv, struct sk_buff *skb)
@@ -555,6 +572,7 @@ int lbtf_rx(struct lbtf_private *priv, struct sk_buff *skb)
 	stats.freq = priv->cur_freq;
 	stats.band = IEEE80211_BAND_2GHZ;
 	stats.signal = prxpd->snr;
+	priv->noise = prxpd->nf;
 	/* Marvell rate index has a hole at value 4 */
 	if (prxpd->rx_rate > 4)
 		--prxpd->rx_rate;
-- 
1.7.1.1

