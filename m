Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51350 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab2APTQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 14:16:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] brcmfmac: work-around gcc 4.7 build issue
Date: Mon, 16 Jan 2012 14:00:12 -0500
Message-Id: <1326740412-24010-1-git-send-email-linville@tuxdriver.com> (sfid-20120116_201625_396020_73DA02F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>

Alexandre Oliva <oliva@lsd.ic.unicamp.br> says:

"It's an issue brought about by GCC 4.7's partial-inlining, that ends up
splitting the udelay function just at the wrong spot, in such a way that
some sanity checks for constants fails, and we end up calling
bad_udelay.

This patch fixes the problem.  Feel free to push it upstream if it makes
sense to you."

Signed-off-by: John W. Linville <linville@tuxdriver.com.
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index f23b0c3..bf11850 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2475,7 +2475,7 @@ static s32 brcmf_init_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 	return err;
 }
 
-static void brcmf_delay(u32 ms)
+static __always_inline void brcmf_delay(u32 ms)
 {
 	if (ms < 1000 / HZ) {
 		cond_resched();
-- 
1.7.4.4

