Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:40779 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759603AbdLSNww (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 08:52:52 -0500
Received: by mail-lf0-f45.google.com with SMTP id u84so302381lff.7
        for <linux-wireless@vger.kernel.org>; Tue, 19 Dec 2017 05:52:51 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1511943649.4827.20.camel@coelho.fi>
References: <1511175768.4011.261.camel@coelho.fi> <CA+icZUVqhmH3dyMXkHKsHus5qyfMqQfcOctvHRDf4x=6+ndfPw@mail.gmail.com>
 <1511259055.4011.268.camel@coelho.fi> <CA+icZUVPzwX6hyPZaUJWwn7zOGMaRAkQ7SA6haw6p0F-YX7kBw@mail.gmail.com>
 <1511943649.4827.20.camel@coelho.fi>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Tue, 19 Dec 2017 14:52:50 +0100
Message-ID: <CA+icZUUuqoEuvwG9PE8LHT=3vFLf4FmkNUqMUOweE9s-1bcftg@mail.gmail.com> (sfid-20171219_145256_560019_FB5F197F)
Subject: Re: pull-request: iwlwifi 2017-11-19
To: Luca Coelho <luca@coelho.fi>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        linuxwifi <linuxwifi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 29, 2017 at 9:20 AM, Luca Coelho <luca@coelho.fi> wrote:
> On Wed, 2017-11-29 at 08:51 +0100, Sedat Dilek wrote:
>> On Tue, Nov 21, 2017 at 11:10 AM, Luca Coelho <luca@coelho.fi> wrote:
>> > On Tue, 2017-11-21 at 10:30 +0100, Sedat Dilek wrote:
>> > > On Mon, Nov 20, 2017 at 12:02 PM, Luca Coelho <luca@coelho.fi>
>> > > wrote:
>> > > [..]
>> > > > -------------------------------------------------------------
>> > > > ---
>> > > > iwlwifi: first set of fixes for 4.15
>> > > >
>> > > > * Support new FW API version of scan cmd (used in FW version
>> > > > 34);
>> > >
>> > > While seeing this...
>> > > I have here a iwlwifi-8265 hardware and have seen a recently
>> > > uploaded
>> > > FW-version 34 in iwlwifi-firmware Git.
>> > > Can you explain the dependence of iwlwifi firmware-version /
>> > > Linux
>> > > kernel-release and especially probing?
>> > > Currently, I am using Linux v4.14 from Debian/experimental.
>> >
>> > Mostly for backwards-compatibility, the driver is able to work with
>> > a
>> > range of firmware versions.  It only uses one of them at a time
>> > (i.e.
>> > the highest supported version it finds).
>> >
>> > The driver in v4.14 support version 34 and below.  So it starts
>> > looking
>> > for that one and, if not found, falls back to the next lower
>> > version
>> > (i.e. 33) and so on, until it finds one.
>> >
>>
>> Isn't Linux v4.14.3 (here: -rc1) minimum to completely support new
>> features in v34 firmware?
>
> Yes, it is.  But this was a bug and we can't go back and fix v4.14.0-2,
> right? So it's the best we can do and whoever is using v4.14, should
> update to v4.14.3 when it comes out to be able to use version 34 of the
> firmware.
>

Thanks for the confirmation.

I have added the patch from v4.14.3 to latest Debian-kernel v4.14.2
and rebuild the corresponding iwlwifi kernel-modules.
v34 firmware works fine now.

# dmesg | egrep iwlwifi
[   21.178769] iwlwifi: loading out-of-tree module taints kernel.
[   21.184459] iwlwifi 0000:04:00.0: enabling device (0000 -> 0002)
[   21.217170] iwlwifi 0000:04:00.0: firmware: direct-loading firmware
iwlwifi-8265-34.ucode
[   21.218061] iwlwifi 0000:04:00.0: loaded firmware version 34.0.1
op_mode iwlmvm
[   21.271000] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
Wireless AC 8265, REV=0x230
[   21.340242] iwlwifi 0000:04:00.0: base HW address: bc:a8:a6:d1:3f:49
[   21.432118] iwlwifi 0000:04:00.0 wlp4s0: renamed from wlan0

- Sedat -
