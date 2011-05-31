Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:46670 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426Ab1EaLR3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 07:17:29 -0400
Received: by gxk22 with SMTP id 22so2304719gxk.16
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2011 04:17:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306833366.23002.52.camel@cumari>
References: <1306828287-31802-1-git-send-email-shahar_levi@ti.com>
	<1306830902.23002.18.camel@cumari>
	<BANLkTikGm1KwNTXXHTjM0K1tVNOPpi2BLQ@mail.gmail.com>
	<1306833366.23002.52.camel@cumari>
Date: Tue, 31 May 2011 14:17:27 +0300
Message-ID: <BANLkTinfEopWmY91UwtHFdtxxwhOi=EH-A@mail.gmail.com> (sfid-20110531_131738_870096_B05EBA70)
Subject: Re: [PATCH] wl12xx: Add Support for Low Power DRPw (LPD) Mode
From: "Levi, Shahar" <shahar_levi@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 31, 2011 at 12:16 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Tue, 2011-05-31 at 12:11 +0300, Eliad Peller wrote:
>> On Tue, May 31, 2011 at 11:35 AM, Luciano Coelho <coelho@ti.com> wrote:
>> > On Tue, 2011-05-31 at 10:51 +0300, Shahar Levi wrote:
>> >> The Low Power DRPw (LPD) mode contains several optimizations
>> >> that designed to reduce the solution's consumption. The
>> >> purpose is to save current consumption in RX and Listen mode.
>> >>
>> >> LPD setting apply only for wl127x AP mode (not wl128x)
>> >>
>> >> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
>> >> ---
>> >
>> > [...]
>> >
>> >
>> > I still think this is not the right way to do it.  It doesn't make sense
>> > to have it in the configuration parameters.  If you want to make it
>> > configurable, it should be in the NVS file and the driver should clear
>> > it when not in AP mode (and whoever generates the NVS needs to make sure
>> > it's never set for wl128x).
>> >
>> please don't use the "blacklist" approach. it always gets broken at some point.
>
> I totally agree.
>
>
>> > The other solution is to always set this flag when in wl127x in AP-mode,
>> > in which case it doesn't need to be configurable at all.  That would be
>> > the simplest solution and you could even use a quirk if it makes it
>> > easier.
>> >
>> sounds much better.
>
> Yes, and now we got confirmation that this is really the case.  It
> should always be set for wl127x in AP-mode and not be set for anything
> else.  This is a clear case, not a configurable value.
np. will be fix in the quirk way

> --
> Cheers,
> Luca.
Thanks for your review.
All the best,
Shahar
