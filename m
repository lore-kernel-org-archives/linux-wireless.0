Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:52026 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbYIQV6l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 17:58:41 -0400
Received: by py-out-1112.google.com with SMTP id p76so2561919pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2008 14:58:39 -0700 (PDT)
Message-ID: <69e28c910809171458q70763189lde2e2710c64fc70c@mail.gmail.com> (sfid-20080917_235847_516604_3C180009)
Date: Wed, 17 Sep 2008 23:58:39 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iw packaging
Cc: "Davide Pesavento" <davidepesa@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1221688366.7412.13.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1221596962.9262.12.camel@johannes.berg>
	 <1221648205.9262.48.camel@johannes.berg> <48D0E463.70008@le-vert.net>
	 <1221649638.9262.50.camel@johannes.berg>
	 <48D0E5CE.8050401@le-vert.net>
	 <1221650286.9262.57.camel@johannes.berg>
	 <69e28c910809171319r30d763cse24744a198e41f92@mail.gmail.com>
	 <1221683467.7412.6.camel@localhost>
	 <2da21fe50809171446y56cd5b2ctc864650be6030621@mail.gmail.com>
	 <1221688366.7412.13.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 17, 2008 at 11:52 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-09-17 at 23:46 +0200, Davide Pesavento wrote:
>> $ make
>>  GEN  version.h
>>  CC   iw.o
>>  CC   info.o
>> info.c: In function 'print_phy_handler':
>> info.c:108: error: 'NL80211_ATTR_SUPPORTED_IFTYPES' undeclared (first
>> use in this function)
>> info.c:108: error: (Each undeclared identifier is reported only once
>> info.c:108: error: for each function it appears in.)
>> make: *** [info.o] Error 1
>>
>> I guess I have to build iw against >=2.6.27-rcX kernel headers, right?
>
> Actually this one is new in wireless-testing, I have a branch you can
> build against 2.6.27 but it's not very up-to-date.
>
> Any ideas how to handle this are welcome. Should it just ship the header
> file? I'd prefer not to, otoh doing it isn't really harmful because when
> adding a new command clearly you need to edit iw sources.
>
> johannes
>
>

IMO that's the best thing to do - in fact, that's exactly why I
branched. Distros likely won't ship kernel headers that don't match
the kernel binaries and sources. (This is likely why Debian is
shipping my branched version, rather than the official.)

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
