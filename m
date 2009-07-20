Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61288 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZGTCwp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 22:52:45 -0400
Date: Sun, 19 Jul 2009 21:53:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chunkeey@web.de, linux-wireless@vger.kernel.org
Subject: [PATCH] p54: Eliminate unnecessary initialization
Message-ID: <4a63dc1a.1FJh1v8iWfTl3JyP%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In two places, variables are unnecessilarly initialized to NULL.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---


Index: wireless-testing/drivers/net/wireless/p54/eeprom.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/eeprom.c
+++ wireless-testing/drivers/net/wireless/p54/eeprom.c
@@ -346,7 +346,7 @@ static struct p54_cal_database *p54_conv
 int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 {
 	struct p54_common *priv = dev->priv;
-	struct eeprom_pda_wrap *wrap = NULL;
+	struct eeprom_pda_wrap *wrap;
 	struct pda_entry *entry;
 	unsigned int data_len, entry_len;
 	void *tmp;
@@ -533,7 +533,7 @@ int p54_read_eeprom(struct ieee80211_hw
 	struct p54_common *priv = dev->priv;
 	size_t eeprom_size = 0x2020, offset = 0, blocksize, maxblocksize;
 	int ret = -ENOMEM;
-	void *eeprom = NULL;
+	void *eeprom;
 
 	maxblocksize = EEPROM_READBACK_LEN;
 	if (priv->fw_var >= 0x509)
