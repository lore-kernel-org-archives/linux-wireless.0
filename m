Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:54633 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaFLU2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 16:28:55 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH][3.16 FIX][STABLE] b43: fix frequency reported on G-PHY with /new/ firmware
Date: Thu, 12 Jun 2014 22:28:22 +0200
Message-Id: <1402604902-7801-1-git-send-email-zajec5@gmail.com> (sfid-20140612_222859_205744_3E1AA0FD)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support for firmware rev 508+ was added years ago, but we never noticed
it reports channel in a different way for G-PHY devices. Instead of
offset from 2400 MHz it simply passes channel id (AKA hw_value).

So far it was (most probably) affecting monitor mode users only, but
the following recent commit made it noticeable for quite everybody:

commit 3afc2167f60a327a2c1e1e2600ef209a3c2b75b7
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Tue Mar 4 16:50:13 2014 +0200

    cfg80211/mac80211: ignore signal if the frame was heard on wrong channel

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Cc: stable@vger.kernel.org
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/net/wireless/b43/xmit.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 4f38f19..6e6ef3f 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -811,9 +811,13 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 		break;
 	case B43_PHYTYPE_G:
 		status.band = IEEE80211_BAND_2GHZ;
-		/* chanid is the radio channel cookie value as used
-		 * to tune the radio. */
-		status.freq = chanid + 2400;
+		/* Somewhere between 478.104 and 508.1084 firmware for G-PHY
+		 * has been modified to be compatible with N-PHY and others.
+		 */
+		if (dev->fw.rev >= 508)
+			status.freq = ieee80211_channel_to_frequency(chanid, status.band);
+		else
+			status.freq = chanid + 2400;
 		break;
 	case B43_PHYTYPE_N:
 	case B43_PHYTYPE_LP:
-- 
1.8.4.5

