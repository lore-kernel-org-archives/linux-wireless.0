Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:41456 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZINIpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:45:12 -0400
Received: by fxm17 with SMTP id 17so674704fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 01:45:15 -0700 (PDT)
Message-ID: <4AAE0297.20401@gmail.com>
Date: Mon, 14 Sep 2009 10:45:11 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linville@tuxdriver.com, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/4] ath5k: allocate ath5k_hw prior to initializing
 hw
References: <1252917123-11559-1-git-send-email-lrodriguez@atheros.com> <1252917123-11559-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252917123-11559-3-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2009 10:32 AM, Luis R. Rodriguez wrote:
> --- a/drivers/net/wireless/ath/ath.h
> +++ b/drivers/net/wireless/ath/ath.h
> @@ -51,7 +51,7 @@ struct ath_common {
>  	u8 curbssid[ETH_ALEN];
>  	u8 bssidmask[ETH_ALEN];
>  	struct ath_regulatory regulatory;
> -	struct ath_ops *ops;
> +	const struct ath_ops *ops;

If I'm looking correctly, this will emit a warning for ath9k.
