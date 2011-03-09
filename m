Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mow300.securemx.jp ([210.130.202.48]:51785 "EHLO
	mow.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1CIG7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 01:59:54 -0500
Date: Wed, 09 Mar 2011 16:00:15 +0900
From: Takashi Kawamoto <tkawamoto@silex.jp>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Subject: Re: AR9271 doesn't work on 12ch and 13ch
Cc: linux-wireless@vger.kernel.org, Yoshitaka Imura <imura@silex.jp>
In-Reply-To: <AANLkTima4A99hPTVc3zn1fqwvNTgGZwj16u3+uZEjOT2@mail.gmail.com>
References: <20110309093724.BF94.9AD4E5EB@silex.jp> <AANLkTima4A99hPTVc3zn1fqwvNTgGZwj16u3+uZEjOT2@mail.gmail.com>
Message-Id: <20110309153520.BF9A.9AD4E5EB@silex.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

Thank you.

I finally figured out the reason.

In ath_regd_init_wiphy(), when region domain code read from EEPROM is 
Country Code (bit15 is 1), ath_default_world_regdomain() is invoked.
-----------------------------------------------------------------------
...
	if (ath_is_world_regd(reg)) {
		/*
		 * Anything applied here (prior to wiphy registration) gets
		 * saved on the wiphy orig_* parameters
		 */
		regd = ath_world_regdomain(reg);
		wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
	} else {
		/*
		 * This gets applied in the case of the absense of CRDA,
		 * it's our own custom world regulatory domain, similar to
		 * cfg80211's but we enable passive scanning.
		 */
		regd = ath_default_world_regdomain();
	}
...
-----------------------------------------------------------------------

ath_default_world_regdomain() always returns just one regulatory domain 
table (ath_world_regdom_64). ath_world_regdom_64 does not include 
higher than 11ch.
I can't undestand why this default world setting is selected for 
Country Code. :<
-----------------------------------------------------------------------
...
/* Can be used by 0x64 only */
static const struct ieee80211_regdomain ath_world_regdom_64 = {
	.n_reg_rules = 3,
	.alpha2 =  "99",
	.reg_rules = {
		ATH9K_2GHZ_CH01_11,
		ATH9K_5GHZ_NO_MIDBAND,
	}
};

...

static const struct ieee80211_regdomain
*ath_default_world_regdomain(void)
{
	/* this is the most restrictive */
	return &ath_world_regdom_64;
}

...
-----------------------------------------------------------------------

I modified ath_regd_init_wiphy() for now to call ath_world_regdomain().
-----------------------------------------------------------------------
	if (ath_is_world_regd(reg)) {
		/*
		 * Anything applied here (prior to wiphy registration) gets
		 * saved on the wiphy orig_* parameters
		 */
		regd = ath_world_regdomain(reg);
		wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
	} else {
		/*
		 * This gets applied in the case of the absense of CRDA,
		 * it's our own custom world regulatory domain, similar to
		 * cfg80211's but we enable passive scanning.
		 */
#if 0	/**/
		regd = ath_default_world_regdomain();
#else	/**/
		/* It is needed to configure regdomain according to EEPROM content */
		regd = ath_world_regdomain(reg);
#endif	/**/
	}
-----------------------------------------------------------------------

And I add a new table for Japan and also modified ath_world_regdomain().
-----------------------------------------------------------------------
...
/* MKK1_MKKA for Japan */
/* Can be used for:
 * 0x40, and more? */
static const struct ieee80211_regdomain ath_world_regdom_40 = {
	.n_reg_rules = 5,
	.alpha2 =  "99",
	.reg_rules = {
		ATH9K_2GHZ_ALL,
		ATH9K_5GHZ_ALL,
	}
};

...

static const struct
ieee80211_regdomain *ath_world_regdomain(struct ath_regulatory *reg)
{
	switch (reg->regpair->regDmnEnum) {
#if 1	/**/
	case 0x40:	/* MKK1_MKKA for Japan */
		return &ath_world_regdom_40;
#endif	/**/
	case 0x60:
	case 0x61:
	case 0x62:
		return &ath_world_regdom_60_61_62;

...
-----------------------------------------------------------------------

The above modification enables connection on 12, 13 and 14ch.
CRDA seems not to work. 



Best Regards,
Takashi Kawamoto

On Wed, 9 Mar 2011 11:59:43 +0530
Mohammed Shafi <shafi.wireless@gmail.com> wrote:

> On Wed, Mar 9, 2011 at 6:11 AM, Takashi Kawamoto <tkawamoto@silex.jp> wrote:
> > Hi Mohammed,
> >
> > The below is dmesg log.
> >
> > =======================================================================
> > Compat-wireless backport release: compat-wireless-2011-01-06-3-g8db1608
> > Backport based on linux-next.git next-20110121
> > cfg80211: Calling CRDA to update world regulatory domain
> > usb 1-2: ath9k_htc: Transferred FW: ar9271.fw, size: 51280
> > usb 1-2: ath9k_htc: HTC initialized with 33 credits
> > ath: EEPROM regdomain: 0x8188
> > ath: EEPROM indicates we should expect a country code
> > ath: doing EEPROM country->regdmn map search
> > ath: country maps to regdmn code: 0x40
> > ath: Country alpha2 being used: JP
> > ath: Regpair used: 0x40
> > cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
> > cfg80211: Disabling freq 2467 MHz as custom regd has no rule that fits a 20 MHz wide channel
> > cfg80211: Disabling freq 2472 MHz as custom regd has no rule that fits a 20 MHz wide channel
> > cfg80211: Disabling freq 2484 MHz as custom regd has no rule that fits a 20 MHz wide channel
> > cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (600 mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (600 mBi, 2000 mBm)
> > cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
> > cfg80211: 2474000 KHz - 2494000 KHz @  KHz), (600 mBi, 2000 mBm)
> > cfg80211: Pending regulatory request, waiting for it to be processed...
> > usb 1-2: ath9k_htc: USB layer initialized
> > usbcore: registered new interface driver ath9k_hif_usb
> > =======================================================================
> >
> > The following logs seems to be clue. I will check them. Thank you.
> > -----------------------------------------------------------------------
> > ...
> > cfg80211: Disabling freq 2467 MHz as custom regd has no rule that fits a 20 MHz wide channel
> > cfg80211: Disabling freq 2472 MHz as custom regd has no rule that fits a 20 MHz wide channel
> > cfg80211: Disabling freq 2484 MHz as custom regd has no rule that fits a 20 MHz wide channel
> > ...
> > -----------------------------------------------------------------------
> 
> Ok I have very little idea about regulatory. I will try.
> This may be of some help
> http://linuxwireless.org/en/developers/Regulatory
> 
> >
> >
> >
> > Best Regards,
> > Takashi Kawamoto
> >
> > On Tue, 8 Mar 2011 20:27:07 +0530
> > Mohammed Shafi <shafi.wireless@gmail.com> wrote:
> >
> >> On Tue, Mar 8, 2011 at 6:09 PM, Takashi Kawamoto <tkawamoto@silex.jp> wrote:
> >> > Dear All,
> >> >
> >> > AR9271 cannot connect to an AP which operates on 12ch and 13ch.
> >> > As long as I see the EEPROM content of my module, 0x8188 (CTRL_JAPAN1)
> >> > seems to be configured to the region domain code area.
> >> >
> >> > [EEPROM dump]
> >> > -------------------------------------------------------
> >> > 78  1 99 B4  F E0  2  0 88 81 2A  0 5C 33 8E 65
> >> > 74 C1  1  1  0  0  0  0  0  0  0 7F  8  0  8  0
> >> >  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
> >> >  0  0  0  0  0  0  0  0  0  0  0  0  0 2C 20  0
> >> > E2  0  D  0  2  E 1C BA  C  1  0  0  6 55  5  1
> >> >  E  E FF  0  0 2C  0  0  5  4  6 B0  0 60  0  0
> >> >  0  1  0  0  0 80  0  0  0  0  0  0  0  0  0  0
> >> >  0  0  0  0  0  0  0  0 70 8E AC  B 22 2A 3D 53
> >> > 4B 54 5E 6A 74  5 10 17 2F 6E 2C 3B 55 83 B0  D
> >> > 24 2A 3E 52 4C 54 60 6B 71  7 11 17 36 71 30 40
> >> > 5F 93 AF  E 13 2A 3E 51 4B 53 5F 6B 6E  7  A 18
> >> > 38 70 2C 44 62 9A AC 70 22 22 22 22 B8 22 22 22
> >> > 22 FF  0  0  0  0 70 22 22 20 1E 89 22 22 20 1E
> >> > AC 22 22 20 1E 70 22 22 22 22 22 22 20 1E 89 22
> >> > 22 22 22 22 22 20 1E AC 22 22 22 22 22 22 20 1E
> >> > 70 1E 1E 1E 1E 1E 1E 1E 1C 89 1E 1E 1E 1E 1E 1E
> >> > 1E 1C AC 1E 1E 1E 1E 1E 1E 1E 1C 11 12 15 17 41
> >> > 42 45 47 31 32 35 37 70 22 75 62 A2 22  0  0 70
> >> > 22 75 62 A2 21  0  0 70 1A 75 62 A2 1E  0  0 7A
> >> > 12 7F 5C 93 5C 98 16 70 3C 75 7C AC 3C B8 3C 70
> >> > 3C 75 7C AC 3C  0  0 70 3C 75 7C AC 3C  0  0 7A
> >> > 3C 7F 7C 93 7C A2 3C 70 22 75 62 AC 22  0  0 70
> >> > 22 75 62 AC 22  0  0 70 22 75 62 AC 22  0  0 7A
> >> > 1E 7F 5E 93 5E A2 1E  0
> >> > -------------------------------------------------------
> >> >
> >> > The version of compat-wireless I use is 2011-01-30.
> >> >
> >> > I investigated the issue further, and found that priv->hw->wiphy->bands
> >> > includes from 1ch to 14ch (ath9k_set_hw_capab() in htc_drv_init.c), but
> >> > wdev->wiphy->bands includes from 1ch to 11ch (cfg80211_wext_giwrange()
> >> > in wext-compat.c). I still don't know why and when 12ch, 13ch and 14ch
> >> > are removed from the channel list.
> >> >
> >> > Anyone has any idea?
> >>
> >> Please post the kernel log /dmesg with CONFIG_CFG80211_REG_DEBUG=y
> >> enabled in config.mk of your compat wireless. This might also be
> >> helpful.
> >>
> >> >
> >> >
> >> >
> >> > Best Regards,
> >> > Takashi Kawamoto
> >> >
> >> > ==================================================
> >> >  Takashi Kawamoto (E-Mail : tkawamoto@silex.jp)
> >> >  silex technology,Inc.
> >> >  Software Engineering Division
> >> >  Phone:+81-774-98-3877 FAX:+81-774-98-3678
> >> > ==================================================
> >> >
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > ==================================================
> >  Takashi Kawamoto (E-Mail : tkawamoto@silex.jp)
> >  silex technology,Inc.
> >  Software Engineering Division
> >  Phone:+81-774-98-3877 FAX:+81-774-98-3678
> > ==================================================
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

==================================================
 Takashi Kawamoto (E-Mail : tkawamoto@silex.jp)
 silex technology,Inc. 
 Software Engineering Division
 Phone:+81-774-98-3877 FAX:+81-774-98-3678
==================================================

