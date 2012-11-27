Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:32784 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2K0SvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 13:51:14 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] nl80211: allow ad-hoc to set WMM parameters from outside
Date: Tue, 27 Nov 2012 19:50:31 +0100
Message-Id: <1354042232-32428-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121127_195119_273143_ADF798A9)
In-Reply-To: <1354042232-32428-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1354042232-32428-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It can be useful to set own WMM parameters from outside, otherwise there
is no way to change this in Ad-Hoc networks.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/wireless/nl80211.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c18b2fc..6d3567e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1549,7 +1549,8 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		}
 
 		if (netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-		    netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO) {
+		    netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO &&
+		    netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC) {
 			result = -EINVAL;
 			goto bad_res;
 		}
-- 
1.7.10.4

