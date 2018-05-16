Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47830 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752309AbeEPMgd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 08:36:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Pkshih <pkshih@realtek.com>
Cc: "briselec\@gmail.com" <briselec@gmail.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "chaitanya.mgit\@gmail.com" <chaitanya.mgit@gmail.com>
Subject: Re: [PATCH v3 00/19] rtlwifi: halmac: Add new module halmac
References: <20180425020820.6141-1-pkshih@realtek.com>
        <87lgdbagb2.fsf@kamboji.qca.qualcomm.com>
        <5B2DA6FDDF928F4E855344EE0A5C39D13BEBF231@RTITMBSV07.realtek.com.tw>
        <20180427224156.GA18163@thinktank.home.org>
        <5B2DA6FDDF928F4E855344EE0A5C39D13BEBFD30@RTITMBSV07.realtek.com.tw>
        <CABPxzYKfZVA8RTADEG5TCu0SXRSVEGWEn+Ym6AkMuFzHC5iSVg@mail.gmail.com>
        <1526371717.12375.8.camel@realtek.com>
Date: Wed, 16 May 2018 15:36:26 +0300
In-Reply-To: <1526371717.12375.8.camel@realtek.com> (pkshih@realtek.com's
        message of "Tue, 15 May 2018 08:08:43 +0000")
Message-ID: <871sebkcad.fsf@codeaurora.org> (sfid-20180516_143647_021036_44C40949)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pkshih <pkshih@realtek.com> writes:

> On Mon, 2018-04-30 at 14:03 +0530, Krishna Chaitanya wrote:
>> On Mon, Apr 30, 2018 at 8:10 AM, Pkshih <pkshih@realtek.com> wrote:
>> >
>> >
>> > > -----Original Message-----
>> > > From: Barry Day [mailto:briselec@gmail.com]
>> > > Sent: Saturday, April 28, 2018 6:42 AM
>> > > To: Pkshih
>> > > Cc: Kalle Valo; Larry.Finger@lwfinger.net; linux-wireless@vger.kerne=
l.org
>> > > Subject: Re: [PATCH v3 00/19] rtlwifi: halmac: Add new module halmac
>> > >
>> > > On Fri, Apr 27, 2018 at 05:44:16AM +0000, Pkshih wrote:
>> > > >
>> > > > The registers reside in driver causes error frequently, because MA=
C register
>> > > > is maintained by Realtek's MAC team so they create this module to =
avoid mistakes.
>> > > > Another benefit is to make it possible to become a thin driver, be=
cause many
>> > > > common functions are provided, so duplicate code will be reduced.
>> > >
>> > > How is it possible to create a thin driver by adding lots more code =
and layers
>> > > of indirection ??? and writing it in a way that it won't compile wit=
hout the
>> > > code for every type of bus interface even though most modules only u=
se one ?
>> > >
>> > As I mentioned in first paragraph "(I use 'driver' in this mail indica=
tes part of
>> > rtlwifi excluded from this module.)". If this module was seen as a 'li=
b', rtl8822be
>> > would be a "thin driver". For bus interface code, I need to add a way =
to compile
>> > type of bus interface according to selected chip.
>> >
>> > > It's a horrible pile of garbage slapped together by an inexperienced
>> > > programmer. Its a major deterrent for anyone looking at working on o=
ne of
>> > > the latest realtek drivers.
>> > >
>> > This module is designed to support multiple OS including Windows and L=
inux, and
>> > many products have used this module and worked well. We hope Linux use=
r can also
>> > use Realtek's WiFi without additional installation if driver was built.
>> > In order to submit this module to kernel upstream, we take a lot of ef=
fort
>> > to fit Linux coding conventions (e.g. coding style), and explicit
>> > suggestions will be helpful for us to continuously improve this module.
>>=C2=A0
>> IMHO, this is a common use case for most organizations. I understand
>> that Linux cannot
>> accommodate other OSes requirements but is there an approved/recommended=
 way
>> to upstream an OS agnostic driver? Agnostic drivers are generally
>> bulkier compared to
>> Linux-only drivers and also code organization is also different (to
>> handle other OSes).
>>=C2=A0
>
> Hi Kalle,
>
> The state of this patchset was changed to RFC in patchwork, and I look at=
 RFC's
> meaning in wireless wiki. Do you expect that I will send v4?

Yes, I was expecting that you will submit v4 with proper documentation.
I was supposed to send an email but forgot, sorry.

> If so, what do I need to fix in v4? Or, you need more description
> about this module, please let me know.=C2=A0

The biggest problem is that rtlwifi patches are way too big and which I
don't think are ready for upstream, most of the time code quality is
closer to the infamous "vendor drivers". This is causing me too much
burden, even just reviewing and providing initial comments to rtlwifi
patches take too much of my time. For example, I still haven't been able
to check the rtlwifi btcoex patches from a month ago.

In principle I can use a minute or two per patch, anything longer than
that and I can't keep up with the incoming patch flow. And with huge
rtlwifi patchsets I usually need something more like an hour than few
minutes.

I have said this also before, but more and more I'm thinking that
rtlwifi is not really a proper upstream driver. I think staging would be
a much better place for it and maybe a proper upstream realtek driver
would be something based on rtl8xxxu? I dunno.

But we really need to find a solution for this as the current way with
rtlwifi patches won't work in the long run.

--=20
Kalle Valo
