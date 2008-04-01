Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Bass.Opus1.COM ([192.245.12.9]:1530 "EHLO bass.opus1.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbYDATTk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 15:19:40 -0400
Received: from egdell.wetwork.net ([204.17.34.178])
 by Opus1.COM (PMDF V6.2-X27 #9830)
 with ESMTPSA id <01MT3V2V6SB08ZOZTY@Opus1.COM> for
 linux-wireless@vger.kernel.org; Tue, 01 Apr 2008 10:34:07 -0700 (MST)
Date: Tue, 01 Apr 2008 10:34:07 -0700
From: gavron@wetwork.net
Subject: Re: [PATCH] b43: Enable quantum cryptography support
In-reply-to: <200804011613.06749.mb@bu3sch.de>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Message-id: <47F2720F.7030306@wetwork.net> (sfid-20080401_201942_776639_DCA8FCE1)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
References: <200804011613.06749.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tried this patch against the 3.6 tree and I was unable to get it to 
compile.
It kept saying my version of gcc is too old.
Is it my SPROM?

Ehud
gcc version 5.1.2 20090401 (Red Hat 5.1.2-33)

Michael Buesch wrote:
> This patch enables support for quantum cryptography on latest b43 devices.
> The quantum cryptography algorithm is 100% backward compatible with the
> standard CCMP algorithm, so no additional changes to the mac80211 stack
> are needed. While staying compatible, it makes the unbreakable(!) WLAN connection
> possible. Of course, that's only the case, if both ends use b43-qcrypto.
> In the case where one STA uses legacy encryption, the card will automatically
> detect this and switch back to plain old CCMP.
>
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
>
> ---
>
> John, please queue this patch for linux-3.6.26
>
>
> Index: wireless-testing/drivers/net/wireless/b43/b43.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-03-22 15:44:00.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-04-01 15:53:40.000000000 +0200
> @@ -270,6 +270,7 @@ enum {
>  #define B43_HF_ANTSELMODE	0x000200000000ULL /* Antenna selection mode (rev >= 13 only) */
>  #define B43_HF_MLADVW		0x001000000000ULL /* N PHY ML ADV workaround (rev >= 13 only) */
>  #define B43_HF_PR45960W		0x080000000000ULL /* PR 45960 workaround (rev >= 13 only) */
> +#define B43_HF_QUANTUMCRYPT	0x100000000000ULL /* Enable quantum cryptography in firmware. */
>  
>  /* MacFilter offsets. */
>  #define B43_MACFILTER_SELF		0x0000
> @@ -439,6 +440,7 @@ enum {
>  	B43_SEC_ALGO_AES,
>  	B43_SEC_ALGO_WEP104,
>  	B43_SEC_ALGO_AES_LEGACY,
> +	B43_SEC_ALGO_QUANTUM,
>  };
>  
>  struct b43_dmaring;
> Index: wireless-testing/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-03-27 17:11:38.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/b43/main.c	2008-04-01 15:53:41.000000000 +0200
> @@ -3215,6 +3215,13 @@ static int b43_op_set_key(struct ieee802
>  		break;
>  	case ALG_CCMP:
>  		algorithm = B43_SEC_ALGO_AES;
> +		if (dev->dev->id.revision >= 20080401) {
> +			/* Latest devices can do quantum cryptography
> +			 * to encrypt/decrypt the data stream.
> +			 * This is 100% backward compatible with the traditional
> +			 * CCMP algorithm. */
> +			algorithm = B43_SEC_ALGO_QUANTUM;
> +		}
>  		break;
>  	default:
>  		B43_WARN_ON(1);
> @@ -3254,6 +3261,10 @@ static int b43_op_set_key(struct ieee802
>  			b43_hf_write(dev,
>  				     b43_hf_read(dev) & ~B43_HF_USEDEFKEYS);
>  		}
> +		if (algorithm == B43_SEC_ALGO_QUANTUM) {
> +			b43_hf_write(dev, b43_hf_read(dev)
> +				     | B43_HF_QUANTUMCRYPT);
> +		}
>  		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
>  		break;
>  	case DISABLE_KEY: {
>
>   
