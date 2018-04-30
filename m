Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:37323 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751308AbeD3Idt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 04:33:49 -0400
Received: by mail-it0-f67.google.com with SMTP id 70-v6so2822361ity.2
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2018 01:33:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5B2DA6FDDF928F4E855344EE0A5C39D13BEBFD30@RTITMBSV07.realtek.com.tw>
References: <20180425020820.6141-1-pkshih@realtek.com> <87lgdbagb2.fsf@kamboji.qca.qualcomm.com>
 <5B2DA6FDDF928F4E855344EE0A5C39D13BEBF231@RTITMBSV07.realtek.com.tw>
 <20180427224156.GA18163@thinktank.home.org> <5B2DA6FDDF928F4E855344EE0A5C39D13BEBFD30@RTITMBSV07.realtek.com.tw>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 30 Apr 2018 14:03:28 +0530
Message-ID: <CABPxzYKfZVA8RTADEG5TCu0SXRSVEGWEn+Ym6AkMuFzHC5iSVg@mail.gmail.com> (sfid-20180430_103354_111831_2857274E)
Subject: Re: [PATCH v3 00/19] rtlwifi: halmac: Add new module halmac
To: Pkshih <pkshih@realtek.com>
Cc: Barry Day <briselec@gmail.com>, Kalle Valo <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 30, 2018 at 8:10 AM, Pkshih <pkshih@realtek.com> wrote:
>
>
> > -----Original Message-----
> > From: Barry Day [mailto:briselec@gmail.com]
> > Sent: Saturday, April 28, 2018 6:42 AM
> > To: Pkshih
> > Cc: Kalle Valo; Larry.Finger@lwfinger.net; linux-wireless@vger.kernel.org
> > Subject: Re: [PATCH v3 00/19] rtlwifi: halmac: Add new module halmac
> >
> > On Fri, Apr 27, 2018 at 05:44:16AM +0000, Pkshih wrote:
> > >
> > > The registers reside in driver causes error frequently, because MAC register
> > > is maintained by Realtek's MAC team so they create this module to avoid mistakes.
> > > Another benefit is to make it possible to become a thin driver, because many
> > > common functions are provided, so duplicate code will be reduced.
> >
> > How is it possible to create a thin driver by adding lots more code and layers
> > of indirection ??? and writing it in a way that it won't compile without the
> > code for every type of bus interface even though most modules only use one ?
> >
> As I mentioned in first paragraph "(I use 'driver' in this mail indicates part of
> rtlwifi excluded from this module.)". If this module was seen as a 'lib', rtl8822be
> would be a "thin driver". For bus interface code, I need to add a way to compile
> type of bus interface according to selected chip.
>
> > It's a horrible pile of garbage slapped together by an inexperienced
> > programmer. Its a major deterrent for anyone looking at working on one of
> > the latest realtek drivers.
> >
> This module is designed to support multiple OS including Windows and Linux, and
> many products have used this module and worked well. We hope Linux user can also
> use Realtek's WiFi without additional installation if driver was built.
> In order to submit this module to kernel upstream, we take a lot of effort
> to fit Linux coding conventions (e.g. coding style), and explicit
> suggestions will be helpful for us to continuously improve this module.

IMHO, this is a common use case for most organizations. I understand
that Linux cannot
accommodate other OSes requirements but is there an approved/recommended way
to upstream an OS agnostic driver? Agnostic drivers are generally
bulkier compared to
Linux-only drivers and also code organization is also different (to
handle other OSes).
