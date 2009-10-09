Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:36029 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbZJIOOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 10:14:44 -0400
From: Miguel Boton <waninkoko@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] b43: add 'struct b43_wl' missing declaration
Date: Fri, 9 Oct 2009 16:13:53 +0200
Cc: linux-kernel@vger.kernel.org, mb@bu3sch.de, linville@tuxdriver.com,
	bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200910091613.53960.mboton@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'struct b43_wl' declaration is missing at 'leds.h'.
It should be declared to avoid getting some GCC warnings at 'b43_leds_unregister'.

Signed-off-by: Miguel Botón <mboton@gmail.com>

---

 drivers/net/wireless/b43/leds.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/leds.h b/drivers/net/wireless/b43/leds.h
index 4c56187..32b66d5 100644
--- a/drivers/net/wireless/b43/leds.h
+++ b/drivers/net/wireless/b43/leds.h
@@ -1,6 +1,7 @@
 #ifndef B43_LEDS_H_
 #define B43_LEDS_H_
 
+struct b43_wl;
 struct b43_wldev;
 
 #ifdef CONFIG_B43_LEDS
