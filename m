Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:64904 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbYJDWa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 18:30:26 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1470650fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 04 Oct 2008 15:30:24 -0700 (PDT)
Message-ID: <3ace41890810041530u20e682aeu908d29015f0c9c40@mail.gmail.com> (sfid-20081005_003031_191660_A7134235)
Date: Sat, 4 Oct 2008 23:30:24 +0100
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>
Subject: Re: Trendnet TEW-424UB now Realtek 8187B
Cc: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, keithl@keithl.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Daniel Drake" <dsd@gentoo.org>
In-Reply-To: <200810041655.13816.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081004011510.GA10015@gate.kl-ic.com>
	 <1223110250.24551.72.camel@johannes.berg>
	 <69e28c910810040607x392a5ddfra8d257b0ff3b9c6e@mail.gmail.com>
	 <200810041655.13816.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 4, 2008 at 8:55 PM, Herton Ronaldo Krzesinski
<herton@mandriva.com.br> wrote:
> On Saturday 04 October 2008 10:07:08 Stefanik G=E1bor wrote:
>> On Sat, Oct 4, 2008 at 10:50 AM, Johannes Berg
>>
>> <johannes@sipsolutions.net> wrote:
>> > On Sat, 2008-10-04 at 01:47 -0700, Luis R. Rodriguez wrote:
>> >> On Sat, Oct 4, 2008 at 1:32 AM, Johannes Berg <johannes@sipsoluti=
ons.net>
> wrote:
>> >> > On Fri, 2008-10-03 at 18:15 -0700, Keith Lofstrom wrote:
>> >>
>> >> What Realtek driver? Just FYI rtl8187 does *not* claim the RTL818=
7B.
>> >> See:
>> >>
>> >> http://wireless.kernel.org/en/users/Drivers/rtl8187
>> >
>> > Oh, I thought there was a version now that did.
>> >
>> > johannes
>>
>> Hin-Tak Leung added support for RTL8187B a while ago, although it's
>> still a bit buggy. Likely someone forgot to update the rtl8187 page =
on
>> the wiki. CCing Hin-Tak and Herton.
>
> I created an account there now and did a minimal update on the page, =
please
> take a look. There are some things we need to improve in the driver, =
we
> received also an updated driver and a minimal datasheet but unfortuna=
tely
> from my part I didn't had much success and time in playing/learning t=
o
> improve its support.

Yes, rtl8187B is in recent kernel; it is still a bit buggy but the two
external links - cuervo's link to an old version of the vendor driver
ported forward and there is a newer vendor driver, but neither
supports the latest kernel - and that's not entirely bug-free either;
there has not been much activities at the sourceforge link, so that's
really just for reference.

I would say add these two pieces of information:

- it is known that rate-control doesn't quite work with either rtl8187
or rtl8187b. "iwconfig rate <somerate> fixed" may work better under
some circumstances.

- we don't support rtl8187B with a product id 0x8198 (in some very new
toshiba laptops) yet. It seems the vendor driver works to extent, but
report against the community driver (by adding the id) has been
inconclusive.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
