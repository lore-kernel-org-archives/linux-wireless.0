Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:50017 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735Ab3ACBcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 20:32:25 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.8] mwifiex: fix typo in setting up ibss network parameters
Date: Wed,  2 Jan 2013 17:32:19 -0800
Message-Id: <1357176739-29932-1-git-send-email-bzhao@marvell.com> (sfid-20130103_023234_456978_E5CCF49E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

commit 683b6d3... "cfg80211: pass a channel definition struct"
accidentally changed "==" to "!=".

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index c4edb28..a1f7fe0 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1710,7 +1710,7 @@ static int mwifiex_set_ibss_params(struct mwifiex_private *priv,
 						NL80211_CHAN_NO_HT)
 			config_bands |= BAND_GN;
 	} else {
-		if (cfg80211_get_chandef_type(&params->chandef) !=
+		if (cfg80211_get_chandef_type(&params->chandef) ==
 						NL80211_CHAN_NO_HT)
 			config_bands = BAND_A;
 		else
-- 
1.7.0.2

