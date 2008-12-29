Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46011 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbYL2EkK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 23:40:10 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2008 20:40:10 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18776.21485.750323.652519@gargle.gargle.HOWL> (sfid-20081229_054015_225378_C3C553AE)
Date: Mon, 29 Dec 2008 10:07:01 +0530
To: Luis Rodriguez <lrodriguez@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v3 02/16] ath9k: use hw->conf on ath_setcurmode()
In-Reply-To: <1230076731-22946-3-git-send-email-lrodriguez@atheros.com>
References: <1230076731-22946-1-git-send-email-lrodriguez@atheros.com>
	<1230076731-22946-2-git-send-email-lrodriguez@atheros.com>
	<1230076731-22946-3-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis Rodriguez wrote:
> +       switch (conf->channel->band) {
> +       case IEEE80211_BAND_2GHZ:
> +               if (conf_is_ht20(conf))
> +                       sc->cur_rate_table =
> +                         sc->hw_rate_table[ATH9K_MODE_11NG_HT20];
> +               else if (conf_is_ht40_minus(conf))
> +                       sc->cur_rate_table =
> +                         sc->hw_rate_table[ATH9K_MODE_11NG_HT40MINUS];
> +               else if (conf_is_ht40_plus(conf))
> +                       sc->cur_rate_table =
> +                         sc->hw_rate_table[ATH9K_MODE_11NG_HT40PLUS];
> +               else {
> +                       sc->sc_protrix = 1;
> +                       sc->cur_rate_table =
> +                         sc->hw_rate_table[ATH9K_MODE_11G];
> +               }
> +               break;
> +       case IEEE80211_BAND_5GHZ:
> +               if (conf_is_ht20(conf))
> +                       sc->cur_rate_table =
> +                         sc->hw_rate_table[ATH9K_MODE_11NA_HT20];
> +               else if (conf_is_ht40_minus(conf))
> +                       sc->cur_rate_table =
> +                         sc->hw_rate_table[ATH9K_MODE_11NA_HT40MINUS];
> +               else if (conf_is_ht40_plus(conf))
> +                       sc->cur_rate_table =
> +                         sc->hw_rate_table[ATH9K_MODE_11NA_HT40PLUS];
> +               else
> +                       sc->cur_rate_table = sc->hw_rate_table[ATH9K_MODE_11A];
> +               break;
> +       default:
> +               break;
> +       }
>  }

We don't have separate rate tables for ht20, ht40+, ht40-.
Setting cur_rate_table just once using conf_is_ht() to any HT mode would suffice.

Sujith
