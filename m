Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38096 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751131AbdBCQnM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 11:43:12 -0500
Message-ID: <1486140182.26003.100.camel@coelho.fi> (sfid-20170203_174340_259638_239FF08D)
From: Luca Coelho <luca@coelho.fi>
To: Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "emmanuel.grumbach@intel.com" <emmanuel.grumbach@intel.com>,
        "matti.gottlieb@intel.com" <matti.gottlieb@intel.com>,
        "sara.sharon@intel.com" <sara.sharon@intel.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Date: Fri, 03 Feb 2017 18:43:02 +0200
In-Reply-To: <8520D5D51A55D047800579B094147198263E067A@XAP-PVEXMBX02.xlnx.xilinx.com>
References: <8520D5D51A55D047800579B094147198263E067A@XAP-PVEXMBX02.xlnx.xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Issues with FW with Intel 720 wifi card
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bharat,


On Fri, 2017-02-03 at 16:27 +0000, Bharat Kumar Gogada wrote:
> Hi,
> 
> Im using linux 4.6 kernel, I get following error when I do interface up.
> 
> Here is the boot log.
> [    4.407681] iwlwifi 0000:01:00.0: loaded firmware version 16.242414.0 op_mode iwlmvm
> [    4.407742] iwlwifi 0000:01:00.0: Detected Intel(R) Wireless N 7260, REV=0x144
> [    4.407831] iwlwifi 0000:01:00.0: L1 Disabled - LTR Disabled
> [    4.408116] iwlwifi 0000:01:00.0: L1 Disabled - LTR Disabled
> 
> When I do interface up I get following :
> [    9.419999] iwlwifi 0000:01:00.0: Failed to load firmware chunk!
> [    9.425947] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
> [    9.432472] iwlwifi 0000:01:00.0: Failed to start INIT ucode: -110
> [    9.438899] iwlwifi 0000:01:00.0: Failed to run INIT ucode: -110
> [    9.444858] iwlwifi 0000:01:00.0: L1 Disabled - LTR Disabled

It's hard to say why this is happening.


> I downloaded firmware from here
> https://wireless.wiki.kernel.org/en/users/Drivers/iwlwifi

Why did you have to download the firmware? Doesn't your distro include
the binaries from linux-firmware.git?

The firmware you are using is version 16, but that kernel already
supports version -17.  I recommend you try to take the latest firmware
for the 7260 NIC from our copy of linux-firmware.git[2].

If this doesn't help, the best thing to do would be to report this as a
bug in bugzilla.kernel.org following the instructions in our wiki[1]. 
This way we can help you more easily.


[1] https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/debugging
[2] http://git.kernel.org/cgit/linux/kernel/git/iwlwifi/linux-firmware.git/plain/iwlwifi-7260-17.ucode

--
Cheers,
Luca.
