Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:48806 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758598AbZACNoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 08:44:54 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Gabor Juhos <juhosg@openwrt.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: [RFC 11/12] ath9k: fix ar5416Addac_9100 values
Date: Sat,  3 Jan 2009 14:44:21 +0100
Message-Id: <1230990262-22923-12-git-send-email-juhosg@openwrt.org> (sfid-20090103_144508_135938_5356B415)
In-Reply-To: <1230990262-22923-1-git-send-email-juhosg@openwrt.org>
References: <1230990262-22923-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Writing the register at offset 0x98c4 causes a deadlock on the AR913x
SoCs. Although i don't have detailed knowledge about these registers, but if i
change the register offset according to the 'ar5416Addac' table, it
works. Additionally there is no reference to the 0x98c4 elsewhere.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/initvals.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/initvals.h b/drivers/net/wireless/ath9k/initvals.h
index f3cfa16..80a5d85 100644
--- a/drivers/net/wireless/ath9k/initvals.h
+++ b/drivers/net/wireless/ath9k/initvals.h
@@ -659,7 +659,7 @@ static const u32 ar5416Addac_9100[][2] = {
     {0x0000989c,  0x00000000 },
     {0x0000989c,  0x00000000 },
     {0x0000989c,  0x00000000 },
-    {0x000098c4,  0x00000000 },
+    {0x000098cc,  0x00000000 },
 };
 
 /* ar5416 - howl ar5416_howl.ini */
-- 
1.5.3.2

