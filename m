Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53900 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab2JEQVl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 12:21:41 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so2008519pbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2012 09:21:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <506ED3D4.7050107@openwrt.org>
References: <1348756862-8788-1-git-send-email-sven@narfation.org>
	<506B0628.6070201@openwrt.org>
	<CAJ-Vmo=bu=j+=z_TAeE3--Sn5oAEbkEG-HDqK=6okR8xmmWpSQ@mail.gmail.com>
	<2629427.e28b8DS3gI@bentobox>
	<506ED3D4.7050107@openwrt.org>
Date: Fri, 5 Oct 2012 09:21:40 -0700
Message-ID: <CAJ-VmonKjxmquSUg99kAtPWVwHH-4zTooF1Xvj9mGUyjWL5pCA@mail.gmail.com> (sfid-20121005_182147_345769_8DF82B7A)
Subject: Re: [ath9k-devel] [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL
 on AR9003
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	lindner_marek@yahoo.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 October 2012 05:34, Felix Fietkau <nbd@openwrt.org> wrote:

> ---
> --- a/drivers/net/wireless/ath/ath9k/ani.c
> +++ b/drivers/net/wireless/ath/ath9k/ani.c
> @@ -307,7 +307,8 @@ void ath9k_ani_reset(struct ath_hw *ah,
>                 if (IS_CHAN_2GHZ(chan)) {
>                         ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
>                                             ATH9K_ANI_FIRSTEP_LEVEL);
> -                       if (AR_SREV_9300_20_OR_LATER(ah))
> +                       if (AR_SREV_9300_20_OR_LATER(ah) &&
> +                           ah->caps.rx_chainmask != 1)
>                                 ah->ani_function |= ATH9K_ANI_MRC_CCK;
>                 } else
>                         ah->ani_function = 0;

Well, is it a RX chainmask thing, or is it a chip thing?

It's totally possible to have an RX chainmask of say 0x2 or 0x4..

Also to figure out which registers triggered the interrupt is likely
going to be a bit .. special. Maybe keep a circular buffer of the last
N register accesses and dump them in time order whenever you get an
interrupt.

Adrian
