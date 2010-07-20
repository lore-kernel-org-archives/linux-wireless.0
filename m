Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34226 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab0GTQPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 12:15:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: correct sparse warning in lib80211_crypt_tkip.c
Date: Tue, 20 Jul 2010 12:11:33 -0400
Message-Id: <1279642293-8781-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   net/wireless/lib80211_crypt_tkip.c
net/wireless/lib80211_crypt_tkip.c:581:27: warning: cast to restricted __le16

Caused by dereferencing a "u8 *" and passing it to le16_to_cpu...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/lib80211_crypt_tkip.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index 8cbdb32..a7f9956 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -578,7 +578,7 @@ static void michael_mic_hdr(struct sk_buff *skb, u8 * hdr)
 	}
 
 	if (ieee80211_is_data_qos(hdr11->frame_control)) {
-		hdr[12] = le16_to_cpu(*ieee80211_get_qos_ctl(hdr11))
+		hdr[12] = le16_to_cpu(*((__le16 *)ieee80211_get_qos_ctl(hdr11)))
 			& IEEE80211_QOS_CTL_TID_MASK;
 	} else
 		hdr[12] = 0;		/* priority */
-- 
1.7.1.1

