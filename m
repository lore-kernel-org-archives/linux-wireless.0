Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45105 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab0ECUPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 16:15:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: chunkeey@googlemail.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] p54: Added get_survey callback in order to get channel noise
Date: Mon,  3 May 2010 16:06:47 -0400
Message-Id: <1272917207-12077-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
The code seems correct, but the value reported seems to swing between
127 dBm and -1 dBm?

 drivers/net/wireless/p54/main.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 10a4b16..3da46ef 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -506,6 +506,22 @@ out_unlock:
 	return ret;
 }
 
+static int p54_get_survey(struct ieee80211_hw *dev, int idx,
+				struct survey_info *survey)
+{
+	struct p54_common *priv = dev->priv;
+	struct ieee80211_conf *conf = &dev->conf;
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
 static const struct ieee80211_ops p54_ops = {
 	.tx			= p54_tx_80211,
 	.start			= p54_start,
@@ -522,6 +538,7 @@ static const struct ieee80211_ops p54_ops = {
 	.configure_filter	= p54_configure_filter,
 	.conf_tx		= p54_conf_tx,
 	.get_stats		= p54_get_stats,
+	.get_survey		= p54_get_survey,
 };
 
 struct ieee80211_hw *p54_init_common(size_t priv_data_len)
-- 
1.6.6.1

