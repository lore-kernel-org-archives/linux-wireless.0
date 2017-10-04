Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33326 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752015AbdJDMKB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 08:10:01 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Rohit Fule <rohitf@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: double the size of chan_stats array in adapter
Date: Wed, 4 Oct 2017 17:36:06 +0530
Message-ID: <1507118766-17713-1-git-send-email-gbhat@marvell.com> (sfid-20171004_141005_488965_F306EB40)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rohit Fule <rohitf@marvell.com>

When a user requests scan, driver sends multiple scan requests
to firmware, which might be active or passive. Firmware will
send channel statistics for each channel in the request. This will
be stored in chan_stats array.

Few channels might report hidden SSIDs in passive scan results.
So, once the original scan request is finished, driver issues an
active scan request for all channels which reported hidden SSIDs.
This will cause duplicates in the chan_stats array. At worst,
every channel will have a hidden SSID, in which case the driver
can issue active scan requests for each channel. So the complete
scan statistics size will be twice of existing limit.

At present maximum number of channels returned in scan statistics
is 31(BG) + 14(A) = 45. Clearly there will be an overflow of the
chan_stats array in the above mentioned scenario. To fix this
double the size of chan_stats array.

Signed-off-by: Rohit Fule <rohitf@marvell.com>
Signed-off-by: Mangesh Malusare <mmangesh@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index ac01af4..f33ed79 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4201,7 +4201,10 @@ int mwifiex_init_channel_scan_gap(struct mwifiex_adapter *adapter)
 	if (adapter->config_bands & BAND_A)
 		n_channels_a = mwifiex_band_5ghz.n_channels;
 
-	adapter->num_in_chan_stats = n_channels_bg + n_channels_a;
+	/* allocate twice the number total channels, since the driver issues an
+	 * additional active scan request for hidden SSIDs on passive channels.
+	 */
+	adapter->num_in_chan_stats = 2 * (n_channels_bg + n_channels_a);
 	adapter->chan_stats = vmalloc(sizeof(*adapter->chan_stats) *
 				      adapter->num_in_chan_stats);
 
-- 
1.9.1
