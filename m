Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:62369 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbZHNAkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 20:40:45 -0400
Received: by pzk34 with SMTP id 34so797072pzk.4
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 17:40:46 -0700 (PDT)
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: dcbw@redhat.com, Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] libertas: don't use dynamic-sized array
Date: Thu, 13 Aug 2009 17:34:40 -0700
Message-Id: <1250210080-21960-1-git-send-email-andrey@cozybit.com>
In-Reply-To: <43e72e890908131331q371320a3gf1ab53ea27574549@mail.gmail.com>
References: <43e72e890908131331q371320a3gf1ab53ea27574549@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sparse complains about a bad constant expression due to the use of a
dynamic-sized array in get_common_rates().  Allocate and free the array
instead.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 drivers/net/wireless/libertas/assoc.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index 1902b6f..9834399 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -45,9 +45,14 @@ static int get_common_rates(struct lbs_private *priv,
 {
 	u8 *card_rates = lbs_bg_rates;
 	int ret = 0, i, j;
-	u8 tmp[(ARRAY_SIZE(lbs_bg_rates) - 1) * (*rates_size - 1)];
+	u8 *tmp;
 	size_t tmp_size = 0;
 
+	tmp = kzalloc((ARRAY_SIZE(lbs_bg_rates) - 1) * (*rates_size - 1),
+			GFP_KERNEL);
+	if (!tmp)
+		return -1;
+
 	/* For each rate in card_rates that exists in rate1, copy to tmp */
 	for (i = 0; i < ARRAY_SIZE(lbs_bg_rates) && card_rates[i]; i++) {
 		for (j = 0; j < *rates_size && rates[j]; j++) {
@@ -75,6 +80,7 @@ done:
 	memset(rates, 0, *rates_size);
 	*rates_size = min_t(int, tmp_size, *rates_size);
 	memcpy(rates, tmp, *rates_size);
+	kfree(tmp);
 	return ret;
 }
 
-- 
1.5.6.3

