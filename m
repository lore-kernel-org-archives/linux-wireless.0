Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:53570 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZCBPAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 10:00:33 -0500
Received: by yw-out-2324.google.com with SMTP id 5so1513742ywh.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 07:00:31 -0800 (PST)
Date: Mon, 2 Mar 2009 20:20:30 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Always send a null data frame if TIM bit is set.
Message-ID: <20090302145030.GA4660@myhost.users.atheros.com> (sfid-20090302_160037_965711_012AD318)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the AP thinks we are in power save state eventhough we are not truly
in that state, it sets the TIM bit and does not send a data frame unless
we send a null data frame to correct the state in the AP.
This might happen if the null data frame for wake up is lost in the air
after we disable power save.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/mlme.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7f23858..ac10b21 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1457,8 +1457,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	ieee80211_sta_wmm_params(local, ifmgd, elems.wmm_param,
 				 elems.wmm_param_len);
 
-	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK &&
-	    local->hw.conf.flags & IEEE80211_CONF_PS) {
+	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
 		directed_tim = ieee80211_check_tim(&elems, ifmgd->aid);
 
 		if (directed_tim) {
-- 
1.6.0.1

