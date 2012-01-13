Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:29339 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab2AMMyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 07:54:05 -0500
From: Antonio Quartulli <ordex@autistici.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH] mac80211: remove useless DA checking in ieee80211_rx_mgmt_probe_resp()
Date: Fri, 13 Jan 2012 13:53:18 +0100
Message-Id: <1326459198-8413-1-git-send-email-ordex@autistici.org> (sfid-20120113_135409_723854_8F7885A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Actually the DA field has already been checked along the rx path (in
prepare_for_handlers()) and this check is therefore useless at this point.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 net/mac80211/ibss.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index f8a32bf..6aacce9 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -854,9 +854,6 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 	size_t baselen;
 	struct ieee802_11_elems elems;
 
-	if (memcmp(mgmt->da, sdata->vif.addr, ETH_ALEN))
-		return; /* ignore ProbeResp to foreign address */
-
 	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
 	if (baselen > len)
 		return;
-- 
1.7.3.4

