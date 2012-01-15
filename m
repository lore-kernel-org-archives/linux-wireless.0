Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:52548 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751297Ab2AOIjw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jan 2012 03:39:52 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 4/8] brcmfmac: Remove useless #ifdef DEBUG
Date: Sun, 15 Jan 2012 00:38:41 -0800
Message-Id: <4697932e92a7b100a896e9d9f1d9616ecbec5b94.1326616556.git.joe@perches.com> (sfid-20120115_094144_980575_35AABF1B)
In-Reply-To: <cover.1326616556.git.joe@perches.com>
References: <cover.1326616556.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This doesn't do anything anymore.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 4ab1023..79230e7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2039,13 +2039,11 @@ deliver:
 		down(&bus->sdsem);
 	}
 	rxcount = maxframes - rxleft;
-#ifdef DEBUG
 	/* Message if we hit the limit */
 	if (!rxleft)
 		brcmf_dbg(DATA, "hit rx limit of %d frames\n",
 			  maxframes);
 	else
-#endif				/* DEBUG */
 		brcmf_dbg(DATA, "processed %d frames\n", rxcount);
 	/* Back off rxseq if awaiting rtx, update rx_seq */
 	if (bus->rxskip)
-- 
1.7.8.111.gad25c.dirty

