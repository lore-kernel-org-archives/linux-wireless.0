Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36693 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbYL2ElR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 23:41:17 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2008 20:41:17 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18776.21554.302227.967726@gargle.gargle.HOWL> (sfid-20081229_054120_447958_2EFD0F54)
Date: Mon, 29 Dec 2008 10:08:10 +0530
To: Luis Rodriguez <lrodriguez@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v3 07/16] ath9k: use ieee80211_conf on
 ath9k_hw_iscal_supported()
In-Reply-To: <1230076731-22946-8-git-send-email-lrodriguez@atheros.com>
References: <1230076731-22946-1-git-send-email-lrodriguez@atheros.com>
	<1230076731-22946-2-git-send-email-lrodriguez@atheros.com>
	<1230076731-22946-3-git-send-email-lrodriguez@atheros.com>
	<1230076731-22946-4-git-send-email-lrodriguez@atheros.com>
	<1230076731-22946-5-git-send-email-lrodriguez@atheros.com>
	<1230076731-22946-6-git-send-email-lrodriguez@atheros.com>
	<1230076731-22946-7-git-send-email-lrodriguez@atheros.com>
	<1230076731-22946-8-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis Rodriguez wrote:
> -       case IQ_MISMATCH_CAL:
> -               if (!IS_CHAN_B(chan))
> -                       retval = true;
> -               break;
> +       case IQ_MISMATCH_CAL: /* Both 2 GHz and 5 GHz support OFDM */
> +               return true;
>         case ADC_GAIN_CAL:
>         case ADC_DC_CAL:
> -               if (!IS_CHAN_B(chan)
> -                   && !(IS_CHAN_2GHZ(chan) && IS_CHAN_HT20(chan)))
> -                       retval = true;
> +               if (conf->channel->band == IEEE80211_BAND_5GHZ &&
> +                 conf_is_ht20(conf))
> +                       return true;
>                 break;
>         }

Why are the IS_CHAN_B() checks removed ?

Sujith
