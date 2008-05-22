Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.180]:26429 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbYEVWuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 18:50:16 -0400
Received: by el-out-1112.google.com with SMTP id s27so191705ele.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 15:50:15 -0700 (PDT)
Message-ID: <1ba2fa240805221550p774708f9h7aab016a24202cff@mail.gmail.com> (sfid-20080523_005021_859567_F6130BB1)
Date: Fri, 23 May 2008 01:50:13 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Vincent C Jones" <v.jones@networkingunlimited.com>
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies - 2.6.26-rc1 kernel
Cc: linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <egrumbach@gmail.com>
In-Reply-To: <1211495615.4595.14.camel@X61.NetworkingUnlimited.com>
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
	 <1211495615.4595.14.camel@X61.NetworkingUnlimited.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 23, 2008 at 1:33 AM, Vincent C Jones
<v.jones@networkingunlimited.com> wrote:
> On Thu, 2008-05-22 at 19:53 +0300, Tomas Winkler wrote:
>> On Mon, May 12, 2008 at 9:37 PM, Vincent C Jones
>> <v.jones@networkingunlimited.com> wrote:
>> >
>> > On Mon, 2008-05-12 at 19:50 +0300, Tomas Winkler wrote:
>> >
>> >> Meanwhile we've reproduced the wpa_supplicant issue...
>> >>
>> >
>> > That is great news. Let me know when it is time to test again...
>>
>> Please try this one. I've just pasted that in so it's might be
>> white-space-wise broken
>>
>> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>> index 7877d3b..5996e3d 100644
>>   *  *  *
>> Tomas
>
> Tomas,
>
> Applied patch to today's
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> and I can confirm that wpa_supplicant v0.6.3 again works on the A band.
>
> FWIW, however, I still have some issues:
>
> 1 - Roaming from 3com to NetGear takes about 5 minutes before iwlist
> scan sees the A/N channel on the NetGear AP. Roaming from NetGear to
> 3com, however, the 3com AP is seen on the first scan after losing
> contact.

What channel is NG?, what is the beacon period.
We'll soon release a new uCode that should speed up a bit scanning on A band.

> 2 - The NetGear is allegedly 11n, but shows up as standard A (or G) in
> iwconfig et al. Highest data rate listed by iwlist is 54 on A, 48 on G.

wext doesn't report 11n rates and probably never will, it doesn't mean
there is no 11n connection.
Currently I don't have some non crypto interface looking into it.

> 3 - Booting Windows, the 4965 does see the NetGear as 802.11n, so I
> can't blame it on the hardware...
>
No you cant :)

> 4 - I won't guarantee it is not a configuration issue on my part...
> attached is the ".config" file used to compile the kernel.
>
Looks good.

Tomas
