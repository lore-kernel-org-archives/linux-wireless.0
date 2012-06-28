Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:56025 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758003Ab2F1C71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 22:59:27 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/4] mwifiex: retrieve correct max_power information in reg_notifier handler
Date: Wed, 27 Jun 2012 19:57:59 -0700
Message-Id: <1340852279-24964-5-git-send-email-bzhao@marvell.com> (sfid-20120628_045932_997842_2C6435FB)
In-Reply-To: <1340852279-24964-1-git-send-email-bzhao@marvell.com>
References: <1340852279-24964-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

As we don't provide custom regulatory rules to cfg80211,
"chan->max_power" remains uninitialized (0dbm) and
"chan->max_reg_power" will contain maximum power for a channel
extracted from regulatory rules provided by CRDA; hence use
"chan->max_reg_power" in reg_notifier handler instead of
"chan->max_power" to set max_power in firmware.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 78fb959..e241f8d 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -260,13 +260,13 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 			flag = 1;
 			first_chan = (u32) ch->hw_value;
 			next_chan = first_chan;
-			max_pwr = ch->max_power;
+			max_pwr = ch->max_reg_power;
 			no_of_parsed_chan = 1;
 			continue;
 		}
 
 		if (ch->hw_value == next_chan + 1 &&
-		    ch->max_power == max_pwr) {
+		    ch->max_reg_power == max_pwr) {
 			next_chan++;
 			no_of_parsed_chan++;
 		} else {
@@ -277,7 +277,7 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 			no_of_triplet++;
 			first_chan = (u32) ch->hw_value;
 			next_chan = first_chan;
-			max_pwr = ch->max_power;
+			max_pwr = ch->max_reg_power;
 			no_of_parsed_chan = 1;
 		}
 	}
-- 
1.7.0.2

