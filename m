Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63536 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab0LXQqC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Dec 2010 11:46:02 -0500
Received: by fxm20 with SMTP id 20so7997232fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Dec 2010 08:46:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101224074410.16337.90008.stgit@localhost6.localdomain6>
References: <20101224074410.16337.90008.stgit@localhost6.localdomain6>
Date: Fri, 24 Dec 2010 16:46:00 +0000
Message-ID: <AANLkTi=R58EGLrsT5sTk7JTqWvaeJ5caytHMt3VCSOki@mail.gmail.com>
Subject: Re: [PATCH RFC] mac80211: Extend channel to frequency mapping for 802.11j
From: Dave Kilroy <kilroyd@googlemail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 24, 2010 at 7:44 AM, Bruno Randolf <br1@einfach.org> wrote:
> Extend channel to frequency mapping for 802.11j Japan 4.9GHz band, according to
> IEEE802.11 section 17.3.8.3.2 and Annex J. Because there are now overlapping
> channel numbers in the 2GHz and 5GHz band we can't map from channel to
> frequency without knowing the band. This is no problem as in most contexts we
> know the band. In places where we don't know the band (and WEXT compatibility)
> we assume the 2GHz band for channels below 14.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
> -int ieee80211_channel_to_frequency(int chan)
> +int ieee80211_channel_to_frequency(int chan, enum ieee80211_band band)
>  {
> -       if (chan < 14)
> -               return 2407 + chan * 5;
> -
> -       if (chan == 14)
> -               return 2484;
> -
> -       /* FIXME: 802.11j 17.3.8.3.2 */
> -       return (chan + 1000) * 5;
> +       /* see 802.11 17.3.8.3.2 and Annex J
> +        * there are overlapping channel numbers in 5GHz and 2GHz bands */
> +       if (band == IEEE80211_BAND_5GHZ) {
> +               if (chan >= 182 && chan <= 196)
> +                       return 4000 + chan * 5;
> +               else
> +                       return 5000 + chan * 5;
> +       } else { /* IEEE80211_BAND_2GHZ */
> +               if (chan == 14)
> +                       return 2484;
> +               else if (chan < 14)
> +                       return 2407 + chan * 5;
> +               else
> +                       return 0; /* not supported */
> +       }
>  }
>  EXPORT_SYMBOL(ieee80211_channel_to_frequency);
>
>  int ieee80211_frequency_to_channel(int freq)
>  {
> +       /* see 802.11 17.3.8.3.2 and Annex J */
>        if (freq == 2484)
>                return 14;
> -
> -       if (freq < 2484)
> +       else if (freq < 2484)
>                return (freq - 2407) / 5;
> -
> -       /* FIXME: 802.11j 17.3.8.3.2 */
> -       return freq/5 - 1000;
> +       else if (freq >= 4910 && freq <= 4980)
> +               return (freq - 4000) / 5;
> +       else
> +               return (freq - 5000) / 5;
>  }
>  EXPORT_SYMBOL(ieee80211_frequency_to_channel);

You don't have to use them, but there are a few channel/frequency
conversion routines in include/ieee80211.h which could be reused in
these functions.


Regards,

Dave.
