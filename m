Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:41756 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2LVOwQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 09:52:16 -0500
Received: by mail-we0-f175.google.com with SMTP id z53so2643138wey.6
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2012 06:52:15 -0800 (PST)
Message-Id: <9ae8ebc3aa563de0978320035906f5d0358a1404.1356186145.git.chunkeey@googlemail.com> (sfid-20121222_155220_319692_B85A7C3A)
In-Reply-To: <8f92b38a456c1dd901ce2022fcb66609a5b8ac4b.1356186145.git.chunkeey@googlemail.com>
References: <8f92b38a456c1dd901ce2022fcb66609a5b8ac4b.1356186145.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 17 Dec 2012 17:05:55 +0100
Subject: [PATCH 6/8] carl9170: disable hw crypto for p2p networks
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While the driver supports HW offload in a single
P2P client configuration, it doesn't support HW
offload in the concurrent P2P GO+CLIENT
configuration.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/main.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index c1a272d..79888c9 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -583,6 +583,14 @@ static int carl9170_init_interface(struct ar9170 *ar,
 	ar->disable_offload |= ((vif->type != NL80211_IFTYPE_STATION) &&
 	    (vif->type != NL80211_IFTYPE_AP));
 
+	/* While the driver supports HW offload in a single
+	 * P2P client configuration, it doesn't support HW
+	 * offload in the favourit, concurrent P2P GO+CLIENT
+	 * configuration. Hence, HW offload will always be
+	 * disabled for P2P.
+	 */
+	ar->disable_offload |= vif->p2p;
+
 	ar->rx_software_decryption = ar->disable_offload;
 
 	err = carl9170_set_operating_mode(ar);
-- 
1.7.10.4

