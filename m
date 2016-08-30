Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:36718 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750861AbcH3TCf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 15:02:35 -0400
Received: by mail-ua0-f171.google.com with SMTP id m60so49456094uam.3
        for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2016 12:02:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1472110148.5024.123.camel@coelho.fi>
References: <CALCETrX3QgRpRjCp__i3iBMY3o1fw5sG7oTF-4uR3skvTwawMg@mail.gmail.com>
 <1472110148.5024.123.camel@coelho.fi>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 30 Aug 2016 12:02:13 -0700
Message-ID: <CALCETrWyUQwNQ0YtuLziRFU+mLKcWiLEQSFb_=K5oswJwjq-Vw@mail.gmail.com> (sfid-20160830_210239_443879_1A1315AF)
Subject: Re: iwlwifi errors (regression?) on 4.7.0
To: Luca Coelho <luca@coelho.fi>
Cc: Andy Lutomirski <luto@kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2016 at 12:29 AM, Luca Coelho <luca@coelho.fi> wrote:
> Hi Andy,
>
> Sorry for the really long delay in replying. :(
>
> On Sun, 2016-08-07 at 01:54 -0700, Andy Lutomirski wrote:
>> My Intel 7265 used to work flawlessly, but for the past week or two
>> it
>> has seemed to be very unreliable.  It's also throwing errors.  I see
>> problems on firmware versions 16 and 21, although I haven't gotten
>> the
>> warning and backtrace on firmware 16 yet.
>>
>> I have:
>>
>> iwlwifi 0000:3a:00.0: enabling device (0000 -> 0002)
>> iwlwifi 0000:3a:00.0: Unsupported splx structure
>> iwlwifi 0000:3a:00.0: loaded firmware version 21.302800.0 op_mode
>> iwlmvm
>> iwlwifi 0000:3a:00.0: Detected Intel(R) Dual Band Wireless AC 7265,
>> REV=0x210
>> iwlwifi 0000:3a:00.0: L1 Enabled - LTR Disabled
>> iwlwifi 0000:3a:00.0: L1 Enabled - LTR Disabled
>>
>>
>> I just got this error on 4.7.0:
>>
>> [324188.495734] wlp58s0: associated
>> [324281.259579] iwlwifi 0000:3a:00.0: Queue 16 stuck for 10000 ms.
>
> This seems to be a recurring error with the AC-7265. :( We even added
> an entry about it in our wiki:
>
> https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi#about_platform_noise

Shouldn't that cause packet loss, not actual stuck queues?  Or is the
problem that the device literally can't transmit at all for 10 seconds
and the driver eventually gets sick of waiting?  Could the driver
learn to detect this more sensibly, drop the packets cleanly after
some timeout, and maybe log a message about extremely high noise?

>
>
>> > [324281.263732] iwlwifi 0000:3a:00.0: Start IWL Error Log Dump:
>> > [324281.263739] iwlwifi 0000:3a:00.0: Status: 0x00000000, count: 6
>> > [324281.263745] iwlwifi 0000:3a:00.0: Loaded firmware version: 21.302800.0
>> > [324281.263751] iwlwifi 0000:3a:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN
>
> We have a bugzilla entry with the queue stuck + NMI trigger:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=112931
>
> Unfortunately nothing was found out by our firmware team regarding this
> yet.

Sad :(

>
>
>> Earlier on the same boot I got:
>>
>> [266562.042662] ------------[ cut here ]------------
>> [266562.042693] WARNING: CPU: 2 PID: 994 at
>> drivers/net/wireless/intel/iwlwifi/mvm/tx.c:1377
>> iwl_mvm_rx_tx_cmd+0x665/0x870 [iwlmvm]
>
> We also have an open bugzilla entry with similar WARNING:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=153381
>
>
> So, first I'd recommend that you follow the recommended workarounds in
> our wiki.  If that doesn't help and you still want to try to help us
> debug this, please open a bugzilla so we can track it more easily.

I haven't seem any of these problems on 4.8-rc yet.  I'll keep you
posted if I do.
