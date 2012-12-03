Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:61244 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2LCXAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 18:00:55 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so2769124lag.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2012 15:00:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354569690-23559-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1354569690-23559-1-git-send-email-siwu@hrz.tu-chemnitz.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 4 Dec 2012 10:00:33 +1100
Message-ID: <CAGRGNgXqQAnUK7_nKkwVpn1OyVMb2B8Dykbjr2X=6AJTa5OJZg@mail.gmail.com> (sfid-20121204_000103_668138_06203B03)
Subject: Re: [PATCH] mac80211: adapt slot time in IBSS mode
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Simon,

On Tue, Dec 4, 2012 at 8:21 AM, Simon Wunderlich
<simon.wunderlich@s2003.tu-chemnitz.de> wrote:
> In 5GHz/802.11a, we are allowed to use short slot times. Doing this
> may increases performance by 20% for legacy connections (54 MBit/s).
> I can confirm this in my tests (27% more throughput using iperf), and
> also have a small positive effect (5% more throughput) for HT rates,
> tested on 1 stream.
>
> Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
> ---
>  net/mac80211/ibss.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index fa862b2..1a5d29c 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -201,6 +201,19 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>         bss_change |= BSS_CHANGED_BASIC_RATES;
>         bss_change |= BSS_CHANGED_HT;
>         bss_change |= BSS_CHANGED_IBSS;
> +
> +       /* In 5 GHz/802.11a, we can always use short slot time.
> +        * (IEEE 802.11-2012 18.3.8.7)
> +        *
> +        * In 2.4GHz, we must always use long slots in IBSS for compatibility
> +        * reasons.
> +        * (IEEE 802.11-2012 19.4.5)
> +        *
> +        * HT follows these specifications (IEEE 802.11-2012 20.3.18)
> +        */
> +       sdata->vif.bss_conf.use_short_slot = chan->band == IEEE80211_BAND_5GHZ;
> +       bss_change |= BSS_CHANGED_ERP_SLOT;
> +

I don't know if this is done elsewhere, but this code doesn't match
the comment - there is no test for IBSS mode.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
