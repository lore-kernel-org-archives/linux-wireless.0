Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:40434 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751064AbeDGGy2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Apr 2018 02:54:28 -0400
Message-ID: <1523084065.4488.11.camel@intel.com> (sfid-20180407_085443_465087_6ED50F6D)
Subject: Re: iwlwifi: FW error in SYNC CMD TIME_QUOTA_CMD
From: Luciano Coelho <luciano.coelho@intel.com>
To: Daniel Borkmann <daniel@iogearbox.net>, johannes.berg@intel.com
Cc: emmanuel.grumbach@intel.com, linux-wireless@vger.kernel.org
Date: Sat, 07 Apr 2018 09:54:25 +0300
In-Reply-To: <799ecceb-8b2a-bf8c-b408-374a02280306@iogearbox.net>
References: <799ecceb-8b2a-bf8c-b408-374a02280306@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-04-05 at 16:55 +0200, Daniel Borkmann wrote:
> Hey guys,

Hi Daniel,


> after upgrading to 4608f064532c ("Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next")
> my kernel log gets constantly flooded with the below message and
> wireless stops
> working ... just in case you haven't had a report on this yet.
> Downgrading back
> to older v4.16-rcX kernel gets everything back to normal working
> state; haven't
> had time for bisection yet, but hopefully the below would provide
> some clue.
> 

[...]

> [  513.429773] iwlwifi 0000:04:00.0: Failed to send quota: -5
> [  513.429775] iwlwifi 0000:04:00.0: Failed to update quotas after
> restart (-5)
> [  514.163758] iwlwifi 0000:04:00.0: Microcode SW error
> detected.  Restarting 0x82000000.
> [  514.163987] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
> [  514.163988] iwlwifi 0000:04:00.0: Status: 0x00000100, count: 6
> [  514.163989] iwlwifi 0000:04:00.0: Loaded firmware version:
> 27.455470.0
> [  514.163991] iwlwifi 0000:04:00.0: 0x00000038 | BAD_COMMAND

[...]

I did add support for new FW APIs, so maybe some check for the FW
version is missing somewhere.

Which NIC are you using? I can see that you're using an older version
of the firmware (27.455470.0).  For 7265D and 3168 we already have
version 29.  For 8000C and 8260 we have vesion 36.  You can find all
the latest versions in our fork of linux-firmware.git[1].  And soon the
main linux-firmware.git[2] will also include the latest versions, since
I sent a pull request yesteday ago.

Meanwhile, I'll investigate this problem.  It shouldn't happen even if
you're using an older firmware.  Maybe I'll have to stop supporting
version 27 in newer kernels, let's see.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git

--
Cheers,
Luca.
