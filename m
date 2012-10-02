Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab2JBTfU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2012 15:35:20 -0400
Date: Tue, 2 Oct 2012 21:34:23 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: check if key has TKIP type before updating IV
Message-ID: <20121002193422.GA12214@redhat.com> (sfid-20121002_213525_354313_6F7534A3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fix corruption which can manifest itself by following crash
when switching on rfkill switch with rt2x00 driver:
https://bugzilla.redhat.com/attachment.cgi?id=615362

Pointer key->u.ccmp.tfm of group key get corrupted in:

ieee80211_rx_h_michael_mic_verify():

        /* update IV in key information to be able to detect replays */
        rx->key->u.tkip.rx[rx->security_idx].iv32 = rx->tkip_iv32;
        rx->key->u.tkip.rx[rx->security_idx].iv16 = rx->tkip_iv16;

because rt2x00 always set RX_FLAG_MMIC_STRIPPED, even if key is not TKIP.

We already check type of the key in different path in
ieee80211_rx_h_michael_mic_verify() function, so adding additional
check here is reasonable.

Cc: stable@vger.kernel.org # 3.0+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/wpa.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index bdb53ab..e72562a 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -106,7 +106,8 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 		if (status->flag & RX_FLAG_MMIC_ERROR)
 			goto mic_fail;
 
-		if (!(status->flag & RX_FLAG_IV_STRIPPED) && rx->key)
+		if (!(status->flag & RX_FLAG_IV_STRIPPED) && rx->key &&
+		    rx->key->conf.cipher == WLAN_CIPHER_SUITE_TKIP)
 			goto update_iv;
 
 		return RX_CONTINUE;
-- 
1.7.1

