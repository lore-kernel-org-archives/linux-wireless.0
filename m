Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from csmtp2.one.com ([91.198.169.22]:21986 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756392Ab1KIW57 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 17:57:59 -0500
Date: Wed, 9 Nov 2011 23:57:57 +0100
From: Daniel Kuehn <daniel@kuehn.se>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH] Seeing as alot of ath9k devices is PCI/PCIe or their mini
 equivalent it makes sense to set ATH9K_PCI to y by default
Message-ID: <20111109235757.79821a20@Artemis> (sfid-20111109_235802_568736_0DCE88C7)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

from: Daniel Kuehn <daniel@kuehn.se>

Most ath9k devices are PCI/PCIe based, therefor making PCI/PCIe support
default y helps those porting a config from 2.6 kernel series
from getting "non-functional" wireless drivers with 3.x kernel series.

Signed-off-by: Daniel Kuehn <daniel@kuehn.se>
---
 drivers/net/wireless/ath/ath9k/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig
b/drivers/net/wireless/ath/ath9k/Kconfig index d9c08c6..7b4c074 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -25,6 +25,7 @@ config ATH9K
 
 config ATH9K_PCI
 	bool "Atheros ath9k PCI/PCIe bus support"
+	default y
 	depends on ATH9K && PCI
 	---help---
 	  This option enables the PCI bus support in ath9k.
-- 
1.7.7.2
