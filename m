Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:55841 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbZALQZx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 11:25:53 -0500
Received: by wf-out-1314.google.com with SMTP id 27so11432934wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2009 08:25:51 -0800 (PST)
Message-ID: <40f31dec0901120825i6ec6af4bq39e7e1be8459e846@mail.gmail.com> (sfid-20090112_172557_097490_7EF1BB9F)
Date: Mon, 12 Jan 2009 18:25:51 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Helmut Schaa" <helmut.schaa@googlemail.com>
Subject: Re: [PATCH] ath5k: discard 11g caps if reported by an ar5211 eeprom
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com
In-Reply-To: <200901121304.07360.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200901121304.07360.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/12 Helmut Schaa <helmut.schaa@googlemail.com>:
> At least one ar5211 card (GIGABYTE GN-WLMA101, 168c:0012 subsystem
> 1458:e800) reports itself as 11g capable which seems to be a bug in the
> eeprom. initvals.c assumes that ar5211 is only 11b capable and thus refuses
> to initialize this card. Hence this patch changes the probing for 11g
> capabilities to discard 11g capabilities for ar5211 cards which allows this
> specific card to work fine in 11b and 11a modes.
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
>
> Is anybody aware of 11g-capable ar5211 cards which would be limited by
> this patch?
>
> diff --git a/drivers/net/wireless/ath5k/caps.c b/drivers/net/wireless/ath5k/caps.c
> index 150f5ed..367a6c7 100644
> --- a/drivers/net/wireless/ath5k/caps.c
> +++ b/drivers/net/wireless/ath5k/caps.c
> @@ -85,7 +85,8 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
>                /* Enable  802.11b if a 2GHz capable radio (2111/5112) is
>                 * connected */
>                if (AR5K_EEPROM_HDR_11B(ee_header) ||
> -                               AR5K_EEPROM_HDR_11G(ee_header)) {
> +                   (AR5K_EEPROM_HDR_11G(ee_header) &&
> +                    ah->ah_version != AR5K_AR5211)) {
>                        /* 2312 */
>                        ah->ah_capabilities.cap_range.range_2ghz_min = 2412;
>                        ah->ah_capabilities.cap_range.range_2ghz_max = 2732;
> @@ -94,7 +95,8 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
>                                __set_bit(AR5K_MODE_11B,
>                                                ah->ah_capabilities.cap_mode);
>
> -                       if (AR5K_EEPROM_HDR_11G(ee_header))
> +                       if (AR5K_EEPROM_HDR_11G(ee_header) &&
> +                           ah->ah_version != AR5K_AR5211)
>                                __set_bit(AR5K_MODE_11G,
>                                                ah->ah_capabilities.cap_mode);
>                }
>

This should be O.K. for now but i think AR5211 supports the so called
"pureg" mode which means ofdm only g (no cck headers etc). It seems
radio (RF5111) supports g mode (it can be found on AR5212 abg cards)
but baseband doesn't support dynamic cck/ofdm switching. This bit on
your eeprom might indicate the pureg capability. Since we don't handle
this yet it's ok to skip it and use only b mode.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
