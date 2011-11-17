Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56727 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1KQVIj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 16:08:39 -0500
Received: by yenq3 with SMTP id q3so1633665yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2011 13:08:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20111112T202645-807@post.gmane.org>
References: <CAFtRNNwXdeBfa-mFNyAVALgTxM-wrUthgMLS18VokqOSSiWPqg@mail.gmail.com>
	<1320585006.11133.2.camel@jlt3.sipsolutions.net>
	<CAFtRNNxGd7NSmjNhZboW5VOZ++j=D1E_G6E6RqXLA3Ssuu4XfQ@mail.gmail.com>
	<loom.20111112T202645-807@post.gmane.org>
Date: Thu, 17 Nov 2011 22:59:08 +0200
Message-ID: <CAFtRNNxJjiCtPAyM=KwD+rpXkZXCUgpuSw2BHpaxb6frxBWumA@mail.gmail.com> (sfid-20111117_220842_818501_6C09A1EA)
Subject: Re: 802.11p implementation...
From: Nick Kossifidis <mickflemm@gmail.com>
To: Jan de Jongh <jfcmdejongh@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/11/12 Jan de Jongh <jfcmdejongh@gmail.com>:
> Nick Kossifidis <mickflemm@...> writes:
>
>>
>> 2011/11/6 Johannes Berg <johannes@...>:
>> > On Sun, 2011-11-06 at 02:53 +0200, Nick Kossifidis wrote:
>> >> It seems a group of people have released an 802.11p implementation on
>> >> top of 2.6.31.
>> >>
>> >> http://www.gcdc.net/mainmenu/Home/downloads/Technology
> ...
>> > johannes
>> >
>>
> ...
>
> Hi Nick, Johannes,
>
> First, please note that I haven't checked on recent ath5k support for 802.11p.
> If such support it already present, this mail is quite obsolete :-)...
>
> The Grand Cooperative Driving Challenge succesfully used 802.11p in
> vehicle-to-vehicle communications and vehicle-to-infrastructure communications,
> using a modified ath5k driver (which you found on the gcdc.net site).
> Apart from GCDC, there are many research and commercial projects/products
> (SPITS/FREILOT/...) using patched ath5k drivers for half-clock-rate operation,
> ocb, and access to the 5.9-6.0 GHz frequencies.
> And there are many more to come,.
> Simply because Atheros-based cards are among the few
> (if not the only ones)
> that support 802.11p/5.9GHz operation.
> For GCDC, the patches had their origins in the CVIS project,
> and in work by Eric Koenders of Peek Traffic.
>
> However, the current situation is far from ideal...
> By now, the 11p amendment has been ratified,
> but maintaining 802.11p support for contemparory kernel/compat-wireless combos
> is near to impossible without structural support from ath/ath5k developers.
> The result of this effort, in short, would mean 802.11p operation
> through module parameter and crda/regdb settings only,
> and without the need to (re)compile kernels and/or kernel modules.
> 11p Operation would simply imply some configuration efforts
> on well-known distributions (modules,conf, regdb/crda, iw, and stuff like that)
> out-of-the-box...
> I understand that there are regulatory issues
> (crda, do we want anyone to operate on the ITS frequencies???) involved,
> but we would be very interested in
> structural 11p support in the ath5k driver (and, perhaps ath9k).
> "We" referring to a substantial part of the ITS community.
> If you can arrange substantial commitment to 11p support in ath5k,
> I can mobilize people and funding for
> development/testing/deployment/discussion/feedback.
>
> Let me know what you think of this, best wishes,
>
> Jan de Jongh
> GCDC - Technology Leader
>

ath5k already has half/quarter width channel support, we just don't
have an interface for it yet (we 'll add one through debugfs soon).
What else do you need from the driver and the protocol stack ? From a
quick look at the patches you use, you only want half width channel
support and to disable beacons by setting beacon interval to 0. Is
that all ?

Also your patches on ath5k are missing some parts, I suggest you
update your code or re-base your changes on top of a newer kernel
version to get proper half width support for more cards and more.

Finally if you want to work with upstream developers I suggest you
send your code and comments to linux-wireless instead.


-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
