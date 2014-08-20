Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:57386 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbaHTNlv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 09:41:51 -0400
Message-ID: <53F4A59C.60403@zonque.org> (sfid-20140820_154155_692490_2F1985F2)
Date: Wed, 20 Aug 2014 15:41:48 +0200
From: Daniel Mack <daniel@zonque.org>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes.berg@intel.com>,
	libertas-dev@lists.infradead.org,
	Linux MMC List <linux-mmc@vger.kernel.org>,
	James Cameron <quozl@laptop.org>
Subject: libertas_sdio and pxamci suspend issue
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm currently updating the kernel of a PXA3xx platform that used to be
bases on 3.0. On that, a libertas is connected to the PXA mci controller
via SDIO.

The card itself works fine on both the old version and 3.16, but on
3.16, I see the following error when trying to put the system to suspend:

[   13.459502] mmc0: new SDIO card at address 0001
[   15.103333] libertas_sdio: Libertas SDIO driver
[   15.107864] libertas_sdio: Copyright Pierre Ossman
[   15.660291] libertas_sdio mmc0:0001:1 (unregistered net_device):
00:19:88:21:f6:22, fw 9.70.20p0, cap 0x00000303
[   15.675960] libertas_sdio mmc0:0001:1 wlan0: Marvell WLAN 802.11 adapter
[   15.684075] cfg80211: Calling CRDA to update world regulatory domain

# echo mem >/sys/power/state
[   18.617456] PM: Syncing filesystems ... done.
[   18.634231] Freezing user space processes ... (elapsed 0.000 seconds)
done.
[   18.641312] Freezing remaining freezable tasks ... (elapsed 0.007
seconds) done.
[   18.658322] dpm_run_callback(): pm_generic_suspend+0x0/0x38 returns -38
[   18.665136] PM: Device mmc0:0001:1 failed to suspend: error -38
[   18.671035] PM: Some devices failed to suspend, or early wake event
detected


The problem is caused by libertas' if_sdio_suspend() returning -ENOSYS here:

       /* If we're powered off anyway, just let the mmc layer remove the
         * card. */
        if (!lbs_iface_active(card->priv))
                return -ENOSYS;


According to the comment, the code assumes the function is called from
the mmc layer, which isn't the case - the stack trace leading to this
function looks like this:

[   15.767603] [<bf019048>] (if_sdio_suspend [libertas_sdio]) from
[<c0285980>] (pm_generic_suspend+0x2c/0x38)
[   15.779843] [<c0285980>] (pm_generic_suspend) from [<c0286c1c>]
(dpm_run_callback.isra.21+0x18/0x44)
[   15.790863] [<c0286c1c>] (dpm_run_callback.isra.21) from [<c0287cdc>]
(__device_suspend+0x148/0x220)
[   15.800039] [<c0287cdc>] (__device_suspend) from [<c0288478>]
(dpm_suspend+0xa8/0x204)
[   15.808464] [<c0288478>] (dpm_suspend) from [<c00410c8>]
(suspend_devices_and_enter+0x3c/0x300)
[   15.817858] [<c00410c8>] (suspend_devices_and_enter) from
[<c0041458>] (pm_suspend+0xcc/0x1b0)
[   15.827037] [<c0041458>] (pm_suspend) from [<c0040360>]
(state_store+0xb8/0xdc)
[   15.834678] [<c0040360>] (state_store) from [<c022891c>]
(kobj_attr_store+0x14/0x20)
[   15.842664] [<c022891c>] (kobj_attr_store) from [<c00ebcc0>]
(sysfs_kf_write+0x3c/0x48)
[   15.851209] [<c00ebcc0>] (sysfs_kf_write) from [<c00eaed8>]
(kernfs_fop_write+0x100/0x158)
[   15.860039] [<c00eaed8>] (kernfs_fop_write) from [<c009766c>]
(vfs_write+0xb4/0x188)
[   15.868335] [<c009766c>] (vfs_write) from [<c0097bec>]
(SyS_write+0x3c/0x7c)
[   15.875949] [<c0097bec>] (SyS_write) from [<c00092e0>]
(ret_fast_syscall+0x0/0x2c)


Bisecting is tricky due to other details unfortunately.

Any ideas?


Thanks,
Daniel
