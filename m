Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52196 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751831AbdILTvg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 15:51:36 -0400
Message-ID: <1505245891.5400.251.camel@coelho.fi> (sfid-20170912_215215_094051_3C4A5174)
From: Luca Coelho <luca@coelho.fi>
To: Jens Axboe <axboe@kernel.dk>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>
Cc: linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        srinath.mannam@broadcom.com, Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 12 Sep 2017 22:51:31 +0300
In-Reply-To: <4bcbcbc1-7c79-09f0-5071-bc2f53bf6574@kernel.dk>
References: <04c9b578-693c-1dc6-9f0f-904580231b21@kernel.dk>
         <1505232673.5400.243.camel@intel.com> <1505234187.5400.249.camel@coelho.fi>
         <4bcbcbc1-7c79-09f0-5071-bc2f53bf6574@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: iwlwifi firmware load broken in current -git
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-09-12 at 13:43 -0600, Jens Axboe wrote:
> On 09/12/2017 10:36 AM, Luca Coelho wrote:
> > On Tue, 2017-09-12 at 16:11 +0000, Coelho, Luciano wrote:
> > > Hi Jens,
> > > 
> > > On Tue, 2017-09-12 at 09:48 -0600, Jens Axboe wrote:
> > > > Hi,
> > > > 
> > > > I have no wifi in current git (8fac2f96ab8), it simply fails with:
> > > > 
> > > > [    4.363481] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-34.ucode failed with error -2
> > > > [    4.363733] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-33.ucode failed with error -2
> > > > [    4.363744] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-32.ucode failed with error -2
> > > > [    4.368077] iwlwifi 0000:04:00.0: loaded firmware version 31.532993.0 op_mode iwlmvm
> > > > [    4.461753] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0x208
> > > > [ ... ]
> > > > [    9.510570] iwlwifi 0000:04:00.0: Failed to load firmware chunk!             
> > > > [    9.513903] iwlwifi 0000:04:00.0: Could not load the [0] uCode section       
> > > > [    9.516201] iwlwifi 0000:04:00.0: Failed to start INIT ucode: -110           
> > > > [    9.530842] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -110             
> > > > 
> > > > I get the same thing with -27 of the firmware:
> > > > 
> > > > [   60.990831] Intel(R) Wireless WiFi driver for Linux                          
> > > > [   60.990833] Copyright(c) 2003- 2015 Intel Corporation                        
> > > > [   60.991936] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-34.ucode failed with error -2
> > > > [   60.991941] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-33.ucode failed with error -2
> > > > [   60.991946] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-32.ucode failed with error -2
> > > > [   60.991957] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-31.ucode failed with error -2
> > > > [   60.991964] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-30.ucode failed with error -2
> > > > [   60.991969] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-29.ucode failed with error -2
> > > > [   60.991975] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-28.ucode failed with error -2
> > > > [   61.029852] iwlwifi 0000:04:00.0: loaded firmware version 27.541033.0 op_mode iwlmvm
> > > > [   61.043660] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0x208
> > > > [   66.070135] iwlwifi 0000:04:00.0: Failed to load firmware chunk!             
> > > > [   66.070149] iwlwifi 0000:04:00.0: Could not load the [0] uCode section       
> > > > [   66.070165] iwlwifi 0000:04:00.0: Failed to start INIT ucode: -110           
> > > > [   66.083462] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -110             
> > > > 
> > > > Things work fine in 4.13-rc7+, which was the last kernel I ran on my laptop.
> > > 
> > > This is strange, Linus has been running this same combination with -31
> > > (with -27 we had a regression, but it was fixed recently and the fix is
> > > in the current master).  I have also tried this combination with both
> > > -27 and -31 after my fix and it works fine.
> > > 
> > > There are only a couple of other patches that may affect iwlwifi since
> > > the previous net-next.git pull request...
> > > 
> > > I'll try this combination on my machine and see if I can reproduce the
> > > problem.
> > 
> > I just booted my machine with the latest linux.git/master (8fac2f96ab86)
> > and it works without a problem:
> > 
> > [    8.902174] Intel(R) Wireless WiFi driver for Linux
> > [    8.902174] Copyright(c) 2003- 2015 Intel Corporation
> > [    8.995112] iwlwifi 0000:02:00.0: Direct firmware load for iwlwifi-8000C-34.ucode failed with error -2
> > [    8.995136] iwlwifi 0000:02:00.0: Direct firmware load for iwlwifi-8000C-33.ucode failed with error -2
> > [    9.026455] iwlwifi 0000:02:00.0: Direct firmware load for iwlwifi-8000C-32.ucode failed with error -2
> > [    9.348325] iwlwifi 0000:02:00.0: loaded firmware version 31.532993.0 op_mode iwlmvm
> > [    9.369307] iwlwifi 0000:02:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0x208
> > [    9.435915] iwlwifi 0000:02:00.0: base HW address: 34:13:e8:2d:65:ef
> > [    9.509217] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
> > 
> > 
> > So this seems to be something that doesn't happen in all machines, maybe
> > a PCIe problem?
> > 
> > Is there any chance you could try to bisect this?
> 
> Bisect done, it tells me that this:
> 
> commit 40f11adc7cd9281227f0a6a627d966dd0a5f0cd9
> Author: Srinath Mannam <srinath.mannam@broadcom.com>
> Date:   Fri Aug 18 21:50:48 2017 -0500
> 
>     PCI: Avoid race while enabling upstream bridges
> 
> is the first bad commit. Reverting that on top of master makes things
> work fine again, so that commit is definitely b0rken.
> 
> CC'ing the guilty part and Bjorn. I'm assuming it's the pci_is_enabled()
> check, since the rest of the patch shouldn't have functional changes.

Great! I'm glad that you could track it down to a single commit.

Bjorn/Srinath, let me know if it is something that the iwlwifi is not
doing properly.  But AFAICT the !pci_is_enabled() is checking the bridge
 *above* the iwlwifi device, so I don't think that will be the case.

--
Cheers,
Luca.
