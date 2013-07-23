Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:34744 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753966Ab3GWCTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:19:02 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 21/21] mwifiex: modify mwifiex_ap_sta_limits to advertise support for P2P
Date: Mon, 22 Jul 2013 19:17:58 -0700
Message-ID: <1374545878-15683-22-git-send-email-bzhao@marvell.com> (sfid-20130723_041908_925506_1493DC08)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

We support maximum simultaneous 2 non-AP station interfaces and
they can assume role of Station/P2P client/P2P GO.
Advertise this support to cfg80211 so that concurrent P2P/STA
operation is possible.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index dbdd3b2..cc334d5 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -25,7 +25,9 @@ module_param(reg_alpha2, charp, 0);
 
 static const struct ieee80211_iface_limit mwifiex_ap_sta_limits[] = {
 	{
-		.max = 2, .types = BIT(NL80211_IFTYPE_STATION),
+		.max = 2, .types = BIT(NL80211_IFTYPE_STATION) |
+				   BIT(NL80211_IFTYPE_P2P_GO) |
+				   BIT(NL80211_IFTYPE_P2P_CLIENT),
 	},
 	{
 		.max = 1, .types = BIT(NL80211_IFTYPE_AP),
-- 
1.8.2.3

