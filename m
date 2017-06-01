Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55198 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbdFAJPu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 05:15:50 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/14] mwifiex: re-register wiphy across reset
References: <20170525001119.64791-1-briannorris@chromium.org>
        <20170525001119.64791-5-briannorris@chromium.org>
Date: Thu, 01 Jun 2017 12:15:45 +0300
In-Reply-To: <20170525001119.64791-5-briannorris@chromium.org> (Brian Norris's
        message of "Wed, 24 May 2017 17:11:10 -0700")
Message-ID: <87fufk2hmm.fsf@purkki.adurom.net> (sfid-20170601_111618_794676_51BF559C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> In general, it's helpful to use the same code for device removal as for
> device reset, as this tends to have fewer bugs. Let's move the wiphy
> unregistration code into the common reset and removal code.
>
> In particular, it's very hard to properly handle the reset sequence when
> something fails. Currently, if mwifiex_reinit_sw() fails, we've failed
> to unregister the associated wiphy, and so running something as simple
> as "iw phy" can trigger an OOPS, as the wiphy still has hooks back into
> freed mwifiex data structures. For example, KASAN complained:
>
> [... see reset fail for other reasons ...]
> [ 1184.821158] mwifiex_pcie 0000:01:00.0: info: dnld wifi firmware from 174948 bytes
> [ 1186.870914] mwifiex_pcie 0000:01:00.0: info: FW download over, size 608396 bytes
> [ 1187.685990] mwifiex_pcie 0000:01:00.0: WLAN FW is active
> [ 1187.692673] mwifiex_pcie 0000:01:00.0: cmd_wait_q terminated: -512
> [ 1187.699075] mwifiex_pcie 0000:01:00.0: info: _mwifiex_fw_dpc: unregister device
> [ 1187.713476] mwifiex: Failed to bring up adapter: -5
> [ 1187.718644] mwifiex_pcie 0000:01:00.0: reinit failed: -5
>
> [... run `iw phy` ...]
> [ 1212.902419] ==================================================================
> [ 1212.909806] BUG: KASAN: use-after-free in mwifiex_cfg80211_get_antenna+0x54/0xfc [mwifiex] at addr ffffffc0ad1a8028
> [ 1212.920246] Read of size 1 by task iw/3127
> [...]
> [ 1212.934946] page dumped because: kasan: bad access detected
> [...]
> [ 1212.950665] Call trace:
> [ 1212.953148] [<ffffffc00020a69c>] dump_backtrace+0x0/0x190
> [ 1212.958572] [<ffffffc00020a96c>] show_stack+0x20/0x28
> [ 1212.963648] [<ffffffc0005ce18c>] dump_stack+0xa4/0xcc
> [ 1212.968723] [<ffffffc0003c4430>] kasan_report+0x378/0x500
> [ 1212.974140] [<ffffffc0003c3358>] __asan_load1+0x44/0x4c
> [ 1212.979462] [<ffffffbffc2e8360>] mwifiex_cfg80211_get_antenna+0x54/0xfc [mwifiex]
> [ 1212.987131] [<ffffffbffc084fc4>] nl80211_send_wiphy+0x75c/0x2de0 [cfg80211]
> [ 1212.994246] [<ffffffbffc094f60>] nl80211_dump_wiphy+0x32c/0x438 [cfg80211]
> [ 1213.001149] [<ffffffc000ab6404>] genl_lock_dumpit+0x48/0x64
> [ 1213.006746] [<ffffffc000ab3474>] netlink_dump+0x178/0x398
> [ 1213.012171] [<ffffffc000ab3d18>] __netlink_dump_start+0x1bc/0x260
> [...]
>
> This all goes away if we just tear down the wiphy on the way down, and
> set it back up if/when we bring the device back up.

I don't know exactly what kind of reset this is about, but isn't this a
quite intrusive solution? For example, phy name changes because of this?

-- 
Kalle Valo
