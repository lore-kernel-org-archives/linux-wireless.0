Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44971 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbZA2EH6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 23:07:58 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 20:07:58 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18817.10950.81886.193681@gargle.gargle.HOWL> (sfid-20090129_050803_625361_D890EFEC)
Date: Thu, 29 Jan 2009 09:34:22 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<Jouni.Malinen@Atheros.com>
Subject: [PATCH] mac80211: Reset assoc_scan_tries after an unsuccessful scan run
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trying to associate with a non-existent SSID stops the
state machine after the first run. Subsequent association
requests fail to start the scan engine. Fix this by resetting
assoc_scan_tries to zero after completing a scan run.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 net/mac80211/mlme.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9d51e27..a8755df 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2415,8 +2415,10 @@ static int ieee80211_sta_config_auth(struct ieee80211_sub_if_data *sdata,
 							 ifsta->ssid_len);
 			ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
 			set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
-		} else
+		} else {
+			ifsta->assoc_scan_tries = 0;
 			ifsta->state = IEEE80211_STA_MLME_DISABLED;
+		}
 	}
 	return -1;
 }
-- 
1.6.1

