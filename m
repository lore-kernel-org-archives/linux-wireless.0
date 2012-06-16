Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:28007 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab2FPRIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 13:08:14 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <ordex@autistici.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: remove useless DA checking in ieee80211_rx_mgmt_probe_resp()
Date: Sat, 16 Jun 2012 18:50:02 +0200
Message-Id: <1339865405-10787-2-git-send-email-ordex@autistici.org> (sfid-20120616_190853_520256_FE82992E)
In-Reply-To: <1339865405-10787-1-git-send-email-ordex@autistici.org>
References: <1339865405-10787-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Actually the DA field has already been checked along the rx path (in
prepare_for_handlers()) and this check is therefore useless at this point.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ibss.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 4345e94..b253d0a 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -853,9 +853,6 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 	size_t baselen;
 	struct ieee802_11_elems elems;
 
-	if (memcmp(mgmt->da, sdata->vif.addr, ETH_ALEN))
-		return; /* ignore ProbeResp to foreign address */
-
 	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
 	if (baselen > len)
 		return;
-- 
1.7.9.4

