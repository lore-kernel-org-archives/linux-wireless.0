Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33256 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935822AbeEXI1H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 04:27:07 -0400
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
        <1526371717.12375.8.camel@realtek.com> <871sebkcad.fsf@codeaurora.org>
        <1526646826.1942.1.camel@realtek.com>
Date: Thu, 24 May 2018 11:27:02 +0300
In-Reply-To: <1526646826.1942.1.camel@realtek.com> (pkshih@realtek.com's
        message of "Fri, 18 May 2018 12:33:55 +0000")
Message-ID: <87bmd5ihm1.fsf@codeaurora.org> (sfid-20180524_103014_072322_11305667)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pkshih <pkshih@realtek.com> writes:

> On Wed, 2018-05-16 at 15:36 +0300, Kalle Valo wrote:
>> Pkshih <pkshih@realtek.com> writes:
>>=C2=A0
>> > On Mon, 2018-04-30 at 14:03 +0530, Krishna Chaitanya wrote:
>> >> On Mon, Apr 30, 2018 at 8:10 AM, Pkshih <pkshih@realtek.com> wrote:
>> >> >
>> >> >
>> >> > > -----Original Message-----
>> >> > > From: Barry Day [mailto:briselec@gmail.com]
>> >> > > Sent: Saturday, April 28, 2018 6:42 AM
>> >> > > To: Pkshih
>> >> > > Cc: Kalle Valo; Larry.Finger@lwfinger.net; linux-wireless@vger.ke=
rnel.org
>> >> > > Subject: Re: [PATCH v3 00/19] rtlwifi: halmac: Add new module hal=
mac
>> >> > >
>> >> > > On Fri, Apr 27, 2018 at 05:44:16AM +0000, Pkshih wrote:
>> >> > > >
>> >> > > > The registers reside in driver causes error frequently, because=
 MAC register
>> >> > > > is maintained by Realtek's MAC team so they create this module =
to avoid mistakes.
>> >> > > > Another benefit is to make it possible to become a thin driver,=
 because many
>> >> > > > common functions are provided, so duplicate code will be reduce=
d.
>> >> > >
>> >> > > How is it possible to create a thin driver by adding lots more co=
de and layers
>> >> > > of indirection ??? and writing it in a way that it won't compile =
without the
>> >> > > code for every type of bus interface even though most modules onl=
y use one ?
>> >> > >
>> >> > As I mentioned in first paragraph "(I use 'driver' in this mail ind=
icates part of
>> >> > rtlwifi excluded from this module.)". If this module was seen as a =
'lib', rtl8822be
>> >> > would be a "thin driver". For bus interface code, I need to add a w=
ay to compile
>> >> > type of bus interface according to selected chip.
>> >> >
>> >> > > It's a horrible pile of garbage slapped together by an inexperien=
ced
>> >> > > programmer. Its a major deterrent for anyone looking at working o=
n one of
>> >> > > the latest realtek drivers.
>> >> > >
>> >> > This module is designed to support multiple OS including Windows an=
d Linux, and
>> >> > many products have used this module and worked well. We hope Linux =
user can also
>> >> > use Realtek's WiFi without additional installation if driver was bu=
ilt.
>> >> > In order to submit this module to kernel upstream, we take a lot of=
 effort
>> >> > to fit Linux coding conventions (e.g. coding style), and explicit
>> >> > suggestions will be helpful for us to continuously improve this mod=
ule.
>> >>=C2=A0
>> >> IMHO, this is a common use case for most organizations. I understand
>> >> that Linux cannot
>> >> accommodate other OSes requirements but is there an approved/recommen=
ded way
>> >> to upstream an OS agnostic driver? Agnostic drivers are generally
>> >> bulkier compared to
>> >> Linux-only drivers and also code organization is also different (to
>> >> handle other OSes).
>> >>=C2=A0
>> >
>> > Hi Kalle,
>> >
>> > The state of this patchset was changed to RFC in patchwork, and I look=
 at RFC's
>> > meaning in wireless wiki. Do you expect that I will send v4?
>>=C2=A0
>> Yes, I was expecting that you will submit v4 with proper documentation.
>> I was supposed to send an email but forgot, sorry.
>>=C2=A0
>> > If so, what do I need to fix in v4? Or, you need more description
>> > about this module, please let me know.=C2=A0
>>=C2=A0
>> The biggest problem is that rtlwifi patches are way too big and which I
>> don't think are ready for upstream, most of the time code quality is
>> closer to the infamous "vendor drivers". This is causing me too much
>> burden, even just reviewing and providing initial comments to rtlwifi
>> patches take too much of my time. For example, I still haven't been able
>> to check the rtlwifi btcoex patches from a month ago.
>>=C2=A0
>> In principle I can use a minute or two per patch, anything longer than
>> that and I can't keep up with the incoming patch flow. And with huge
>> rtlwifi patchsets I usually need something more like an hour than few
>> minutes.
>>=C2=A0
>> I have said this also before, but more and more I'm thinking that
>> rtlwifi is not really a proper upstream driver. I think staging would be
>> a much better place for it and maybe a proper upstream realtek driver
>> would be something based on rtl8xxxu? I dunno.
>>=C2=A0
>> But we really need to find a solution for this as the current way with
>> rtlwifi patches won't work in the long run.
>>=C2=A0
>
> If we remove unused code and do proper modification (e.g. remove abstract=
ion layer)
> and submit to staging, but still remain the directory levels.
> Will you accept halmac and submit it into upstream after being reviewed i=
n staging?
> Or, the only way you can accept is to remove the halmac directory and rea=
rrange
> the code and split it into the top level directory?

You are missing my point: I don't even have time to review huge rtlwifi
patches when they are not even ready for upstream. I cannot start
working on cleaning up rtlwifi code and doing multiple iterations of
reviews on these kind of huge patchsets. Either you need to
significantly scale down the size of patchsets (especially LOC) or you
need to get review help from someone else. But the current way of
working is not doable for me.

Just to make it clear, I'm here criticizing huge rtlwifi patchsets like
this halmac layer and the btcoex component. With smaller rtlwifi patches
I have no issues, they are just fine.

--=20
Kalle Valo
