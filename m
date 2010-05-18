Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay11.uol.com.br ([200.147.1.1]:50771 "EHLO
	relay11.uol.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0ERDQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 23:16:56 -0400
Received: from smtp.uol.com.br (unknown [172.26.20.60])
	by a1-sete4.uol.com.br (Postfix) with ESMTP id 4F79890000A15
	for <linux-wireless@vger.kernel.org>; Tue, 18 May 2010 00:16:54 -0300 (BRT)
Received: from localhost (localhost [127.0.0.1])
	by socom2.uol.com.br (Postfix) with ESMTP id E4529EB4
	for <linux-wireless@vger.kernel.org>; Tue, 18 May 2010 00:15:19 -0300 (BRT)
Received: from chagas.nectar.ath.cx (unknown [187.22.165.163])
	(Authenticated sender: rogerbrito@uol.com.br)
	by socom2.uol.com.br (Postfix) with ESMTPA id D6AC8CE1
	for <linux-wireless@vger.kernel.org>; Tue, 18 May 2010 00:14:56 -0300 (BRT)
Date: Tue, 18 May 2010 00:14:36 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Select WIRELESS_EXT for the rndis_wlan driver to compile
Message-ID: <20100518031436.GA6006@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rndis_wlan.ko module needs the function wireless_send_event, which
is not included if the option WIRELESS_EXT is not selected by the
driver.  Otherwise, the user gets compilation problems like:

,----
| (...)
| Kernel: arch/x86/boot/bzImage is ready  (#3)
|   Building modules, stage 2.
|   MODPOST 427 modules
| ERROR: "wireless_send_event" [drivers/net/wireless/rndis_wlan.ko] undefined!
| make[1]: *** [__modpost] Error 1
| make: *** [modules] Error 2
`----
---

I don't know if this is a proper fix, but I would love to know a better
solution to the problem.

 drivers/net/wireless/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 5889436..0d5fff4 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -186,6 +186,7 @@ config USB_NET_RNDIS_WLAN
 	tristate "Wireless RNDIS USB support"
 	depends on USB && EXPERIMENTAL
 	depends on CFG80211
+	select WIRELESS_EXT
 	select USB_USBNET
 	select USB_NET_CDCETHER
 	select USB_NET_RNDIS_HOST
-- 
1.7.1

