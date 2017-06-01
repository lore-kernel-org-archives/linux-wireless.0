Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34691 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751142AbdFARkC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 13:40:02 -0400
Received: by mail-pf0-f173.google.com with SMTP id 9so33237738pfj.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Jun 2017 10:40:01 -0700 (PDT)
Date: Thu, 1 Jun 2017 10:39:56 -0700
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/14] mwifiex: re-register wiphy across reset
Message-ID: <20170601173954.GA138807@google.com> (sfid-20170601_194244_705226_1DAC7811)
References: <20170525001119.64791-1-briannorris@chromium.org>
 <20170525001119.64791-5-briannorris@chromium.org>
 <87fufk2hmm.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87fufk2hmm.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 01, 2017 at 12:15:45PM +0300, Kalle Valo wrote:
> Brian Norris <briannorris@chromium.org> writes:
> 
> > In general, it's helpful to use the same code for device removal as for
> > device reset, as this tends to have fewer bugs. Let's move the wiphy
> > unregistration code into the common reset and removal code.
> >
> > In particular, it's very hard to properly handle the reset sequence when
> > something fails. Currently, if mwifiex_reinit_sw() fails, we've failed
> > to unregister the associated wiphy, and so running something as simple
> > as "iw phy" can trigger an OOPS, as the wiphy still has hooks back into
> > freed mwifiex data structures. For example, KASAN complained:
> >
> > [... see reset fail for other reasons ...]
> > [ 1184.821158] mwifiex_pcie 0000:01:00.0: info: dnld wifi firmware from 174948 bytes
> > [ 1186.870914] mwifiex_pcie 0000:01:00.0: info: FW download over, size 608396 bytes
> > [ 1187.685990] mwifiex_pcie 0000:01:00.0: WLAN FW is active
> > [ 1187.692673] mwifiex_pcie 0000:01:00.0: cmd_wait_q terminated: -512
> > [ 1187.699075] mwifiex_pcie 0000:01:00.0: info: _mwifiex_fw_dpc: unregister device
> > [ 1187.713476] mwifiex: Failed to bring up adapter: -5
> > [ 1187.718644] mwifiex_pcie 0000:01:00.0: reinit failed: -5
> >
> > [... run `iw phy` ...]
> > [ 1212.902419] ==================================================================
> > [ 1212.909806] BUG: KASAN: use-after-free in mwifiex_cfg80211_get_antenna+0x54/0xfc [mwifiex] at addr ffffffc0ad1a8028
> > [ 1212.920246] Read of size 1 by task iw/3127
> > [...]
> > [ 1212.934946] page dumped because: kasan: bad access detected
> > [...]
> > [ 1212.950665] Call trace:
> > [ 1212.953148] [<ffffffc00020a69c>] dump_backtrace+0x0/0x190
> > [ 1212.958572] [<ffffffc00020a96c>] show_stack+0x20/0x28
> > [ 1212.963648] [<ffffffc0005ce18c>] dump_stack+0xa4/0xcc
> > [ 1212.968723] [<ffffffc0003c4430>] kasan_report+0x378/0x500
> > [ 1212.974140] [<ffffffc0003c3358>] __asan_load1+0x44/0x4c
> > [ 1212.979462] [<ffffffbffc2e8360>] mwifiex_cfg80211_get_antenna+0x54/0xfc [mwifiex]
> > [ 1212.987131] [<ffffffbffc084fc4>] nl80211_send_wiphy+0x75c/0x2de0 [cfg80211]
> > [ 1212.994246] [<ffffffbffc094f60>] nl80211_dump_wiphy+0x32c/0x438 [cfg80211]
> > [ 1213.001149] [<ffffffc000ab6404>] genl_lock_dumpit+0x48/0x64
> > [ 1213.006746] [<ffffffc000ab3474>] netlink_dump+0x178/0x398
> > [ 1213.012171] [<ffffffc000ab3d18>] __netlink_dump_start+0x1bc/0x260
> > [...]
> >
> > This all goes away if we just tear down the wiphy on the way down, and
> > set it back up if/when we bring the device back up.
> 
> I don't know exactly what kind of reset this is about,

Marvell firmwares are known to be quite buggy, and there are plenty of
situations in which they crash (often resulting in a command timeout).
The current best workaround for these is to essentially unwind the whole
driver, reset the card, and reprobe the whole thing. See anywhere that
the ->card_reset() callback is called.

This has been around for a long time on SDIO, and you recently merged my
changes to enable this for PCIe:

6d7d579a8243 mwifiex: pcie: add card_reset() support

> but isn't this a
> quite intrusive solution? For example, phy name changes because of this?

Yes, it is a bit intrusive. But the whole process is intrusive, as it
deletes all the virtual interfaces and loses your settings. This all
relies on user space being prepared to clean up and reinitialize
everything afterward.

And yes, this causes a phy name change.

In favor: this is what the SDIO reset code *used* to do, before this
commit:

c742e623e941 mwifiex: sdio card reset enhancement

where the SDIO driver started using the half-baked reset solution
written for PCIe.

Lastly, I still need to analyze a few more things in this driver, but
AFAICT, if we *don't* unregister the wiphy, we are exposed to quite a
few more race conditions -- not just the easy-to-notice condition
described above. What happens if the wiphy still processes cfg80211
operations while we're still resetting the firmware? Much of the driver
may not be prepared for this. At the moment, I can't find anything
terribly wrong; if I slow down the reset (e.g., with msleep()s) I can
just trigger complaints about "cmd node not available" or "card is
removed", but I haven't yet found a true bug.

That's not to say that there aren't such bugs out there. I'd still be
willing to bet there are. And IMO, it seems wise to just do the same
teardown/setup as one would do for (e.g.) 'rmmod', to prevent exposing
*too* many new permutations of "wiphy is available but rest of the
driver is torn down".

But if none of this is convincing to you, I can take a stab at a
different solution.

BTW, since you're taking an interest in this code now, can I trouble you
with a question? Looking at mwifiex_uninit_sw() (after this patchset),
you can see a loop like this:

        /* Stop data */
        for (i = 0; i < adapter->priv_num; i++) {
                priv = adapter->priv[i];
                if (priv && priv->netdev) {
                        mwifiex_stop_net_dev_queue(priv->netdev, adapter);
                        if (netif_carrier_ok(priv->netdev))
                                netif_carrier_off(priv->netdev);
                        netif_device_detach(priv->netdev);
                }
        }

That seems to be the only attempt to prevent user space from talking to
the device while we proceed to shut down (mwifiex_shutdown_drv()). AIUI,
that's wholly insufficient, and we need to actually stop all the virtual
interfaces (and possibly the wiphy as well) first. I'm looking at trying
to move the mwifiex_del_virtual_intf() loop up much further in this
function (but there are other bugs preventing me from doing that yet).

Does that sound like the right approach to you? I'm kinda figuring this
should better mimic the mac80211 ieee80211_remove_interfaces()
structure.

Brian
