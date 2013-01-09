Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:58311 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756217Ab3AIB5C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 20:57:02 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.8] mwifiex: correct config_bands handling for ibss network
Date: Tue,  8 Jan 2013 17:53:11 -0800
Message-Id: <1357696391-9396-2-git-send-email-bzhao@marvell.com> (sfid-20130109_025707_557258_49E22DB9)
In-Reply-To: <1357696391-9396-1-git-send-email-bzhao@marvell.com>
References: <1357696391-9396-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

BAND_G is implicit when BAND_GN is present.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index b4dbe22..9eab21d 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1695,7 +1695,7 @@ static int mwifiex_set_ibss_params(struct mwifiex_private *priv,
 
 		if (cfg80211_get_chandef_type(&params->chandef) !=
 						NL80211_CHAN_NO_HT)
-			config_bands |= BAND_GN;
+			config_bands |= BAND_G | BAND_GN;
 	} else {
 		if (cfg80211_get_chandef_type(&params->chandef) ==
 						NL80211_CHAN_NO_HT)
-- 
1.7.0.2

