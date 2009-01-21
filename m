Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:14939 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZAUTdE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 14:33:04 -0500
Received: by ug-out-1314.google.com with SMTP id 39so400663ugf.37
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2009 11:33:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090121191141.GA14710@tuxdriver.com>
References: <200901140003.31693.gbburkhardt@verizon.net>
	 <200901151734.46144.gbburkhardt@verizon.net>
	 <b6c5339f0901160733u433b1154sfb8b5662c4fe991c@mail.gmail.com>
	 <200901202238.08756.gbburkhardt@verizon.net>
	 <20090121151435.GB3643@tuxdriver.com>
	 <69e28c910901211022j7f9c67dfv6392ce043dcff522@mail.gmail.com>
	 <20090121191141.GA14710@tuxdriver.com>
Date: Wed, 21 Jan 2009 20:33:01 +0100
Message-ID: <69e28c910901211133n25c1a151nc9ca7172a9de7d3a@mail.gmail.com> (sfid-20090121_203307_644492_54D42799)
Subject: Re: poor performance with ath5k; reverting to ath_pci
From: =?ISO-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Glenn Burkhardt <gbburkhardt@verizon.net>,
	Bob Copeland <me@bobcopeland.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 21, 2009 at 8:11 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Jan 21, 2009 at 07:22:14PM +0100, Stefanik G=E1bor wrote:
>> On Wed, Jan 21, 2009 at 4:14 PM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>> > On Tue, Jan 20, 2009 at 10:38:08PM -0500, Glenn Burkhardt wrote:
>> >> On Friday 16 January 2009 10:33:13 Bob Copeland wrote:
>> >> > On Thu, Jan 15, 2009 at 5:34 PM, Glenn Burkhardt
>> >> >
>> >> > <gbburkhardt@verizon.net> wrote:
>> >> > > ath5k_pci 0000:00:07.0: PCI INT A -> GSI 18 (level, low) -> I=
RQ 18
>> >> > > ath5k_pci 0000:00:07.0: registered as 'phy0'
>> >> > > phy0: Selected rate control algorithm 'pid'
>> >> >
>> >> > Can you change the rate control algorithm to minstrel and retry=
?
>> >>
>> >> I built a 2.6.28.1-9 kernel to get the minstrel code for ath5k.  =
The
>> >> kernel for Suse 11.1 is 2.6.27.7-9.  But that means that more cou=
ld have
>> >> changed besides the rate control code.
>> >>
>> >> It looks like minstrel and pid give about the same result, a bit =
worse that
>> >> the ath_pci driver right now.  Performance seems to vary from day=
 to day.
>> >> I'll experiment some more, and switch transmission channels.  I'm=
 not getting
>> >> the really poor performance with ath5k right now.
>> >>
>> >> I haven't looked yet - is there a way to switch to 'pid' rate con=
trol without
>> >> rebuilding the kernel?
>> >
>> > If you configure your kernel to include multiple rate control
>> > algorithms then you can use the 'ieee80211_default_rc_algo' module
>> > option for mac80211.  Of course, changing that only works if you
>> > rmmod/insmod mac80211.
>> >
>> > John
>>
>> Judging from this, is it really a good idea to hide pid behind EMBED=
DED?
>
> I've been wondering about that myself.  I'm inclined to think no.
>
> John

I think EMBEDDED is for options that replace full-featured Linux
components with dumbed-down, "low-profile" equivalents (like SLOB) -
PID vs. minstrel is more like SLAB vs. SLUB.

G=E1bor

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
