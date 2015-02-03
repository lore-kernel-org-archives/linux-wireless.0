Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:64100 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbbBCVVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 16:21:24 -0500
Received: by mail-la0-f46.google.com with SMTP id s18so54870919lam.5
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2015 13:21:23 -0800 (PST)
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] ath5k: fix spontaneus AR5312 freezes
Date: Wed,  4 Feb 2015 00:21:13 +0300
Message-Id: <1422998473-3709-1-git-send-email-ryazanov.s.a@gmail.com> (sfid-20150203_222128_649572_3A9D8C31)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes while CPU have some load and ath5k doing the wireless
interface reset the whole WiSoC completely freezes. Set of tests shows
that using atomic delay function while we wait interface reset helps to
avoid such freezes.

The easiest way to reproduce this issue: create a station interface,
start continous scan with wpa_supplicant and load CPU by something. Or
just create multiple station interfaces and put them all in continous
scan.

This patch partially reverts the commit 1846ac3dbec0 ("ath5k: Use
usleep_range where possible"), which replaces initial udelay()
by usleep_range().

I do not know actual source of this issue, but all looks like that HW
freeze is caused by transaction on internal SoC bus, while wireless
block is in reset state.

Also I should note that I do not know how many chips are affected, but I
did not see this issue with chips, other than AR5312.

CC: Jiri Slaby <jirislaby@gmail.com>
CC: Nick Kossifidis <mickflemm@gmail.com>
CC: Luis R. Rodriguez <mcgrof@do-not-panic.com>
Fixes: 1846ac3dbec0 ("ath5k: Use usleep_range where possible")
Reported-by: Christophe Prevotaux <c.prevotaux@rural-networks.com>
Tested-by: Christophe Prevotaux <c.prevotaux@rural-networks.com>
Tested-by: Eric Bree <ebree@nltinc.com>
Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
I would like to sincerely thank Christophe for provided board and
for his patience and perseverance in solving problems with the
delivery ;)
---
 drivers/net/wireless/ath/ath5k/reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index a3399c4..b9b651e 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -478,7 +478,7 @@ ath5k_hw_wisoc_reset(struct ath5k_hw *ah, u32 flags)
 	regval = ioread32(reg);
 	iowrite32(regval | val, reg);
 	regval = ioread32(reg);
-	usleep_range(100, 150);
+	udelay(100);	/* NB: should be atomic */
 
 	/* Bring BB/MAC out of reset */
 	iowrite32(regval & ~val, reg);
-- 
2.0.4

