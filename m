Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:50244 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab3GFFcT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jul 2013 01:32:19 -0400
Message-ID: <51D7ABC6.40307@rempel-privat.de> (sfid-20130706_073222_775142_3EF052C5)
Date: Sat, 06 Jul 2013 07:31:50 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [ath9k-devel] ath: Unable to remove station entry
References: <51D68B55.3070309@msgid.tls.msk.ru>
In-Reply-To: <51D68B55.3070309@msgid.tls.msk.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michael,

there is no way to avoid latest wireless-testing kernel. I had similar 
problems for some kernel version. But now it seems to work more or less 
ok. For example it will nuke complete system only by triggering some bug 
in xhcd driver :)


Am 05.07.2013 11:01, schrieb Michael Tokarev:
> Hello.
>
> Recently I bought a TP-Link TL-WN821N v3 802.11n USB adaptor,
> and tried to use it as an access point for a small Wireless LAN.
>
> It works fine so far, except of one issue.
>
> Quite often to be really annoying, it stops working with the
> following message in kernel log:
>
> Jul  5 09:51:26 gnome vmunix: [133814.449408] ath: Unable to remove station entry for: 38:aa:3c:02:07:f1
>
> after this, the interface is stuck, it can't be seen over WIFI,
> and any attempt to do anything with it inside the host results
> in more processes entering D state (initially right when this
> happens, there's a kworker process in D state).
>
> For example, `rmmod ath9k_htc' - which appears to be a topmost
> module on the stack - results in rmmod entering D state, with
> the following stack:
>
>   rmmod           D 000000010266c10c     0 10684  10643 0x00000000
>    ffffffff8148b020 0000000000000082 0000000000012400 ffff88012ae9d7d0
>    ffff880114843fd8 ffff880114843fd8 ffff880114843fd8 ffff88012ae9d7d0
>    0000000125aa5040 ffffffff8148b020 0000000000012400 ffff8801298cb500
>   Call Trace:
>    [<ffffffff81367a59>] ? __schedule+0x3a9/0x960
>    [<ffffffff810558f0>] ? usleep_range+0x40/0x40
>    [<ffffffff81368e38>] ? __mutex_lock_slowpath+0xc8/0x140
>    [<ffffffff813689ba>] ? mutex_lock+0x1a/0x40
>    [<ffffffffa025bc66>] ? ath9k_wmi_cmd+0xc6/0x200 [ath9k_htc]
>    [<ffffffffa02614d8>] ? ath9k_regread+0x38/0x50 [ath9k_htc]
>    [<ffffffffa0076849>] ? ath_hw_keyreset+0x59/0x220 [ath]
>    [<ffffffffa0076a2d>] ? ath_key_delete+0x1d/0xdc [ath]
>    [<ffffffffa025edc5>] ? ath9k_htc_set_key+0x85/0x130 [ath9k_htc]
>    [<ffffffffa0230d19>] ? ieee80211_key_disable_hw_accel+0x89/0x130 [mac80211]
>    [<ffffffffa0230ddc>] ? __ieee80211_key_destroy+0x1c/0x80 [mac80211]
>    [<ffffffffa0231505>] ? ieee80211_free_keys+0x45/0x80 [mac80211]
>    [<ffffffffa02233a7>] ? ieee80211_do_stop+0x1f7/0x5c0 [mac80211]
>    [<ffffffff812d9f40>] ? dev_deactivate_many+0x1f0/0x240
>    [<ffffffffa0223785>] ? ieee80211_stop+0x15/0x20 [mac80211]
>    [<ffffffff812bc505>] ? __dev_close_many+0x85/0xd0
>    [<ffffffff812bc638>] ? dev_close_many+0x98/0x110
>    [<ffffffff812bc788>] ? rollback_registered_many+0xd8/0x250
>    [<ffffffff812bc90e>] ? unregister_netdevice_many+0xe/0x60
>    [<ffffffffa0222f00>] ? ieee80211_remove_interfaces+0xc0/0x100 [mac80211]
>    [<ffffffffa0211096>] ? ieee80211_unregister_hw+0x46/0x110 [mac80211]
>    [<ffffffffa02624c4>] ? ath9k_htc_disconnect_device+0x54/0xd0 [ath9k_htc]
>    [<ffffffffa025b3a2>] ? ath9k_hif_usb_disconnect+0x52/0x150 [ath9k_htc]
>    [<ffffffffa005dd52>] ? usb_unbind_interface+0x42/0x150 [usbcore]
>    [<ffffffff81274546>] ? __device_release_driver+0x76/0xe0
>    [<ffffffff81274bf0>] ? driver_detach+0xa0/0xb0
>    [<ffffffff812743d0>] ? bus_remove_driver+0x70/0xc0
>    [<ffffffffa005d7a6>] ? usb_deregister+0xa6/0xc0 [usbcore]
>    [<ffffffffa0262d36>] ? ath9k_htc_exit+0x6/0x16 [ath9k_htc]
>    [<ffffffff81080ee2>] ? sys_delete_module+0x132/0x260
>    [<ffffffff8136a245>] ? page_fault+0x25/0x30
>    [<ffffffff81371552>] ? system_call_fastpath+0x16/0x1b
>
> followed by:
>
> Jul  5 10:02:27 gnome vmunix: [134474.473451] ath: Unable to remove interface at idx: 0
>
> (rmmod is stuck forever).
>
> Now, in order to make the interface to work again, the only way I
> found so far is to _reboot_ the machine.  For example, re-plugging
> the USB cord does not help, because, as far as I can see, the driver
> is in some weird state and can't initialize the new interface.
>
> This is a 3.2.0-stable kernel (right now 3.2.46), x86-64 (amd64),
> self-compiled, without additional patches.
>
>
> There are a few references to this message on the 'net, including
> one mentioning this very card (in russian) --
>
>    http://forums.opensuse.org/p-russian/dhydhdhdhdhundhdhdh/1046-1077-1083-1077-1079-1086/469022-wifi-usb-tp-link-tl-wn821n.html
>
> they claim the problem has been fixed for _some_ by upgrading the
> BIOS on the motherboard.  Maybe this is actually related, because
> as far as I can tell, this started happening _after_ I upgraded
> BIOS on my motherboard, so it may be related to the bios changes.
> I don't recall whenever I noticed this erratic behavour before I
> upgraded BIOS.  Looking at the BIOS history, I don't see anything
> interesting about USB in the changelog, except this:
>
>   * Fixed issue with Fast Boot so USB devices still work under DOS
>     if USB Optimization is enabled.
>
> This is an intel atom-based D2500CC board, with the latest BIOS.
> I had to update bios because of another issue which is now fixed,
> but I can't go back to the old bios because the old one was too
> old and current motherboard refuses to flash it.
>
>
> What can be done to diagnose the problem?  I can give a more recent
> kernel a try, but I'd love to see it fixed for a -stable kernel which
> is used by several major distributions.  Also, the problem is not
> easy to trigger, the system may work for a few days without issues
> or may stop working in a few hours, irrespective of the load (f.e.
> the above example at 09:51 was me awakening my android phone just
> to see what time it is now, and it trying to connect/disconnect
> to/from the default wifi network -- there were no other devices
> using wifi at that time).
>
> Thanks,
>
> /mjt
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>


-- 
Regards,
Oleksij
