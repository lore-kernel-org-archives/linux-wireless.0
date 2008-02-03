Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:50906 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091AbYBCBj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 20:39:58 -0500
Received: by an-out-0708.google.com with SMTP id d31so401889and.103
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2008 17:39:58 -0800 (PST)
Message-ID: <40f31dec0802021739m2caf869av35a0750f9605c408@mail.gmail.com> (sfid-20080203_014011_022813_2B7319DD)
Date: Sun, 3 Feb 2008 03:39:58 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH] wireless: Fix WARN_ON() with ieee802.11b
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <200802022353.10286.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200802022353.10286.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/3, Ivo van Doorn <ivdoorn@gmail.com>:
> When the driver registers a IEEE80211_BAND_2GHZ band,
> it can either be 802.11b or 802.11g. But when 802.11b rates
> are registered "want" will be 3 (since 4 rates are being registered,
> and each of those 4 rates will decrease "want").
> Since this is a correct situation, there is no need to trigger
> a WARN_ON() for this.
>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
>
> ---
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 0dcccbf..5304c62 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -80,7 +80,7 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
>                                 sband->bitrates[i].flags |=
>                                         IEEE80211_RATE_ERP_G;
>                 }
> -               WARN_ON(want != 0 && want != 6);
> +               WARN_ON(want != 0 && want != 3 && want != 6);
>                 break;
>         case IEEE80211_NUM_BANDS:
>                 WARN_ON(1);

Had the same problem when registering an AR5211 card (a/b only), this
patch fixes it ;-)

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
