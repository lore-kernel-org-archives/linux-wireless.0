Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52692 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752482AbeEPMBZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 08:01:25 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Pkshih <pkshih@realtek.com>, Barry Day <briselec@gmail.com>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 00/19] rtlwifi: halmac: Add new module halmac
References: <20180425020820.6141-1-pkshih@realtek.com>
        <87lgdbagb2.fsf@kamboji.qca.qualcomm.com>
        <5B2DA6FDDF928F4E855344EE0A5C39D13BEBF231@RTITMBSV07.realtek.com.tw>
        <20180427224156.GA18163@thinktank.home.org>
        <5B2DA6FDDF928F4E855344EE0A5C39D13BEBFD30@RTITMBSV07.realtek.com.tw>
        <CABPxzYKfZVA8RTADEG5TCu0SXRSVEGWEn+Ym6AkMuFzHC5iSVg@mail.gmail.com>
Date: Wed, 16 May 2018 15:01:20 +0300
In-Reply-To: <CABPxzYKfZVA8RTADEG5TCu0SXRSVEGWEn+Ym6AkMuFzHC5iSVg@mail.gmail.com>
        (Krishna Chaitanya's message of "Mon, 30 Apr 2018 14:03:28 +0530")
Message-ID: <87a7szkdwv.fsf@codeaurora.org> (sfid-20180516_140128_966159_C355A18F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Krishna Chaitanya <chaitanya.mgit@gmail.com> writes:

> On Mon, Apr 30, 2018 at 8:10 AM, Pkshih <pkshih@realtek.com> wrote:
>>
>>
>> > -----Original Message-----
>> > From: Barry Day [mailto:briselec@gmail.com]
>> > Sent: Saturday, April 28, 2018 6:42 AM
>> > To: Pkshih
>> > Cc: Kalle Valo; Larry.Finger@lwfinger.net; linux-wireless@vger.kernel.org
>> > Subject: Re: [PATCH v3 00/19] rtlwifi: halmac: Add new module halmac
>> >
>> > On Fri, Apr 27, 2018 at 05:44:16AM +0000, Pkshih wrote:
>> > >
>> > > The registers reside in driver causes error frequently, because MAC register
>> > > is maintained by Realtek's MAC team so they create this module to avoid mistakes.
>> > > Another benefit is to make it possible to become a thin driver, because many
>> > > common functions are provided, so duplicate code will be reduced.
>> >
>> > How is it possible to create a thin driver by adding lots more code and layers
>> > of indirection ??? and writing it in a way that it won't compile without the
>> > code for every type of bus interface even though most modules only use one ?
>> >
>> As I mentioned in first paragraph "(I use 'driver' in this mail indicates part of
>> rtlwifi excluded from this module.)". If this module was seen as a 'lib', rtl8822be
>> would be a "thin driver". For bus interface code, I need to add a way to compile
>> type of bus interface according to selected chip.
>>
>> > It's a horrible pile of garbage slapped together by an inexperienced
>> > programmer. Its a major deterrent for anyone looking at working on one of
>> > the latest realtek drivers.
>> >
>> This module is designed to support multiple OS including Windows and Linux, and
>> many products have used this module and worked well. We hope Linux user can also
>> use Realtek's WiFi without additional installation if driver was built.
>> In order to submit this module to kernel upstream, we take a lot of effort
>> to fit Linux coding conventions (e.g. coding style), and explicit
>> suggestions will be helpful for us to continuously improve this module.
>
> IMHO, this is a common use case for most organizations.

Yes, it is.

> I understand that Linux cannot accommodate other OSes requirements but
> is there an approved/recommended way to upstream an OS agnostic
> driver?

When having an OS agnostic driver My recommendataion is to rewrite the
driver :) We have plenty of examples doing that: wl1251/wl18xx, ath10k,
rtl8xxx, cw1200 and wcn36xx at least. But of course it's possible to
major cleanup to the driver and then get it accepted, with ath6kl we did
that and I think brcmfmac also did that.

> Agnostic drivers are generally bulkier compared to Linux-only drivers
> and also code organization is also different (to handle other OSes).

Indeed, I hate those OS agnostic vendor drivers so much. So many
different layers and abstractions make my head just spin. Luckily we
seem to have proper Linux upstream drivers for most of the wireless
hardware nowadays!

-- 
Kalle Valo
