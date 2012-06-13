Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:21742
	"EHLO HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152Ab2FMLPZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 07:15:25 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: [PATCH] cfg80211/nl80211: Fix for wireless-testing kernel crash
Date: Wed, 13 Jun 2012 11:15:18 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0A6BFE@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120613_131529_282753_B1210E41)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I saw wireless-testing kernel crash at nl80211 survey_dump function. we can see this crash only when run wpa_supplicant of hostap dev branch. This patch is fix for it.

Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
---
 net/wireless/nl80211.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7ae54b8..3554c53 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4515,6 +4515,8 @@ static int nl80211_dump_survey(struct sk_buff *skb,
 	while (1) {
 		struct ieee80211_channel *chan;
 
+		memset(&survey, 0, sizeof(struct survey_info));
+
 		res = dev->ops->dump_survey(&dev->wiphy, netdev, survey_idx,
 					    &survey);
 		if (res == -ENOENT)