Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2779 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbYKUOGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 09:06:04 -0500
Date: Fri, 21 Nov 2008 09:05:08 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath5k: Clean up eeprom parsing and add missing calibration data
Message-ID: <20081121140508.GA26731@hash.localnet> (sfid-20081121_150607_800084_41FFEC3C)
References: <49257136.2050902@openwrt.org> <20081121030022.GA25726@hash.localnet> <40f31dec0811202121i7d0b5931g9b416a9122f9e0e5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0811202121i7d0b5931g9b416a9122f9e0e5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 21, 2008 at 07:21:07AM +0200, Nick Kossifidis wrote:
> 2008/11/21 Bob Copeland <me@bobcopeland.com>:
> > Can we add the rest here?
> >
> > +               AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC2, ee_misc2);
> 
> Problem is that legacy-hal doesn't make use of these infos (along with
> many other infos stored in eeprom !), so i don't know what eeprom
> versions have them. Go on and use them but for now assume that they
> are only available for eeprom versions 5 and above and i'll check out
> my eeprom dumps etc to find out.

Ok, no rush on this - we can add the patch for these later when we know
which versions specify misc5.

The legacy-hal uses this bit, but does so by directly reading that
offset in attach for some reason.  It's the same address as
AR5K_EEPROM_MISC5, offset 0xc9.  From the HAL:

> HAL_BOOL
> ar5212FillCapabilityInfo(struct ath_hal *ah)
> {
[...]
> 	HAL_CAPABILITIES *pCap = &ahpriv->ah_caps;
> 	u_int16_t capField;
>     u_int16_t regcap;
> 
> 	/* Read the capability EEPROM location */
> 	capField = 0;
> 	if (ahp->ah_eeversion >= AR_EEPROM_VER5_1 &&
> 	    !ath_hal_eepromRead(ah, AR_EEPROM_CAPABILITIES_OFFSET, &capField)) {
> 		HDPRINTF(ah, HAL_DBG_EEPROM, "%s: unable to read caps from eeprom\n", __func__);
> 		return AH_FALSE;
> 	}

Ok, so it only works for eeprom 5.1 and better...

[...]
> 	pCap->halCipherAesCcmSupport =
> 		(!(capField & AR_EEPROM_EEPCAP_AES_DIS) &&
> 		 ((AH_PRIVATE(ah)->ah_macVersion > AR_SREV_VERSION_VENICE) ||
> 		  ((AH_PRIVATE(ah)->ah_macVersion == AR_SREV_VERSION_VENICE) &&
> 		   (AH_PRIVATE(ah)->ah_macRev >= AR_SREV_VERSION_OAHU))));

-- 
Bob Copeland %% www.bobcopeland.com

