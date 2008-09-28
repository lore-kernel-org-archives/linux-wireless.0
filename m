Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:60394 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbYI1WYo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 18:24:44 -0400
Date: Mon, 29 Sep 2008 01:24:44 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Subject: [PATCH 4/5] ath5k: Fix SREV reporting after SREV updates
Message-ID: <20080928222444.GD21335@makis> (sfid-20080929_002448_080290_AED61395)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Fix srev reporting during attach

 Changes-Licensed-under: ISC
 Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath5k/base.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index c8bb9bf..905076a 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -396,7 +396,11 @@ ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val)
 	for (i = 0; i < ARRAY_SIZE(srev_names); i++) {
 		if (srev_names[i].sr_type != type)
 			continue;
-		if ((val & 0xff) < srev_names[i + 1].sr_val) {
+
+		if ((val & 0xf0) == srev_names[i].sr_val)
+			name = srev_names[i].sr_name;
+
+		if ((val & 0xff) == srev_names[i].sr_val) {
 			name = srev_names[i].sr_name;
 			break;
 		}
