Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16438 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab2B0PlZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 10:41:25 -0500
Subject: Re: [PATCH -iwlwifi] iwlwifi: make tx_cmd_pool kmem cache global
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1330350725-5815-1-git-send-email-sgruszka@redhat.com>
References: <1330350725-5815-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Feb 2012 06:30:16 -0800
Message-ID: <1330353016.12612.13.camel@wwguy-huron> (sfid-20120227_164128_324454_9D6D659A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Mon, 2012-02-27 at 14:52 +0100, Stanislaw Gruszka wrote:
> Otherwise we are not able to run more than one device per driver:
> 
> [   24.743045] kmem_cache_create: duplicate cache iwl_dev_cmd
> [   24.743051] Pid: 3165, comm: NetworkManager Not tainted 3.3.0-rc2-wl+ #5
> [   24.743054] Call Trace:
> [   24.743066]  [<ffffffff811717d5>] kmem_cache_create+0x655/0x700
> [   24.743073]  [<ffffffff81061415>] ? destroy_timer_on_stack+0x15/0x20
> [   24.743079]  [<ffffffff814e26ed>] ? schedule_timeout+0x1dd/0x330
> [   24.743083]  [<ffffffff810617c0>] ? lock_timer_base+0x70/0x70
> [   24.743101]  [<ffffffffa03b9f8b>] iwl_alive_notify+0x1cb/0x1f0 [iwlwifi]
> [   24.743111]  [<ffffffffa03ba442>] iwl_load_ucode_wait_alive+0x1b2/0x220 [iwlwifi]
> [   24.743118]  [<ffffffff810b1fbd>] ? trace_hardirqs_on+0xd/0x10
> [   24.743127]  [<ffffffffa03b9700>] ? iwlagn_mac_setup_register+0x2e0/0x2e0 [iwlwifi]
> [   24.743133]  [<ffffffff814e60b4>] ? _raw_spin_unlock_bh+0x34/0x40
> [   24.743142]  [<ffffffffa03ba893>] iwl_run_init_ucode+0x73/0x100 [iwlwifi]
> [   24.743152]  [<ffffffffa03b8fa1>] __iwl_up+0x81/0x220 [iwlwifi]
> [   24.743161]  [<ffffffffa03b91c0>] iwlagn_mac_start+0x80/0x190 [iwlwifi]
> [   24.743188]  [<ffffffffa03307b3>] ieee80211_do_open+0x293/0x770 [mac80211]
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> I tested patch on wireless testing tree, and then rebased to -iwlwifi
> tree, where did compile check only. This is basically a bugfix, but
> seems nobody except me (*) use more than one iwlwifi device per system,
> so I do not cc stable. 
> 

I am not totally understand what your patch doing, you make a global
iwl_tx_cmd_pool structure, how that fix the multiple devices problem?
global variable is not really a good programming exercise, true?

> (*) I wonder why Intel developers do not run many devices in their
> systems. I think they should - one new device and a few older. Then
> perhaps we will stop seeing so many breakage on older devices caused
> by adding support for new hardware and features.
> 

Yes, I am totally agree and we will start doing that

btw, thanks for the help, I will merge all the patches from you on our
internal tree first.

Thanks
Wey



