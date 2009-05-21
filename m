Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27976 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbZEURQQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 13:16:16 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 May 2009 10:16:18 -0700
Date: Thu, 21 May 2009 10:16:19 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Stephen Chen <Stephen.Chen@Atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Joerg Albert <jal2@gmx.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@web.de>
Subject: Re: ath/regd.c: regdomain 0x8000 fails to retrieve a regulatory
	domain pair
Message-ID: <20090521171619.GB28691@tesla>
References: <4A0802B0.9070206@gmx.de> <20090511190602.GC18696@tesla> <618D4DE9D5223A45A46C48063FD640451098774889@TAEXMB-01.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <618D4DE9D5223A45A46C48063FD640451098774889@TAEXMB-01.global.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Mon, May 11, 2009 at 03:49:20AM -0700, Joerg Albert wrote:
> > Plugging in a WNDA3100 (ar9170usb) I get the error
> >
> > ath: No regulatory domain pair found, cannot continue
> >
> > Seems like the EEPROM of the stick initializes regulatory.current_rd
> > to 0x8000, current_rd_ext to 0. Is this a valid setting?
> >
> > Looked into ath/regd.c, ath_regd_init():
> >
> > ath_get_regpair(regdmn)
> >
> > is called with regdmn == 0x8000 and returns NULL.
> >
> > Shall that regdmn value be dealt with by
> >
> >          if (reg->country_code == CTRY_DEFAULT &&
> >              regdmn == CTRY_DEFAULT)
> >                  reg->country_code = CTRY_UNITED_STATES;
> > ?
> >
> > wireless-testing is git v2.6.30-rc4-22735-gbd48c47, I run
> > compat-wireless with a 2.6.29.2 kernel.
> 
> Thanks for reporting this.
> 
> Stephen do ar9170 cards get sold with a regulatory domain set to 0x8000?
> If so we need to deal with this in the common ath.ko module and set the regulatory
> domain as intended.
> 
> If we are not sure we can simply default to one of the world regulatory domains for
> this specific case, 0x64, for example.

Joerg, can you please try this patch, its just informative and I would
like to see the output. A regulatory domain in the EEPROM set to 0x8000 
should be cought, as you indicated, in this code:

        if (reg->country_code == CTRY_DEFAULT &&
            regdmn == CTRY_DEFAULT)
                reg->country_code = CTRY_UNITED_STATES;

The debug prints should help.

  Luis

From: Luis R. Rodriguez <lrodriguez@atheros.com>
Subject: [PATCH] ath: make regulatory initialization more informative

This should help debugging. This has no functional change.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/regd.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 7a89f9f..556e252 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -366,11 +366,17 @@ static bool ath_regd_is_eeprom_valid(struct ath_regulatory *reg)
 	if (rd & COUNTRY_ERD_FLAG) {
 		/* EEPROM value is a country code */
 		u16 cc = rd & ~COUNTRY_ERD_FLAG;
+		printk(KERN_DEBUG
+		       "ath: EEPROM indicates we should expect "
+			"a country code\n");
 		for (i = 0; i < ARRAY_SIZE(allCountries); i++)
 			if (allCountries[i].countryCode == cc)
 				return true;
 	} else {
 		/* EEPROM value is a regpair value */
+		if (rd != CTRY_DEFAULT)
+			printk(KERN_DEBUG "ath: EEPROM indicates we "
+			       "should expect a direct regpair map\n");
 		for (i = 0; i < ARRAY_SIZE(regDomainPairs); i++)
 			if (regDomainPairs[i].regDmnEnum == rd)
 				return true;
@@ -486,20 +492,30 @@ ath_regd_init(struct ath_regulatory *reg,
 	reg->country_code = ath_regd_get_default_country(regdmn);
 
 	if (reg->country_code == CTRY_DEFAULT &&
-	    regdmn == CTRY_DEFAULT)
+	    regdmn == CTRY_DEFAULT) {
+		printk(KERN_DEBUG "ath: EEPROM indicates default "
+		       "country code should be used\n");
 		reg->country_code = CTRY_UNITED_STATES;
+	}
 
 	if (reg->country_code == CTRY_DEFAULT) {
 		country = NULL;
 	} else {
+		printk(KERN_DEBUG "ath: doing EEPROM country->regdmn "
+		       "map search\n");
 		country = ath_regd_find_country(reg->country_code);
 		if (country == NULL) {
 			printk(KERN_DEBUG
-				"ath: Country is NULL!!!!, cc= %d\n",
+				"ath: no valid country maps found for "
+				"country code: 0x%0x\n",
 				reg->country_code);
 			return -EINVAL;
-		} else
+		} else {
 			regdmn = country->regDmnEnum;
+			printk(KERN_DEBUG "ath: country maps to "
+			       "regdmn code: 0x%0x\n",
+			       regdmn);
+		}
 	}
 
 	reg->regpair = ath_get_regpair(regdmn);
-- 
1.5.6.4

