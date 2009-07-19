Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47965 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753333AbZGSMft (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 08:35:49 -0400
Message-ID: <4A631321.8070500@gmx.de>
Date: Sun, 19 Jul 2009 14:35:45 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org,
	Stephen Chen <Stephen.Chen@atheros.com>,
	David Quan <David.Quan@atheros.com>,
	Tony Yang <Tony.Yang@atheros.com>
Subject: Re: [PATCH] ath: add support for special 0x8000 regulatory domain
References: <1247779124-29204-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247779124-29204-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/16/2009 11:18 PM, Luis R. Rodriguez wrote:
> Two users of ar9170 devices have now reported their cards
> have been programmed with a regulatory domain of 0x8000.
> This is not a valid regulatory domain as such these users were
> unable to use these devices. Since this doesn't seem to be
> a device EEPROM corruption we must treat it specially.
> 
> We default these devices to the default Atheros 0x64 world
> regulatory domain.
> ...
> David, or Joerg, can you please test this patch.

Hi Luis,

this patch doesn't work, I still get:

ath: EEPROM regdomain: 0x8000
ath: EEPROM indicates we should expect a country code
ath: No regulatory domain pair found, cannot continue
ar9170usb: probe of 1-1:1.0 failed with error -22

I guess that's due to reg->current_rd == 0x8000, while CTRY_DEFAULT 
== 0 in ath_regd_sanitize().

Applying

diff --git a/drivers/net/wireless/ath/regd.c 
b/drivers/net/wireless/ath/regd.c
index 62aa270..eae9a58 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -483,7 +483,7 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
   */
  static void ath_regd_sanitize(struct ath_regulatory *reg)
  {
-       if (reg->current_rd != CTRY_DEFAULT)
+       if (reg->current_rd != (CTRY_DEFAULT|COUNTRY_ERD_FLAG))
                 return;
         printk(KERN_DEBUG "ath: EEPROM regdomain sanitized\n");
         reg->current_rd = 0x64;

on top of your patch worked:

ath: EEPROM regdomain sanitized
ath: EEPROM regdomain: 0x64
ath: EEPROM indicates we should expect a direct regpair map
ath: Country alpha2 being used: 00
ath: Regpair used: 0x64

Why do we handle a regdomain of 0x8000 differently from a regdomain 
of 0?
0x8000 leads to regdomain 0x64 in ath_regd_sanitize() while 0 is
mapped into country code CTRY_UNITED_STATES.

With the above patch I don't see channels 12,13,100-140 in "iwlist 
wlan0 channel", which are allowed in DE, but I guess that's due to 
using regdomain WOR4_WORLD (0x64).

Do calibration data in the EEPROM really depend on the regdomain, 
i.e. do manufacturers calibrate only for a subset of channels due to 
the regdomain the device will be programmed with?

BTW, I bought this device refurbished in an U.K. webshop.

