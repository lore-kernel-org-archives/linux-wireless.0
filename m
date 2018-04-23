Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:44513 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755038AbeDWMjx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 08:39:53 -0400
Message-ID: <2769dd4501a9132f638202fece264de32218860d.camel@intel.com> (sfid-20180423_143957_222742_2003B3A9)
Subject: Re: [BUG] iwlwifi: Microcode SW error detected.  Restarting
 0x2000000.
From: Luciano Coelho <luciano.coelho@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Ayala Beker <ayala.beker@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 23 Apr 2018 15:39:45 +0300
In-Reply-To: <20180423120513.GS2173@lahna.fi.intel.com>
References: <20180423120513.GS2173@lahna.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-04-23 at 15:05 +0300, Mika Westerberg wrote:
> Hi,

Hi Mika,


> On my Lenovo X1 Carbon gen 5 system,after I upgraded to v4.17-rc1
> iwlwifi started to fail with following splats on dmesg:
> 
>   iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting
> 0x2000000.
>   iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
>   iwlwifi 0000:04:00.0: Status: 0x00000100, count: 6
>   iwlwifi 0000:04:00.0: Loaded firmware version: 31.560484.0
>   iwlwifi 0000:04:00.0: 0x00000038 | BAD_COMMAND                 

[...]

> The controller in question is:
> 
>   04:00.0 Network controller [0280]: Intel Corporation Wireless 8265
> / 8275 [8086:24fd] (rev 88)
> 
> Bisection pointed to the following commit and after I reverted it,
> things seem to work fine again:
>   
>   66fa2424df16 ("iwlwifi: fw api: support the new scan request FW API
> version")
> 
> Any idea what might be wrong with that commit and how to fix it
> properly?

We had a bug in the scan command size for older firmwares.  I have
already made a fix for it, but I hadn't sent it out for upstream yet. 
I'll send it out now and soon send you a link to it in patchwork.

You have two options: recompile the kernel with my patch or; use the
latest version of the firmware from linux-firmware.git[1].

I recommend upgrading the firmware, because we have a lot of other
fixes and improvements there, but if you want to keep your distro's
original firmware package, you can apply my patch instead.

HTH and thanks for reporting!


[1] https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/iwlwifi-8265-36.ucode


--
Cheers,
Luca.
