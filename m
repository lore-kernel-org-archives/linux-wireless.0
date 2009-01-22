Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:43817 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbZAVOqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 09:46:00 -0500
Received: by ewy13 with SMTP id 13so2541229ewy.13
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 06:45:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090122141734.GA3646@tuxdriver.com>
References: <200901151734.46144.gbburkhardt@verizon.net>
	 <200901202238.08756.gbburkhardt@verizon.net>
	 <20090121151435.GB3643@tuxdriver.com>
	 <69e28c910901211022j7f9c67dfv6392ce043dcff522@mail.gmail.com>
	 <20090121191141.GA14710@tuxdriver.com>
	 <69e28c910901211133n25c1a151nc9ca7172a9de7d3a@mail.gmail.com>
	 <40f31dec0901212032j65371fc6j5fcc1952f841d2ef@mail.gmail.com>
	 <20090122134958.GA27560@tuxdriver.com>
	 <1232633075.4224.6.camel@johannes.local>
	 <20090122141734.GA3646@tuxdriver.com>
Date: Thu, 22 Jan 2009 15:45:58 +0100
Message-ID: <69e28c910901220645l66b76875jbbf1cc74afe17aac@mail.gmail.com> (sfid-20090122_154617_157334_1D4A285A)
Subject: Re: poor performance with ath5k; reverting to ath_pci
From: =?ISO-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Glenn Burkhardt <gbburkhardt@verizon.net>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 22, 2009 at 3:17 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Thu, Jan 22, 2009 at 03:04:35PM +0100, Johannes Berg wrote:
>> On Thu, 2009-01-22 at 08:49 -0500, John W. Linville wrote:
>> > On Thu, Jan 22, 2009 at 06:32:55AM +0200, Nick Kossifidis wrote:
>> > > 2009/1/21 Stefanik G=E1bor <netrolller.3d@gmail.com>:
>> > > >
>> > > > I think EMBEDDED is for options that replace full-featured Lin=
ux
>> > > > components with dumbed-down, "low-profile" equivalents (like S=
LOB) -
>> > > > PID vs. minstrel is more like SLAB vs. SLUB.
>> > > >
>> > > > G=E1bor
>> > > >
>> > >
>> > > Minstrell performs very well even on embedded devices, i don't t=
hink
>> > > it's that heavy compared to pid.
>> >
>> > I think his point was that people should be able to select multipl=
e
>> > algorithms without having to select EMBEDDED.
>>
>> The reason it was originally under EMBEDDED is that this allows you =
to
>> turn off _all_ algorithms, and that breaks, but might be desirable i=
f
>> you have a system where you know you're using iwlagn or ath9k only w=
hich
>> have their own algorithms.
>
> I see.  But currently it limits you to only one generic algorithm, th=
e
> one chosen as the default.  I don't think that was really the intent?
>

I think RC_NONE should depend on embedded, but not the chooser itself.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
