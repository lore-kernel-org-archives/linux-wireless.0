Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20132 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYLTFzw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 00:55:52 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 21:55:52 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 10/16] ath9k: make use of conf_is_ht40() in the rest of the driver
Date: Fri, 19 Dec 2008 21:55:16 -0800
Message-ID: <1229752522-1917-11-git-send-email-lrodriguez@atheros.com> (sfid-20081220_065609_442238_73EC74E1)
In-Reply-To: <1229752522-1917-10-git-send-email-lrodriguez@atheros.com>
References: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-2-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-3-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-4-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-5-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-6-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-7-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-8-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-9-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-10-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use shiny new conf_is_ht40()

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 54c6d60..1385343 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2126,8 +2126,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			CHANNEL_G : CHANNEL_A;
 
 		if (conf->ht.enabled) {
-			if (conf->ht.channel_type == NL80211_CHAN_HT40PLUS ||
-			    conf->ht.channel_type == NL80211_CHAN_HT40MINUS)
+			if (conf_is_ht40(conf))
 				sc->tx_chan_width = ATH9K_HT_MACMODE_2040;
 
 			priv_channel->chanmode =
-- 
1.5.6.rc2.15.g457bb.dirty

