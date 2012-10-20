Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:55888 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757023Ab2JTCUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 22:20:22 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 5/7] Revert "mwifiex: retrieve correct max_power information in reg_notifier handler"
Date: Fri, 19 Oct 2012 19:19:19 -0700
Message-Id: <1350699561-852-6-git-send-email-bzhao@marvell.com> (sfid-20121020_042028_448693_7D8A2596)
In-Reply-To: <1350699561-852-1-git-send-email-bzhao@marvell.com>
References: <1350699561-852-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This reverts commit 34202e28fe7fc8551313f9a035a8857db83de757

We made "34202ee.." because we didn't support custom regulatory rules
at that time. But now we use our own custom regulatory rules, so it
needs to be changed back.

Also, chan->max_power calculations in cfg80211 were broken. Hence we
started using chan->max_reg_power. Now it has got fixed in
following commit.

commit 5e31fc0815a4e2c72b1b495fe7a0d8f9bfb9e4b4
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Tue Jul 24 08:35:39 2012 +0200

    wireless: reg: restore previous behaviour of chan->max_power calculations

Hence we will use chan->max_power instead of chan->max_reg_power.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 4faef1c..fdb1eb8 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -471,13 +471,13 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 			flag = 1;
 			first_chan = (u32) ch->hw_value;
 			next_chan = first_chan;
-			max_pwr = ch->max_reg_power;
+			max_pwr = ch->max_power;
 			no_of_parsed_chan = 1;
 			continue;
 		}
 
 		if (ch->hw_value == next_chan + 1 &&
-		    ch->max_reg_power == max_pwr) {
+		    ch->max_power == max_pwr) {
 			next_chan++;
 			no_of_parsed_chan++;
 		} else {
@@ -488,7 +488,7 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 			no_of_triplet++;
 			first_chan = (u32) ch->hw_value;
 			next_chan = first_chan;
-			max_pwr = ch->max_reg_power;
+			max_pwr = ch->max_power;
 			no_of_parsed_chan = 1;
 		}
 	}
-- 
1.7.0.2

