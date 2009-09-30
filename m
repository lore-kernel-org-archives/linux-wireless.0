Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:36096 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbZI3XNE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 19:13:04 -0400
Received: by iwn8 with SMTP id 8so3935879iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2009 16:13:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890909291224t26b7e6cbmc78976165bd1bb88@mail.gmail.com>
References: <43e72e890909291224t26b7e6cbmc78976165bd1bb88@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 30 Sep 2009 16:12:47 -0700
Message-ID: <43e72e890909301612v5079c9bco9ac8529f77a7c67a@mail.gmail.com>
Subject: Re: SME warning on 2.6.32-rc<bleh>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 29, 2009 at 12:24 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> I believe the problem comes from the assumption from cfg80211 that
> previous deauthentications would have gone through before we run
> __cfg80211_disconnected() and are using wext or nl80211
> connec/disconnectt. Under certain conditions (clearly not known yet)
> this is not true and we'll end up asking mac80211 to deauthenticate us
> from a BSS we already deauthenticated to end end up with an -ENOLINK
> on our mac80211 cfg80211 deauth ops. It seems this race was expected
> all along on mac80211 ieee80211_mgd_deauth():
>
>        /*
>         * cfg80211 should catch this ... but it's racy since
>         * we can receive a deauth frame, process it, hand it
>         * to cfg80211 while that's in a locked section already
>         * trying to tell us that the user wants to disconnect.
>         */
>        if (!bssid) {
>                mutex_unlock(&ifmgd->mtx);
>                return -ENOLINK;
>        }
>
> So it seems we do need to address that race but I'm not yet sure how.
>
> Here is a warning from the latest wireless-testing. Unfortunately I
> cannot reproduce in a systematic way, I've tried even different boot
> configuration (mem=300M) and CPU pegged at 800 MHz thinking the race
> occurs when mac80211 takes its sweet time deathenticating but that
> wasn't the case.

OK so I just got this again today with a cardbus card. The curious
thing to see was that it happened when I rmmod'd ath9k right after
these messages:

[  234.481226] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
AR_DIAG_SW=0x40000020
[  234.928823] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
AR_DIAG_SW=0x40000020
[  237.064792] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
AR_DIAG_SW=0x40000020
[  310.676842] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
AR_DIAG_SW=0x40000020

There were quite a lot of these. I was then thinking perhaps it has to
do with mac80211 assuming a hardware state which we obviously are not
in yet but then again -- I believe I've seen these with ath5k as well.

Here's the new shiny warning as of today's wireless testing (john just updated)

[  701.025450] phy1: device now idle
[  701.025503] phy1: Removed STA <myh-ap>
[  701.036691] phy1: Destroyed STA <my-ap>
[  701.036725] wlan3: deauthenticating from <my-ap> by local choice (reason=3)
[  701.036848] ------------[ cut here ]------------
[  701.036862] WARNING: at net/wireless/sme.c:620
__cfg80211_disconnected+0x209/0x260 [cfg80211]()
[  701.036866] Hardware name: 7660A14
[  701.036868] deauth failed: -67 (editorial note: -ENOLINK)
[  701.036870] Modules linked in: ath9k(-) ath9k_hw (shiny new
module!) ath <etc>
[  701.036944] Pid: 4432, comm: rmmod Not tainted 2.6.32-rc2-wl #47
[  701.036947] Call Trace:
[  701.036956]  [<ffffffff8105be78>] warn_slowpath_common+0x78/0xb0
[  701.036960]  [<ffffffff8105bf0c>] warn_slowpath_fmt+0x3c/0x40
[  701.036970]  [<ffffffffa00df439>]
__cfg80211_disconnected+0x209/0x260 [cfg80211]
[  701.036980]  [<ffffffffa00dd158>]
__cfg80211_send_deauth+0x228/0x2a0 [cfg80211]
[  701.036989]  [<ffffffffa00dd211>] cfg80211_send_deauth+0x41/0x80 [cfg80211]
[  701.037003]  [<ffffffffa01d4c1f>]
ieee80211_send_deauth_disassoc+0x14f/0x170 [mac80211]
[  701.037014]  [<ffffffffa01d7945>] ieee80211_mgd_deauth+0xf5/0x120 [mac80211]
[  701.037025]  [<ffffffffa01dbfa9>] ieee80211_deauth+0x19/0x20 [mac80211]
[  701.037034]  [<ffffffffa00dbb5e>] __cfg80211_mlme_deauth+0xee/0x130
[cfg80211]
[  701.037042]  [<ffffffffa00cb22c>] ?
cfg80211_netdev_notifier_call+0xdc/0x400 [cfg80211]
[  701.037048]  [<ffffffff8108f1bc>] ? mark_held_locks+0x6c/0xa0
[  701.037057]  [<ffffffffa00df9a9>] __cfg80211_disconnect+0x159/0x1d0
[cfg80211]
[  701.037065]  [<ffffffffa00cb261>]
cfg80211_netdev_notifier_call+0x111/0x400 [cfg80211]
[  701.037072]  [<ffffffff81538ea7>] notifier_call_chain+0x47/0x90
[  701.037078]  [<ffffffff8107fc51>] raw_notifier_call_chain+0x11/0x20
[  701.037084]  [<ffffffff8144cb46>] call_netdevice_notifiers+0x16/0x20
[  701.037088]  [<ffffffff8144d335>] dev_close+0x55/0xb0
[  701.037092]  [<ffffffff8144d6f8>] rollback_registered+0x48/0x120
[  701.037097]  [<ffffffff8144d7ed>] unregister_netdevice+0x1d/0x70
[  701.037107]  [<ffffffffa01d8d36>]
ieee80211_remove_interfaces+0x86/0xc0 [mac80211]
[  701.037115]  [<ffffffffa01cc0a2>] ieee80211_unregister_hw+0x42/0xf0
[mac80211]
[  701.037123]  [<ffffffffa04879b6>] ath_detach+0x86/0x170 [ath9k]
[  701.037129]  [<ffffffffa0487ac0>] ath_cleanup+0x20/0x60 [ath9k]
[  701.037136]  [<ffffffffa04912e9>] ath_pci_remove+0x19/0x20 [ath9k]
[  701.037141]  [<ffffffff812aeb2f>] pci_device_remove+0x2f/0x60
[  701.037147]  [<ffffffff81343850>] __device_release_driver+0x70/0xe0
[  701.037151]  [<ffffffff81343980>] driver_detach+0xc0/0xd0
[  701.037155]  [<ffffffff813428a8>] bus_remove_driver+0x98/0xc0
[  701.037159]  [<ffffffff81343f8a>] driver_unregister+0x5a/0x90
[  701.037164]  [<ffffffff812aee3f>] pci_unregister_driver+0x3f/0xb0
[  701.037170]  [<ffffffffa0491190>] ath_pci_exit+0x10/0x20 [ath9k]
[  701.037176]  [<ffffffffa04935e5>] ath9k_exit+0x9/0x2a [ath9k]
[  701.037180]  [<ffffffff8109c17a>] sys_delete_module+0x1aa/0x270
[  701.037186]  [<ffffffff81012975>] ? retint_swapgs+0x13/0x1b
[  701.037191]  [<ffffffff8153579f>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  701.037196]  [<ffffffff81011ec2>] system_call_fastpath+0x16/0x1b
[  701.037199] ---[ end trace 6c7b2b3bef84cccc ]---
[  702.431558] ath9k 0000:16:00.0: PCI INT A disabled
[  702.433718] ath9k: Driver unloaded

  Luis
