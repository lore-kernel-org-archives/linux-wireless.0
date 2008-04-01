Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail184.messagelabs.com ([193.109.254.3]:61207 "HELO
	mail184.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756756AbYDAOub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 10:50:31 -0400
Subject: Re: [PATCH] b43: Enable quantum cryptography support
From: Mark Hagger <mark.hagger@m-spatial.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <200804011613.06749.mb@bu3sch.de>
References: <200804011613.06749.mb@bu3sch.de>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 15:50:19 +0100
Message-Id: <1207061419.2879.298.camel@giga.cambridge.m-spatial.com> (sfid-20080401_155038_861201_C7B5181E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Excellent, did you manage to implement the time travel support mode as
well?

Mark



On Tue, 2008-04-01 at 16:13 +0200, Michael Buesch wrote:
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


________________________________________________________________________
This email has been scanned for all known viruses by the MessageLabs SkyScan service.
