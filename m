Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:13945 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbZG1KCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 06:02:16 -0400
Received: by ey-out-2122.google.com with SMTP id 9so980925eyd.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 03:02:15 -0700 (PDT)
Message-ID: <4A6ECD4C.2040101@gmail.com>
Date: Tue, 28 Jul 2009 12:05:00 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Holger Schurig <hs4233@mail.mn-solutions.de>
CC: dcbw@redhat.com, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] libertas: Read buffer overflow
References: <4A6EB00D.5010401@gmail.com> <200907281019.56855.hs4233@mail.mn-solutions.de>
In-Reply-To: <200907281019.56855.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several arrays were read before checking whether the index was within
bounds. ARRAY_SIZE() should be used to determine the size of arrays.

rates->rates has an arraysize of 1, so calling get_common_rates()
with a rates_size of MAX_RATES (14) was causing reads out of bounds.

tmp_size can increment at most to (ARRAY_SIZE(lbs_bg_rates) - 1) *
(*rates_size - 1), so that should be the number of elements of tmp[].

A goto can be eliminated: ret was already set upon its declaration.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Op 28-07-09 10:19, Holger Schurig schreef:
>> -	size_t num_card_rates = sizeof(lbs_bg_rates);
>> +	size_t num_card_rates = ARRAY_SIZE(lbs_bg_rates);
> 
> Hmm, not sure about this.  First I don't know if we need a 
> variable for this at all. Can't you simply use ARRAY_SIZE() 
> whenever it's needed?

Of course. Please note the additional changes.

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index b9b3741..d699737 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -1,6 +1,7 @@
 /* Copyright (C) 2006, Red Hat, Inc. */
 
 #include <linux/types.h>
+#include <linux/kernel.h>
 #include <linux/etherdevice.h>
 #include <linux/ieee80211.h>
 #include <linux/if_arp.h>
@@ -43,21 +44,21 @@ static int get_common_rates(struct lbs_private *priv,
 	u16 *rates_size)
 {
 	u8 *card_rates = lbs_bg_rates;
-	size_t num_card_rates = sizeof(lbs_bg_rates);
 	int ret = 0, i, j;
-	u8 tmp[30];
+	u8 tmp[(ARRAY_SIZE(lbs_bg_rates) - 1) * (*rates_size - 1)];
 	size_t tmp_size = 0;
 
 	/* For each rate in card_rates that exists in rate1, copy to tmp */
-	for (i = 0; card_rates[i] && (i < num_card_rates); i++) {
-		for (j = 0; rates[j] && (j < *rates_size); j++) {
+	for (i = 0; i < ARRAY_SIZE(lbs_bg_rates) && card_rates[i]; i++) {
+		for (j = 0; j < *rates_size && rates[j]; j++) {
 			if (rates[j] == card_rates[i])
 				tmp[tmp_size++] = card_rates[i];
 		}
 	}
 
 	lbs_deb_hex(LBS_DEB_JOIN, "AP rates    ", rates, *rates_size);
-	lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", card_rates, num_card_rates);
+	lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", card_rates,
+			ARRAY_SIZE(lbs_bg_rates));
 	lbs_deb_hex(LBS_DEB_JOIN, "common rates", tmp, tmp_size);
 	lbs_deb_join("TX data rate 0x%02x\n", priv->cur_rate);
 
@@ -69,10 +70,7 @@ static int get_common_rates(struct lbs_private *priv,
 		lbs_pr_alert("Previously set fixed data rate %#x isn't "
 		       "compatible with the network.\n", priv->cur_rate);
 		ret = -1;
-		goto done;
 	}
-	ret = 0;
-
 done:
 	memset(rates, 0, *rates_size);
 	*rates_size = min_t(int, tmp_size, *rates_size);
@@ -322,7 +320,7 @@ static int lbs_associate(struct lbs_private *priv,
 	rates = (struct mrvl_ie_rates_param_set *) pos;
 	rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
 	memcpy(&rates->rates, &bss->rates, MAX_RATES);
-	tmplen = MAX_RATES;
+	tmplen = min_t(u16, ARRAY_SIZE(rates->rates), MAX_RATES);
 	if (get_common_rates(priv, rates->rates, &tmplen)) {
 		ret = -1;
 		goto done;
@@ -598,7 +596,7 @@ static int lbs_adhoc_join(struct lbs_private *priv,
 
 	/* Copy Data rates from the rates recorded in scan response */
 	memset(cmd.bss.rates, 0, sizeof(cmd.bss.rates));
-	ratesize = min_t(u16, sizeof(cmd.bss.rates), MAX_RATES);
+	ratesize = min_t(u16, ARRAY_SIZE(cmd.bss.rates), MAX_RATES);
 	memcpy(cmd.bss.rates, bss->rates, ratesize);
 	if (get_common_rates(priv, cmd.bss.rates, &ratesize)) {
 		lbs_deb_join("ADHOC_JOIN: get_common_rates returned error.\n");
