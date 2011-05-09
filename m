Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51777 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab1EINlr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 09:41:47 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 06:41:18 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 3/4] ath9k: Fix rssi update in ad-hoc mode
Date: Mon, 9 May 2011 19:11:28 +0530
Message-ID: <1304948489-14585-3-git-send-email-rmanoharan@atheros.com> (sfid-20110509_154149_340534_FF46AF79)
In-Reply-To: <1304948489-14585-1-git-send-email-rmanoharan@atheros.com>
References: <1304948489-14585-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The average beacon rssi which will be used by ani is not updated
in adhoc mode.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index a485c04..9fcd1e4 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -917,7 +917,8 @@ static void ath9k_process_rssi(struct ath_common *common,
 	int last_rssi;
 	__le16 fc;
 
-	if (ah->opmode != NL80211_IFTYPE_STATION)
+	if ((ah->opmode != NL80211_IFTYPE_STATION) &&
+	    (ah->opmode != NL80211_IFTYPE_ADHOC))
 		return;
 
 	fc = hdr->frame_control;
-- 
1.7.5.1

