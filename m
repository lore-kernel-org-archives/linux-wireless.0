Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672AbYEVSWx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 14:22:53 -0400
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies -
	2.6.26-rc1 kernel
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Vincent C Jones <v.jones@networkingunlimited.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <egrumbach@gmail.com>
In-Reply-To: <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com>
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805091712gccaec9cibdab621e8d1c9ba7@mail.gmail.com>
	 <1210430367.3778.9.camel@X61.NetworkingUnlimited.com>
	 <1210434402.3787.7.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>
	 <1210456110.3787.26.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>
	 <1210474179.3787.31.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805120950mf983e97qac4cdfa2c84b6662@mail.gmail.com>
	 <1210617467.3792.4.camel@X61.DFGI.com>
	 <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 22 May 2008 14:22:59 -0400
Message-Id: <1211480579.28022.5.camel@localhost.localdomain> (sfid-20080522_202259_554507_FBCF2252)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-05-22 at 19:53 +0300, Tomas Winkler wrote:
> On Mon, May 12, 2008 at 9:37 PM, Vincent C Jones
> <v.jones@networkingunlimited.com> wrote:
> >
> > On Mon, 2008-05-12 at 19:50 +0300, Tomas Winkler wrote:
> >
> >> Meanwhile we've reproduced the wpa_supplicant issue...
> >>
> >
> > That is great news. Let me know when it is time to test again...
> 
> Please try this one. I've just pasted that in so it's might be
> white-space-wise broken
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 7877d3b..5996e3d 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -4080,17 +4080,18 @@ ieee80211_sta_scan_result(struct net_device *dev,
>                                                   IW_EV_UINT_LEN);
>         }
> 
> +
>         memset(&iwe, 0, sizeof(iwe));
>         iwe.cmd = SIOCGIWFREQ;
> -       iwe.u.freq.m = bss->freq;
> -       iwe.u.freq.e = 6;
> +       iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
> +       iwe.u.freq.e = 0;
>         current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
>                                           IW_EV_FREQ_LEN);
> 
>         memset(&iwe, 0, sizeof(iwe));
>         iwe.cmd = SIOCGIWFREQ;
> -       iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
> -       iwe.u.freq.e = 0;
> +       iwe.u.freq.m = bss->freq;
> +       iwe.u.freq.e = 6;
>         current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
>                                           IW_EV_FREQ_LEN);

Wait a minute; what's mac80211 sending _two_ FREQ events for?  That's
not right.

Dan


