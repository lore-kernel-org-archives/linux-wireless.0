Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:55138 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750798AbdLSTGP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 14:06:15 -0500
Date: Tue, 19 Dec 2017 14:06:13 -0500 (EST)
Message-Id: <20171219.140613.787406975531411549.davem@davemloft.net> (sfid-20171219_200619_912464_1F10EFA8)
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luciano.coelho@intel.com
Subject: Re: pull-request: wireless-drivers-next 2017-12-18
From: David Miller <davem@davemloft.net>
In-Reply-To: <874looktmz.fsf@kamboji.qca.qualcomm.com>
References: <874looktmz.fsf@kamboji.qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@codeaurora.org>
Date: Mon, 18 Dec 2017 16:17:24 +0200

> a pull request for 4.16 to net-next tree. This is a big one, but on the
> other hand most of the stuff here has been some time on linux-next so
> hopefully there are no nasty surprises. Even though Arnd just send a
> patch[1] five minutes ago about fixing a wcn36xx build warning, but I
> don't think that's critical enough to hold up this, so I'll send it to
> you in the next pull request.
> 
> But this time we actually have a merge conflict due to a000 hardware
> rename in iwlwifi:
> 
> CONFLICT (content): Merge conflict in drivers/net/wireless/intel/iwlwifi/pcie/drv.c
> 
> The fix is quite straightforward, take the 22000 versions and manually
> add an entry for 0xA0F0 device:
> 
> {IWL_PCI_DEVICE(0xA0F0, 0x0000, iwl22000_2ax_cfg_hr)},
> 
> I put the 'git diff' output of my test resolution below, hopefully it
> helps. I'll also Cc Luca so he can correct any mistakes I did :)
> 
> Please let me know if you have any problems.

Pulled, and thanks for the resolution diff.  It helped a lot.
