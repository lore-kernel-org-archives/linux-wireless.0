Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:42830 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab3A1QMa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:12:30 -0500
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	ordex@autistici.org, simon.wunderlich@s2003.tu-chemnitz.de,
	rgibson@futurec.net, Sven Eckelmann <sven@narfation.org>
Subject: [RFC 1/3] mac80211: Allow group key for IBSS WPA_NONE
Date: Mon, 28 Jan 2013 17:11:51 +0100
Message-Id: <1359389513-1554-1-git-send-email-sven@narfation.org> (sfid-20130128_171234_341170_65C398EB)
In-Reply-To: <30210911.93HAZKKtRJ@bentobox>
References: <30210911.93HAZKKtRJ@bentobox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WPA_NONE uses the shared group key to encrypt the protected frames. Therefore,
it must also be allowed for non-multicast frames to use the group key for
decryption.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/mac80211/rx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a190895..d412fd0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1160,7 +1160,9 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 			if (rx->key &&
 			    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP40 &&
 			    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP104 &&
-			    !is_multicast_ether_addr(hdr->addr1))
+			    !is_multicast_ether_addr(hdr->addr1) &&
+			    (rx->sdata->vif.type != NL80211_IFTYPE_ADHOC ||
+			     rx->sdata->u.ibss.control_port))
 				rx->key = NULL;
 		}
 	}
-- 
1.7.10.4

