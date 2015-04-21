Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39530 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbbDUNc1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2015 09:32:27 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [RFC] mac80211: clear radar_required while setting up sdata
Date: Tue, 21 Apr 2015 19:02:05 +0530
Message-ID: <1429623125-9484-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150421_153231_310946_A19709F6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "mac80211: don't defer scans in case of radar detection"
drops scan requests when interface is running on radar channel.
Once the AP interface is brought up on DFS channel,
sdata->radar_required never be cleared on deinit path unless the
interface is deleted. This is causing failures while restarting hostapd.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 net/mac80211/iface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index b4ac596..c764eb0 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1341,6 +1341,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	sdata->control_port_no_encrypt = false;
 	sdata->encrypt_headroom = IEEE80211_ENCRYPT_HEADROOM;
 	sdata->vif.bss_conf.idle = true;
+	sdata->radar_required = false;
 
 	sdata->noack_map = 0;
 
-- 
2.3.5

