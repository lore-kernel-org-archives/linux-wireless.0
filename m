Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:34119 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbdF3B0G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 21:26:06 -0400
Received: by mail-pf0-f175.google.com with SMTP id s66so58765308pfs.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jun 2017 18:26:05 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org, Avinash Patil <patila@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH] mwifiex: correct channel stat buffer overflows
Date: Thu, 29 Jun 2017 18:23:54 -0700
Message-Id: <20170630012354.98931-1-briannorris@chromium.org> (sfid-20170630_032646_790050_40E7039D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mwifiex records information about various channels as it receives scan
information. It does this by appending to a buffer that was sized
to the max number of supported channels on any band, but there are
numerous problems:

(a) scans can return info from more than one band (e.g., both 2.4 and 5
    GHz), so the determined "max" is not large enough
(b) some firmware appears to return multiple results for a given
    channel, so the max *really* isn't large enough
(c) there is no bounds checking when stashing these stats, so problems
    (a) and (b) can easily lead to buffer overflows

Let's patch this by setting a slightly-more-correct max (that accounts
for a combination of both 2.4G and 5G bands) and adding a bounds check
when writing to our statistics buffer.

Due to problem (b), we still might not properly report all known survey
information (e.g., with "iw <dev> survey dump"), since duplicate results
(or otherwise "larger than expected" results) will cause some
truncation. But that's a problem for a future bugfix.

(And because of this known deficiency, only log the excess at the WARN
level, since that isn't visible by default in this driver and would
otherwise be a bit too noisy.)

Fixes: bf35443314ac ("mwifiex: channel statistics support for mwifiex")
Cc: <stable@vger.kernel.org>
Cc: Avinash Patil <patila@marvell.com>
Cc: Xinming Hu <huxm@marvell.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
I've got a ton of other patches still queued up locally, and I hope to send
them soon. But I realized this one is a nasty bug (with a trivial fix), so it's
probably best to get this out the door quickly.

 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 +-
 drivers/net/wireless/marvell/mwifiex/scan.c     | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index a850ec0054e2..82f4e796ed39 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4219,7 +4219,7 @@ int mwifiex_init_channel_scan_gap(struct mwifiex_adapter *adapter)
 	if (adapter->config_bands & BAND_A)
 		n_channels_a = mwifiex_band_5ghz.n_channels;
 
-	adapter->num_in_chan_stats = max_t(u32, n_channels_bg, n_channels_a);
+	adapter->num_in_chan_stats = n_channels_bg + n_channels_a;
 	adapter->chan_stats = vmalloc(sizeof(*adapter->chan_stats) *
 				      adapter->num_in_chan_stats);
 
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index ae9630b49342..9900855746ac 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -2492,6 +2492,12 @@ mwifiex_update_chan_statistics(struct mwifiex_private *priv,
 					      sizeof(struct mwifiex_chan_stats);
 
 	for (i = 0 ; i < num_chan; i++) {
+		if (adapter->survey_idx >= adapter->num_in_chan_stats) {
+			mwifiex_dbg(adapter, WARN,
+				    "FW reported too many channel results (max %d)\n",
+				    adapter->num_in_chan_stats);
+			return;
+		}
 		chan_stats.chan_num = fw_chan_stats->chan_num;
 		chan_stats.bandcfg = fw_chan_stats->bandcfg;
 		chan_stats.flags = fw_chan_stats->flags;
-- 
2.13.2.725.g09c95d1e9-goog
