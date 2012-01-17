Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:60794 "HELO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752767Ab2AQKXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 05:23:51 -0500
Date: Tue, 17 Jan 2012 15:45:15 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH] mwl8k: Fixing Sparse ENDIAN CHECK warning
Message-ID: <20120117101507.GA7499@hertz.marvell.com> (sfid-20120117_112354_637875_7EDADEF7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixing following sparse warning
>drivers/net/wireless/mwl8k.c:2780:15: warning: incorrect type in assignment (different base types)
>drivers/net/wireless/mwl8k.c:2780:15:    expected restricted unsigned short [usertype] channel
>drivers/net/wireless/mwl8k.c:2780:15:    got unsigned short [unsigned] [usertype] hw_value

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 8ea7012..008f406 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2777,7 +2777,7 @@ static int mwl8k_cmd_tx_power(struct ieee80211_hw *hw,
 	else if (channel->band == IEEE80211_BAND_5GHZ)
 		cmd->band = cpu_to_le16(0x4);
 
-	cmd->channel = channel->hw_value;
+	cmd->channel = cpu_to_le16(channel->hw_value);
 
 	if (conf->channel_type == NL80211_CHAN_NO_HT ||
 	    conf->channel_type == NL80211_CHAN_HT20) {
-- 
1.7.5.4

