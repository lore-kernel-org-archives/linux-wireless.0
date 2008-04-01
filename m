Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:34210 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805AbYDARsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 13:48:55 -0400
Received: by fg-out-1718.google.com with SMTP id l27so2485826fgb.17
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2008 10:48:54 -0700 (PDT)
Message-ID: <69e28c910804011048o6f5ddb84j28c3508d2d1609b6@mail.gmail.com> (sfid-20080401_184858_273695_7195FD3A)
Date: Tue, 1 Apr 2008 19:48:54 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: gavron@wetwork.net
Subject: Re: [PATCH] b43: Enable quantum cryptography support
Cc: "Michael Buesch" <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
In-Reply-To: <47F2720F.7030306@wetwork.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200804011613.06749.mb@bu3sch.de> <47F2720F.7030306@wetwork.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Try the latest GCC 6 development version, that should work. (I tested
it on a Core 4 Hexadeca CPU, not sure if it will work on Core 3 Octos,
as it seems to use SSE6 instructions. Maybe DDR5 RAM is required,
too.)

On 4/1/08, gavron@wetwork.net <gavron@wetwork.net> wrote:
> I tried this patch against the 3.6 tree and I was unable to get it to
> compile.
> It kept saying my version of gcc is too old.
> Is it my SPROM?
>
> Ehud
> gcc version 5.1.2 20090401 (Red Hat 5.1.2-33)
>
> Michael Buesch wrote:
> > This patch enables support for quantum cryptography on latest b43 devices.
> > The quantum cryptography algorithm is 100% backward compatible with the
> > standard CCMP algorithm, so no additional changes to the mac80211 stack
> > are needed. While staying compatible, it makes the unbreakable(!) WLAN
> connection
> > possible. Of course, that's only the case, if both ends use b43-qcrypto.
> > In the case where one STA uses legacy encryption, the card will
> automatically
> > detect this and switch back to plain old CCMP.
> >
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> >
> > ---
> >
> > John, please queue this patch for linux-3.6.26
> >
> >
> > Index: wireless-testing/drivers/net/wireless/b43/b43.h
> > ===================================================================
> > --- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-03-22
> 15:44:00.000000000 +0100
> > +++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-04-01
> 15:53:40.000000000 +0200
> > @@ -270,6 +270,7 @@ enum {
> >  #define B43_HF_ANTSELMODE	0x000200000000ULL /* Antenna selection mode
> (rev >= 13 only) */
> >  #define B43_HF_MLADVW		0x001000000000ULL /* N PHY ML ADV workaround (rev
> >= 13 only) */
> >  #define B43_HF_PR45960W		0x080000000000ULL /* PR 45960 workaround (rev >=
> 13 only) */
> > +#define B43_HF_QUANTUMCRYPT	0x100000000000ULL /* Enable quantum
> cryptography in firmware. */
> >
> >  /* MacFilter offsets. */
> >  #define B43_MACFILTER_SELF		0x0000
> > @@ -439,6 +440,7 @@ enum {
> >  	B43_SEC_ALGO_AES,
> >  	B43_SEC_ALGO_WEP104,
> >  	B43_SEC_ALGO_AES_LEGACY,
> > +	B43_SEC_ALGO_QUANTUM,
> >  };
> >
> >  struct b43_dmaring;
> > Index: wireless-testing/drivers/net/wireless/b43/main.c
> > ===================================================================
> > --- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-03-27
> 17:11:38.000000000 +0100
> > +++ wireless-testing/drivers/net/wireless/b43/main.c	2008-04-01
> 15:53:41.000000000 +0200
> > @@ -3215,6 +3215,13 @@ static int b43_op_set_key(struct ieee802
> >  		break;
> >  	case ALG_CCMP:
> >  		algorithm = B43_SEC_ALGO_AES;
> > +		if (dev->dev->id.revision >= 20080401) {
> > +			/* Latest devices can do quantum cryptography
> > +			 * to encrypt/decrypt the data stream.
> > +			 * This is 100% backward compatible with the traditional
> > +			 * CCMP algorithm. */
> > +			algorithm = B43_SEC_ALGO_QUANTUM;
> > +		}
> >  		break;
> >  	default:
> >  		B43_WARN_ON(1);
> > @@ -3254,6 +3261,10 @@ static int b43_op_set_key(struct ieee802
> >  			b43_hf_write(dev,
> >  				     b43_hf_read(dev) & ~B43_HF_USEDEFKEYS);
> >  		}
> > +		if (algorithm == B43_SEC_ALGO_QUANTUM) {
> > +			b43_hf_write(dev, b43_hf_read(dev)
> > +				     | B43_HF_QUANTUMCRYPT);
> > +		}
> >  		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
> >  		break;
> >  	case DISABLE_KEY: {
> >
> >
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>


-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
