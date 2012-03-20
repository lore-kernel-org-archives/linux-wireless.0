Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35666 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758425Ab2CTWFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 18:05:35 -0400
Received: by eekc41 with SMTP id c41so192310eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2012 15:05:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1332280377-3027-1-git-send-email-stas.yakovlev@gmail.com>
References: <1332280377-3027-1-git-send-email-stas.yakovlev@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 21 Mar 2012 09:05:13 +1100
Message-ID: <CAGRGNgV_P6XjHmF+44sKqyX1P6oNq5vsb4XWT7L173OGk_Oy+g@mail.gmail.com> (sfid-20120320_230538_712612_07415918)
Subject: Re: [PATCH] net/wireless: ipw2x00: fix a typo in wiphy struct initilization
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislav,

On Wed, Mar 21, 2012 at 08:52, Stanislav Yakovlev
<stas.yakovlev@gmail.com> wrote:
> Fix comment as well.
>
> Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
> ---
> diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
> index 4fcdac6..2b02257 100644
> --- a/drivers/net/wireless/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
> @@ -11507,9 +11507,9 @@ static int ipw_wdev_init(struct net_device *dev)
>                        rc = -ENOMEM;
>                        goto out;
>                }
> -               /* translate geo->bg to a_band.channels */
> +               /* translate geo->a to a_band.channels */
>                for (i = 0; i < geo->a_channels; i++) {
> -                       a_band->channels[i].band = IEEE80211_BAND_2GHZ;
> +                       a_band->channels[i].band = IEEE80211_BAND_5GHZ;

Looks good.

I'm surprised that nobody noticed this before, but someone did mention
that the 2x00 802.11a parts were extremely rare.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
