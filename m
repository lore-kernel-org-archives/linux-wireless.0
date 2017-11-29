Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36998 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbdK2HvU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Nov 2017 02:51:20 -0500
Received: by mail-lf0-f68.google.com with SMTP id a12so2783960lfe.4
        for <linux-wireless@vger.kernel.org>; Tue, 28 Nov 2017 23:51:19 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1511259055.4011.268.camel@coelho.fi>
References: <1511175768.4011.261.camel@coelho.fi> <CA+icZUVqhmH3dyMXkHKsHus5qyfMqQfcOctvHRDf4x=6+ndfPw@mail.gmail.com>
 <1511259055.4011.268.camel@coelho.fi>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Wed, 29 Nov 2017 08:51:18 +0100
Message-ID: <CA+icZUVPzwX6hyPZaUJWwn7zOGMaRAkQ7SA6haw6p0F-YX7kBw@mail.gmail.com> (sfid-20171129_085123_714785_096EDF2B)
Subject: Re: pull-request: iwlwifi 2017-11-19
To: Luca Coelho <luca@coelho.fi>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        linuxwifi <linuxwifi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 21, 2017 at 11:10 AM, Luca Coelho <luca@coelho.fi> wrote:
> On Tue, 2017-11-21 at 10:30 +0100, Sedat Dilek wrote:
>> On Mon, Nov 20, 2017 at 12:02 PM, Luca Coelho <luca@coelho.fi> wrote:
>> [..]
>> > ----------------------------------------------------------------
>> > iwlwifi: first set of fixes for 4.15
>> >
>> > * Support new FW API version of scan cmd (used in FW version 34);
>>
>> While seeing this...
>> I have here a iwlwifi-8265 hardware and have seen a recently uploaded
>> FW-version 34 in iwlwifi-firmware Git.
>> Can you explain the dependence of iwlwifi firmware-version / Linux
>> kernel-release and especially probing?
>> Currently, I am using Linux v4.14 from Debian/experimental.
>
> Mostly for backwards-compatibility, the driver is able to work with a
> range of firmware versions.  It only uses one of them at a time (i.e.
> the highest supported version it finds).
>
> The driver in v4.14 support version 34 and below.  So it starts looking
> for that one and, if not found, falls back to the next lower version
> (i.e. 33) and so on, until it finds one.
>

Isn't Linux v4.14.3 (here: -rc1) minimum to completely support new
features in v34 firmware?

"iwlwifi: mvm: support version 7 of the SCAN_REQ_UMAC FW command"
commit dac4df1c5f2c34903f61b1bc4fc722e31b4199e7 upstream.

- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-4.14.y&id=930929379cc8f92275675fb27e572c4d539f6b8a
