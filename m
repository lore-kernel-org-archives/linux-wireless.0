Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:39012 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZG1H51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 03:57:27 -0400
Received: by mail-ew0-f226.google.com with SMTP id 26so3767834ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 00:57:27 -0700 (PDT)
Message-ID: <4A6EB00D.5010401@gmail.com>
Date: Tue, 28 Jul 2009 10:00:13 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: dcbw@redhat.com, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] libertas: Read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several arrays were read before checking whether the index was within
bounds. ARRAY_SIZE() should be used to determine the size of arrays.

rates->rates has an arraysize of 1, so calling get_common_rates()
with a rates_size of MAX_RATES (14) was causing reads out of bounds.

Since ratesize is at most MAX_RATES, tmp_size can increment at most
to MAX_RATES * ARRAY_SIZE(lbs_bg_rates), so that should be the number
of elements of tmp[].

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Please review.

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index b9b3741..7dfbb0c 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -1,6 +1,7 @@
 /* Copyright (C) 2006, Red Hat, Inc. */
 
 #include <linux/types.h>
+#include <linux/kernel.h>
 #include <linux/etherdevice.h>
 #include <linux/ieee80211.h>
 #include <linux/if_arp.h>
@@ -43,14 +44,14 @@ static int get_common_rates(struct lbs_private *priv,
 	u16 *rates_size)
 {
 	u8 *card_rates = lbs_bg_rates;
-	size_t num_card_rates = sizeof(lbs_bg_rates);
+	size_t num_card_rates = ARRAY_SIZE(lbs_bg_rates);
 	int ret = 0, i, j;
-	u8 tmp[30];
+	u8 tmp[MAX_RATES * ARRAY_SIZE(lbs_bg_rates)];
 	size_t tmp_size = 0;
 
 	/* For each rate in card_rates that exists in rate1, copy to tmp */
-	for (i = 0; card_rates[i] && (i < num_card_rates); i++) {
-		for (j = 0; rates[j] && (j < *rates_size); j++) {
+	for (i = 0; i < num_card_rates && card_rates[i]; i++) {
+		for (j = 0; j < *rates_size && rates[j]; j++) {
 			if (rates[j] == card_rates[i])
 				tmp[tmp_size++] = card_rates[i];
 		}
@@ -322,7 +323,7 @@ static int lbs_associate(struct lbs_private *priv,
 	rates = (struct mrvl_ie_rates_param_set *) pos;
 	rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
 	memcpy(&rates->rates, &bss->rates, MAX_RATES);
-	tmplen = MAX_RATES;
+	tmplen = min_t(u16, ARRAY_SIZE(rates->rates), MAX_RATES);
 	if (get_common_rates(priv, rates->rates, &tmplen)) {
 		ret = -1;
 		goto done;
@@ -598,7 +599,7 @@ static int lbs_adhoc_join(struct lbs_private *priv,
 
 	/* Copy Data rates from the rates recorded in scan response */
 	memset(cmd.bss.rates, 0, sizeof(cmd.bss.rates));
-	ratesize = min_t(u16, sizeof(cmd.bss.rates), MAX_RATES);
+	ratesize = min_t(u16, ARRAY_SIZE(cmd.bss.rates), MAX_RATES);
 	memcpy(cmd.bss.rates, bss->rates, ratesize);
 	if (get_common_rates(priv, cmd.bss.rates, &ratesize)) {
 		lbs_deb_join("ADHOC_JOIN: get_common_rates returned error.
");
