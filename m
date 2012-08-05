Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34401 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903Ab2HETgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 15:36:38 -0400
Received: by wibhr14 with SMTP id hr14so1067677wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 05 Aug 2012 12:36:37 -0700 (PDT)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com,
	thomas@net.t-labs.tu-berlin.de, nbd@openwrt.org,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH v2 5/5] ath5k: Return correct offset when reading frequencies
Date: Sun,  5 Aug 2012 22:35:37 +0300
Message-Id: <1344195337-27461-6-git-send-email-mickflemm@gmail.com> (sfid-20120805_213640_689688_971E97E7)
In-Reply-To: <1344195337-27461-1-git-send-email-mickflemm@gmail.com>
References: <1344195337-27461-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we have a zeroed frequency on the calibration piers it means that we
shouldn't use that pier, not stop reading the EEPROM and break out from
the loop. By doing that we return the wrong offset and the whole dataset
gets corrupted.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
Tested-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 drivers/net/wireless/ath/ath5k/eeprom.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 4026c90..10a4396 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -522,7 +522,7 @@ ath5k_eeprom_read_freq_list(struct ath5k_hw *ah, int *offset, int max,
 
 		freq1 = val & 0xff;
 		if (!freq1)
-			break;
+			continue;
 
 		pc[i++].freq = ath5k_eeprom_bin2freq(ee,
 				freq1, mode);
@@ -530,7 +530,7 @@ ath5k_eeprom_read_freq_list(struct ath5k_hw *ah, int *offset, int max,
 
 		freq2 = (val >> 8) & 0xff;
 		if (!freq2)
-			break;
+			continue;
 
 		pc[i++].freq = ath5k_eeprom_bin2freq(ee,
 				freq2, mode);
-- 
1.7.3.4

