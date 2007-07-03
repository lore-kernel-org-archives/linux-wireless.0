Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:49628 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbXGCWwY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 18:52:24 -0400
Date: Wed, 4 Jul 2007 00:31:44 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: jgarzik@pobox.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] eeprom_93cx6: shorten pulse timing to match spec (bis)
Message-ID: <20070703223144.GA13714@electric-eye.fr.zoreil.com>
References: <20070702210345.GA22610@electric-eye.fr.zoreil.com> <20070703123441.GA3534@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070703123441.GA3534@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on an original idea by John W. Linville.

It is the missing part of 42d45ccd60636c28e35c2016f091783bc14ad99c

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
---
 drivers/misc/eeprom_93cx6.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/eeprom_93cx6.c b/drivers/misc/eeprom_93cx6.c
index ac515b0..ea55654 100644
--- a/drivers/misc/eeprom_93cx6.c
+++ b/drivers/misc/eeprom_93cx6.c
@@ -55,10 +55,10 @@ static inline void eeprom_93cx6_pulse_low(struct eeprom_93cx6 *eeprom)
 
 	/*
 	 * Add a short delay for the pulse to work.
-	 * According to the specifications the minimal time
-	 * should be 450ns so a 1us delay is sufficient.
+	 * According to the specifications the "maximum minimum"
+	 * time should be 450ns.
 	 */
-	udelay(1);
+	ndelay(450);
 }
 
 static void eeprom_93cx6_startup(struct eeprom_93cx6 *eeprom)
-- 
1.5.2.1

