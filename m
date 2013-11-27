Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45884 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab3K0QAc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 11:00:32 -0500
Message-ID: <52961714.20909@openwrt.org> (sfid-20131127_170034_954081_4EF5E810)
Date: Wed, 27 Nov 2013 17:00:20 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	Antonio Quartulli <antonio@meshcoding.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k pending patches
References: <1385547828-4330-1-git-send-email-sujith@msujith.org>	<21141.51790.303263.385517@gargle.gargle.HOWL>	<5295EB1D.1050604@meshcoding.com> <21142.4319.977971.553792@gargle.gargle.HOWL>
In-Reply-To: <21142.4319.977971.553792@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-11-27 16:33, Sujith Manoharan wrote:
> Antonio Quartulli wrote:
>> What does this ALWAYS_PERFORM_KEY_SEARCH bit do? Is it set within the
>> initvalues?
> 
> Here is a patch to set ALWAYS_PERFORM_KEY_SEARCH for AR9300 2.2.
> Since AR9331, AR9340 and AR9580 use the same array, it applies for
> them too.
> 
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
> index 1553395..819ecf3 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
> @@ -303,7 +303,7 @@ static const u32 ar9300_2p2_mac_postamble[][5] = {
>  	{0x000010b0, 0x00000e60, 0x00001cc0, 0x00007c70, 0x00003e38},
>  	{0x00008014, 0x03e803e8, 0x07d007d0, 0x10801600, 0x08400b00},
>  	{0x0000801c, 0x128d8027, 0x128d804f, 0x12e00057, 0x12e0002b},
> -	{0x00008120, 0x08f04800, 0x08f04800, 0x08f04810, 0x08f04810},
> +	{0x00008120, 0x18f04800, 0x18f04800, 0x18f04810, 0x18f04810},
>  	{0x000081d0, 0x00003210, 0x00003210, 0x0000320a, 0x0000320a},
>  	{0x00008318, 0x00003e80, 0x00007d00, 0x00006880, 0x00003440},
>  };
There's no need to patch the initvals for this issue at all. ath9k has
enabled AR_PCU_ALWAYS_PERFORM_KEYSEARCH via ah->misc_mode for a long
time now.

- Felix

