Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:55404 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755577AbdBQJ2K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Feb 2017 04:28:10 -0500
Date: Fri, 17 Feb 2017 10:28:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: kernel test robot <fengguang.wu@intel.com>
cc: Marc Zyngier <marc.zyngier@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Sasha Levin <alexander.levin@verizon.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [linux-stable] 4fc2942b6e kernel BUG at
 kernel/time/hrtimer.c:109!
In-Reply-To: <20170217052607.glbumukvoz4pilvt@wfg-t540p.sh.intel.com>
Message-ID: <alpine.DEB.2.20.1702171014430.3536@nanos> (sfid-20170217_102815_541147_F978EC82)
References: <20170217052607.glbumukvoz4pilvt@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 17 Feb 2017, kernel test robot wrote:

> Hi Marc,
> 
> We find this oops in linux-4.4.y. The gcc-6 compiled mainline kernel is fine.
> 
> commit 4fc2942b6e2de2efc8a9d3784d4b0d3543149613
>      hrtimer: Catch illegal clockids

And that commit is doing what the subject line says. Catch illegal usage.

> [   38.101342] Call Trace:
> [   38.101342] Call Trace:
> [   38.102045]  [<ffffffff8109aee1>] tasklet_hrtimer_init+0x16/0x52
> [   38.102045]  [<ffffffff8109aee1>] tasklet_hrtimer_init+0x16/0x52
> [   38.103698]  [<ffffffff81c767c7>] mac80211_hwsim_new_radio+0x766/0x84d

The real bug is in this code:

drivers/net/wireless/mac80211_hwsim.c

mac80211_hwsim_new_radio()

        tasklet_hrtimer_init(&data->beacon_timer,
                             mac80211_hwsim_beacon,
                             CLOCK_MONOTONIC_RAW, HRTIMER_MODE_ABS);

CLOCK_MONOTONIC_RAW is not a supported clockid for hrtimers. Sigh.

Fix below.

Thanks,

	tglx

8<------------------

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0cd95120bc78..da363ec91a1c 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2535,9 +2535,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 				    data->debugfs,
 				    data, &hwsim_simulate_radar);
 
-	tasklet_hrtimer_init(&data->beacon_timer,
-			     mac80211_hwsim_beacon,
-			     CLOCK_MONOTONIC_RAW, HRTIMER_MODE_ABS);
+	tasklet_hrtimer_init(&data->beacon_timer, mac80211_hwsim_beacon,
+			     CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 
 	spin_lock_bh(&hwsim_radio_lock);
 	list_add_tail(&data->list, &hwsim_radios);
