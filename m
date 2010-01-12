Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58844 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab0ALMtU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:49:20 -0500
Date: Tue, 12 Jan 2010 13:49:18 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 11/17] mwl8k: allow selecting 5 GHz channels
Message-ID: <20100112124918.GA1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index e370245..6e8c126 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2222,6 +2222,8 @@ static int mwl8k_cmd_set_rf_channel(struct ieee80211_hw *hw,
 
 	if (channel->band == IEEE80211_BAND_2GHZ)
 		cmd->channel_flags |= cpu_to_le32(0x00000001);
+	else if (channel->band == IEEE80211_BAND_5GHZ)
+		cmd->channel_flags |= cpu_to_le32(0x00000004);
 
 	if (conf->channel_type == NL80211_CHAN_NO_HT ||
 	    conf->channel_type == NL80211_CHAN_HT20)
-- 
1.5.6.4
