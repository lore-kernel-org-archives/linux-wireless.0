Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.184]:52530 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbYEVSv4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 14:51:56 -0400
Received: by gv-out-0910.google.com with SMTP id e6so306792gvc.37
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 11:51:54 -0700 (PDT)
Message-ID: <1ba2fa240805221151q2e53b069n6658c6cd7d6f4ba0@mail.gmail.com> (sfid-20080522_205158_769533_B38C2819)
Date: Thu, 22 May 2008 21:51:52 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies - 2.6.26-rc1 kernel
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Vincent C Jones" <v.jones@networkingunlimited.com>,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <egrumbach@gmail.com>
In-Reply-To: <1211481249.28022.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>
	 <1210456110.3787.26.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>
	 <1210474179.3787.31.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805120950mf983e97qac4cdfa2c84b6662@mail.gmail.com>
	 <1210617467.3792.4.camel@X61.DFGI.com>
	 <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com>
	 <1211478969.3698.56.camel@johannes.berg>
	 <1211481249.28022.15.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 22, 2008 at 9:34 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Thu, 2008-05-22 at 19:56 +0200, Johannes Berg wrote:
>> >         memset(&iwe, 0, sizeof(iwe));
>> >         iwe.cmd = SIOCGIWFREQ;
>> > -       iwe.u.freq.m = bss->freq;
>> > -       iwe.u.freq.e = 6;
>> > +       iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
>> > +       iwe.u.freq.e = 0;
>> >         current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
>> >                                           IW_EV_FREQ_LEN);
>> >
>> >         memset(&iwe, 0, sizeof(iwe));
>> >         iwe.cmd = SIOCGIWFREQ;
>> > -       iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
>> > -       iwe.u.freq.e = 0;
>> > +       iwe.u.freq.m = bss->freq;
>> > +       iwe.u.freq.e = 6;
>> >         current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
>> >                                           IW_EV_FREQ_LEN);
>>
>> That doesn't make any sense, can you explain?
>
> Explanation:
>
> wpa_supplicant cannot handle A-band channel #s.  Thus, with the previous
> code, the FREQ+frequency was sent first, and the FREQ+channel was sent
> second.  Sending the FREQ+channel second made the supplicant overwrite
> the value it already parsed from the FREQ+frequency for that BSSID.  But
> since the supplicant can't handle A-band channel #s, you end up with 0.
>
> Reversing the order of these two makes it work, but it's a total hack.
> That may be what's needed right now though until everyone fixes their
> supplicant.  There's overlap on A-band channels 7 - 12 (5035MHz ->
> 5060MHz) with B/G band channel #s.  Obviously WEXT falls over here
> because the band isn't passed.
>
> But what's the best fix to the supplicant?  It could just parse A-band
> channels and where the numbers overlap, assume B/G band.  Or, it could
> be patched to prefer FREQ+frequency over FREQ+channel if it received
> both.  That's probably the best solution.
>
Thanks for clearing this fog.

Actually we've also tried to removing FREQ+channel part and it has
worked. So wpa_supplicant won't get into this dilemma. Although I have
never seen anyone used 7-12 channels in 5.2 band.
My patch just restored the code that was present before it has broken.
>From what you wrote it looks like the problem is rather in wext then
in wpa_supplicant.

I will sent and official patch if some more people confirms it solves
their problem.

Patch that broke it is below so  I guess the bug is in everything form
2.6.25 and up.
'
commit 8318d78a44d49ac1edf2bdec7299de3617c4232e
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Thu Jan 24 19:38:38 2008 +0100

    cfg80211 API for channels/bitrates, mac80211 and driver conversion
'

Tomas
