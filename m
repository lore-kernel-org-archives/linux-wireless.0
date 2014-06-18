Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:59695 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754029AbaFRRow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2014 13:44:52 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
	"John W. Linville" <linville@tuxdriver.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] SPECTRUM_CS: ioport_map/unmap relies on HAS_IOPORT_MAP
Date: Wed, 18 Jun 2014 19:43:31 +0200
Message-Id: <1403113411-7542-1-git-send-email-fabf@skynet.be> (sfid-20140618_194520_282934_ADFAC4A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixing following sh-allmodconfig errors reported on kisskb

"
drivers/net/wireless/orinoco/spectrum_cs.c:216:2: error: implicit declaration of function 'ioport_map' [-Werror=implicit-function-declaration]
drivers/net/wireless/orinoco/spectrum_cs.c:273:3: error: implicit declaration of function 'ioport_unmap' [-Werror=implicit-function-declaration]
"

Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
This is untested

 drivers/net/wireless/orinoco/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/orinoco/Kconfig b/drivers/net/wireless/orinoco/Kconfig
index 60819bc..a8aab9f 100644
--- a/drivers/net/wireless/orinoco/Kconfig
+++ b/drivers/net/wireless/orinoco/Kconfig
@@ -122,7 +122,7 @@ config PCMCIA_HERMES
 
 config PCMCIA_SPECTRUM
 	tristate "Symbol Spectrum24 Trilogy PCMCIA card support"
-	depends on PCMCIA && HERMES
+	depends on PCMCIA && HERMES && HAS_IOPORT_MAP
 	---help---
 
 	  This is a driver for 802.11b cards using RAM-loadable Symbol
-- 
1.8.4.5

