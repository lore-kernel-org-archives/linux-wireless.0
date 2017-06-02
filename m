Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60664 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751185AbdFBJm6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 05:42:58 -0400
Message-ID: <1496396575.9478.54.camel@coelho.fi> (sfid-20170602_114316_750604_A9DF9F10)
From: Luca Coelho <luca@coelho.fi>
To: Marc MERLIN <marc@merlins.org>, linux-wireless@vger.kernel.org
Date: Fri, 02 Jun 2017 12:42:55 +0300
In-Reply-To: <20170526024826.3qjx7pe3kz44klk3@merlins.org>
References: <20170526024826.3qjx7pe3kz44klk3@merlins.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: After upgrading to 4.11.1, wifi driver refuses to load after
 being unloaded once.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-05-25 at 19:48 -0700, Marc MERLIN wrote:
> Howdy,
> 
> First I tried ilw@linux.intel.com which is now dead
> Then linuxwifi@intel.com, but no reply.
> So I'm trying here next.

Sorry, Marc.  Somehow your emails really slipped through the cracks and
I hadn't seen them before.

> 3 different ways it's failing now:
> 1) CPU: 3 PID: 9349 at drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1913 iwl_trans_pcie_grab_nic_access+0xcc/0xe1 [iwlwifi]
> Timeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)
> 
> 2) 
> iwlwifi 0000:04:00.0: loaded firmware version 19.277230.0 op_mode iwlmvm

I kernel v4.9, we stopped supporting firmware versions smaller than 22
for the 8260.  But unfortunately I made a mistake in the patch[1] when I
removed support for those firmwares and I used 17, which is the lowest
version for 7260 devices.

I have just sent out a patch[2] with a fix for that.

You can probably solve your problem by getting the latest firmware we
have released, which is version 27.  You can get it from the linux-
firmware.git repository[3].  Please try that and let us know how it
goes.


[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4b87e5af638b6056bd6c20b0954d09a5a58633be
[2] https://patchwork.kernel.org/patch/9762047/
[3] https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/iwlwifi-8000C-27.ucode

--
Cheers,
Luca.
