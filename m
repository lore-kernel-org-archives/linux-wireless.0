Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213AbZHUOfT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 10:35:19 -0400
Subject: [PATCH] libertas: clean up and clarify get_common_rates
From: Dan Williams <dcbw@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Roel Kluin <roel.kluin@gmail.com>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 09:35:20 -0500
Message-Id: <1250865320.2220.0.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clarify what the heck the function is doing with better variable names
and less indirection and better comments.  Also ensure callers use the
proper minimum size, even though all rates arrays should be size
MAX_RATES anyway.  Reverts part of Andrey's dynamic alloc patch since we
don't really need it.  Also leaves the passed-in rates array alone on
errors.

Signed-off-by: Dan Williams <dcbw@redhat.com>


diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index e9b2731..bf16212 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -35,7 +35,8 @@ static const u8 bssid_off[ETH_ALEN]  __attribute__ ((aligned (2))) =
  *
  *  @param priv     A pointer to struct lbs_private structure
  *  @param rates       the buffer which keeps input and output
- *  @param rates_size  the size of rate1 buffer; new size of buffer on return
+ *  @param rates_size  the size of rates buffer; new size of buffer on return,
+ *                     which will be less than or equal to original rates_size
  *
  *  @return            0 on success, or -1 on error
  */
@@ -43,46 +44,41 @@ static int get_common_rates(struct lbs_private *priv,
 	u8 *rates,
 	u16 *rates_size)
 {
-	u8 *card_rates = lbs_bg_rates;
 	int i, j;
-	u8 *tmp;
-	size_t tmp_size = 0;
+	u8 intersection[MAX_RATES];
+	u16 intersection_size;
+	u16 num_rates = 0;
 
-	tmp = kzalloc(MAX_RATES * ARRAY_SIZE(lbs_bg_rates), GFP_KERNEL);
-	if (!tmp)
-		return -1;
+	intersection_size = min_t(u16, *rates_size, ARRAY_SIZE(intersection));
 
-	/* For each rate in card_rates that exists in rate1, copy to tmp */
-	for (i = 0; i < ARRAY_SIZE(lbs_bg_rates) && card_rates[i]; i++) {
-		for (j = 0; j < *rates_size && rates[j]; j++) {
-			if (rates[j] == card_rates[i])
-				tmp[tmp_size++] = card_rates[i];
-		}
-	}
+	/* Allow each rate from 'rates' that is supported by the hardware */
+	for (i = 0; i < ARRAY_SIZE(lbs_bg_rates) && lbs_bg_rates[i]; i++) {
+		for (j = 0; j < intersection_size && rates[j]; j++) {
+			if (rates[j] == lbs_bg_rates[i])
+				intersection[num_rates++] = rates[j];
+ 		}
+ 	}
 
 	lbs_deb_hex(LBS_DEB_JOIN, "AP rates    ", rates, *rates_size);
-	lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", card_rates,
+	lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", lbs_bg_rates,
 			ARRAY_SIZE(lbs_bg_rates));
-	lbs_deb_hex(LBS_DEB_JOIN, "common rates", tmp, tmp_size);
+	lbs_deb_hex(LBS_DEB_JOIN, "common rates", intersection, num_rates);
 	lbs_deb_join("TX data rate 0x%02x\n", priv->cur_rate);
 
-	memset(rates, 0, *rates_size);
-	*rates_size = min_t(u16, tmp_size, *rates_size);
-	memcpy(rates, tmp, *rates_size);
-
 	if (!priv->enablehwauto) {
-		for (i = 0; i < tmp_size; i++) {
-			if (tmp[i] == priv->cur_rate)
-				break;
-		}
-		if (i == tmp_size) {
-			lbs_pr_alert("Previously set fixed data rate %#x isn't "
-					"compatible with the network.\n",
-					priv->cur_rate);
-			return -1;
+		for (i = 0; i < num_rates; i++) {
+			if (intersection[i] == priv->cur_rate)
+				goto done;
 		}
+		lbs_pr_alert("Previously set fixed data rate %#x isn't "
+		       "compatible with the network.\n", priv->cur_rate);
+		return -1;
 	}
-	kfree(tmp);
+
+done:
+	memset(rates, 0, *rates_size);
+	*rates_size = num_rates;
+	memcpy(rates, intersection, num_rates);
 	return 0;
 }
 
@@ -325,7 +321,7 @@ static int lbs_associate(struct lbs_private *priv,
 
 	rates = (struct mrvl_ie_rates_param_set *) pos;
 	rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
-	tmplen = min_t(u16, ARRAY_SIZE(rates->rates), MAX_RATES);
+	tmplen = min_t(u16, ARRAY_SIZE(bss->rates), MAX_RATES);
 	memcpy(&rates->rates, &bss->rates, tmplen);
 	if (get_common_rates(priv, rates->rates, &tmplen)) {
 		ret = -1;
@@ -600,7 +596,7 @@ static int lbs_adhoc_join(struct lbs_private *priv,
 
 	/* Copy Data rates from the rates recorded in scan response */
 	memset(cmd.bss.rates, 0, sizeof(cmd.bss.rates));
-	ratesize = min_t(u16, ARRAY_SIZE(cmd.bss.rates), MAX_RATES);
+	ratesize = min_t(u16, ARRAY_SIZE(cmd.bss.rates), ARRAY_SIZE (bss->rates));
 	memcpy(cmd.bss.rates, bss->rates, ratesize);
 	if (get_common_rates(priv, cmd.bss.rates, &ratesize)) {
 		lbs_deb_join("ADHOC_JOIN: get_common_rates returned error.\n");


