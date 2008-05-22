Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.185]:48733 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190AbYEVR6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 13:58:55 -0400
Received: by gv-out-0910.google.com with SMTP id e6so249876gvc.37
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 10:58:53 -0700 (PDT)
Message-ID: <1ba2fa240805221058m23650d83pdb930f8d2cb6c3d9@mail.gmail.com> (sfid-20080522_195908_795382_D298D3A6)
Date: Thu, 22 May 2008 20:58:52 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies - 2.6.26-rc1 kernel
Cc: "Vincent C Jones" <v.jones@networkingunlimited.com>,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <egrumbach@gmail.com>
In-Reply-To: <1211478969.3698.56.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
	 <1210434402.3787.7.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>
	 <1210456110.3787.26.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>
	 <1210474179.3787.31.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805120950mf983e97qac4cdfa2c84b6662@mail.gmail.com>
	 <1210617467.3792.4.camel@X61.DFGI.com>
	 <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com>
	 <1211478969.3698.56.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 22, 2008 at 8:56 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>>         memset(&iwe, 0, sizeof(iwe));
>>         iwe.cmd = SIOCGIWFREQ;
>> -       iwe.u.freq.m = bss->freq;
>> -       iwe.u.freq.e = 6;
>> +       iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
>> +       iwe.u.freq.e = 0;
>>         current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
>>                                           IW_EV_FREQ_LEN);
>>
>>         memset(&iwe, 0, sizeof(iwe));
>>         iwe.cmd = SIOCGIWFREQ;
>> -       iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
>> -       iwe.u.freq.e = 0;
>> +       iwe.u.freq.m = bss->freq;
>> +       iwe.u.freq.e = 6;
>>         current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
>>                                           IW_EV_FREQ_LEN);
>
> That doesn't make any sense, can you explain?
>
Your patch switched order of channel and freq in the scan
It looks like wpa_supplicant cannot handle it

Tomas
