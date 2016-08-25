Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40294 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758062AbcHYH3Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 03:29:24 -0400
Message-ID: <1472110148.5024.123.camel@coelho.fi> (sfid-20160825_092929_081520_66FCAB6B)
From: Luca Coelho <luca@coelho.fi>
To: Andy Lutomirski <luto@kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Date: Thu, 25 Aug 2016 10:29:08 +0300
In-Reply-To: <CALCETrX3QgRpRjCp__i3iBMY3o1fw5sG7oTF-4uR3skvTwawMg@mail.gmail.com>
References: <CALCETrX3QgRpRjCp__i3iBMY3o1fw5sG7oTF-4uR3skvTwawMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: iwlwifi errors (regression?) on 4.7.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andy,

Sorry for the really long delay in replying. :(

On Sun, 2016-08-07 at 01:54 -0700, Andy Lutomirski wrote:
> My Intel 7265 used to work flawlessly, but for the past week or two
> it
> has seemed to be very unreliable.  It's also throwing errors.  I see
> problems on firmware versions 16 and 21, although I haven't gotten
> the
> warning and backtrace on firmware 16 yet.
> 
> I have:
> 
> iwlwifi 0000:3a:00.0: enabling device (0000 -> 0002)
> iwlwifi 0000:3a:00.0: Unsupported splx structure
> iwlwifi 0000:3a:00.0: loaded firmware version 21.302800.0 op_mode
> iwlmvm
> iwlwifi 0000:3a:00.0: Detected Intel(R) Dual Band Wireless AC 7265,
> REV=0x210
> iwlwifi 0000:3a:00.0: L1 Enabled - LTR Disabled
> iwlwifi 0000:3a:00.0: L1 Enabled - LTR Disabled
> 
> 
> I just got this error on 4.7.0:
> 
> [324188.495734] wlp58s0: associated
> [324281.259579] iwlwifi 0000:3a:00.0: Queue 16 stuck for 10000 ms.

This seems to be a recurring error with the AC-7265. :( We even added
an entry about it in our wiki:

https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi#about_platform_noise


> > [324281.263732] iwlwifi 0000:3a:00.0: Start IWL Error Log Dump:
> > [324281.263739] iwlwifi 0000:3a:00.0: Status: 0x00000000, count: 6
> > [324281.263745] iwlwifi 0000:3a:00.0: Loaded firmware version: 21.302800.0
> > [324281.263751] iwlwifi 0000:3a:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN

We have a bugzilla entry with the queue stuck + NMI trigger:

https://bugzilla.kernel.org/show_bug.cgi?id=112931

Unfortunately nothing was found out by our firmware team regarding this
yet.


> Earlier on the same boot I got:
> 
> [266562.042662] ------------[ cut here ]------------
> [266562.042693] WARNING: CPU: 2 PID: 994 at
> drivers/net/wireless/intel/iwlwifi/mvm/tx.c:1377
> iwl_mvm_rx_tx_cmd+0x665/0x870 [iwlmvm]

We also have an open bugzilla entry with similar WARNING:

https://bugzilla.kernel.org/show_bug.cgi?id=153381


So, first I'd recommend that you follow the recommended workarounds in
our wiki.  If that doesn't help and you still want to try to help us
debug this, please open a bugzilla so we can track it more easily.

Sorry for the trouble you're having...

--
Cheers,
Luca.
