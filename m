Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58918 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932385Ab0JRWrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 18:47:09 -0400
Received: by iwn7 with SMTP id 7so64473iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Oct 2010 15:47:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CBB5218.60302@candelatech.com>
References: <20101014231958.GA3242@tux> <4CB79299.7000005@candelatech.com>
 <AANLkTinQmE6wm1pXkRL6p_3rkMvNrppmirjj3-jagMp8@mail.gmail.com>
 <20101014234853.GA10113@tux> <4CB886AF.3070800@candelatech.com>
 <AANLkTinhFj_iYjVzyfSfpUVdytfk4O9kCBnN8=Bwv0N7@mail.gmail.com>
 <4CB8AD3F.50201@candelatech.com> <20101015210720.GA2007@tux>
 <20101015232140.GA1796@tux> <4CB8E4DE.9070706@candelatech.com>
 <20101015233814.GA1866@tux> <4CB8E6D7.602@candelatech.com>
 <AANLkTi=tJZ0L1JoE=VPzJVEx1nnB0Td2E9V45RkFAPC8@mail.gmail.com> <4CBB5218.60302@candelatech.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 18 Oct 2010 15:46:48 -0700
Message-ID: <AANLkTimATNwgTv5gp_5P3g7vezdQ0zjifGFNvWvLiVRv@mail.gmail.com>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
To: Ben Greear <greearb@candelatech.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 17, 2010 at 12:44 PM, Ben Greear <greearb@candelatech.com> wrote:
> I had a chance to try your latest patch on a different machine and AP.  This
> time,
> I was using 130 or so stations, but no encryption (no supplicant).
>
> I saw these exceptions below.  The warn-on hits the !stopped check in
> ath_stoprecv.
>
> The system didn't crash, but all of the STAs soon dis-associated because of
> "inactivity".
> I haven't checked if that is some issue with my AP or what..
>
>
> bool ath_stoprecv(struct ath_softc *sc)
> {
>        struct ath_hw *ah = sc->sc_ah;
>        bool stopped;
>
>        spin_lock_bh(&sc->rx.rxbuflock);
>        ath9k_hw_stoppcurecv(ah);
>        ath9k_hw_setrxfilter(ah, 0);
>        stopped = ath9k_hw_stopdmarecv(ah);
>
>        if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
>                ath_edma_stop_recv(sc);
>        else
>                sc->rx.rxlink = NULL;
>        spin_unlock_bh(&sc->rx.rxbuflock);
>
>        WARN_ON(!stopped);
>        return stopped;
> }
>
>
> ADDRCONF(NETDEV_UP): sta130: link is not ready
> sta90: no IPv6 routers present
> ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x40000020

We should find out what happened here.

> ------------[ cut here ]------------
> WARNING: at
> /home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath9k/recv.c:532
> ath_stoprecv+0x80/0x87 [ath9k]()
> Hardware name: 945GM
> Modules linked in: 8021q garp stp llc michael_mic macvlan pktgen iscsi_tcp
> libiscsi_tcp libiscsi scsi_transport_iscsi nfs lockd fscache nfs_acl
> auth_rpcgss sunrpc p4_clockmod ipv6 uinput arc4 ecb ath9k snd_intel8x0
> mac80211 snd_ac97_codec ac97_bus snd_seq snd_seq_device ath9k_common snd_pcm
> ath9k_hw ath snd_timer microcode pcspkr cfg80211 i2c_i801 snd soundcore
> snd_page_alloc serio_raw e1000e iTCO_wdt iTCO_vendor_support yenta_socket
> floppy i915 drm_kms_helper drm i2c_algo_bit i2c_core video output [last
> unloaded: ipt_addrtype]
> Pid: 5, comm: kworker/u:0 Tainted: G        W   2.6.36-rc8-wl+ #12
> Call Trace:
>  [<c0434647>] warn_slowpath_common+0x65/0x7a
>  [<f9450e38>] ? ath_stoprecv+0x80/0x87 [ath9k]
>  [<c043466b>] warn_slowpath_null+0xf/0x13
>  [<f9450e38>] ath_stoprecv+0x80/0x87 [ath9k]
>  [<f944f580>] ath_set_channel+0x99/0x1ff [ath9k]
>  [<f94502b2>] ath9k_config+0x305/0x3d8 [ath9k]
>  [<f9246a2e>] ieee80211_hw_config+0x11b/0x125 [mac80211]
>  [<f924aa51>] ieee80211_scan_work+0x29e/0x3ed [mac80211]
>  [<c0443d72>] ? process_one_work+0x145/0x295
>  [<c0443dbc>] process_one_work+0x18f/0x295
>  [<c0443d72>] ? process_one_work+0x145/0x295
>  [<f924a7b3>] ? ieee80211_scan_work+0x0/0x3ed [mac80211]
>  [<c04453e5>] worker_thread+0xf9/0x1b8
>  [<c04452ec>] ? worker_thread+0x0/0x1b8
>  [<c0447d2f>] kthread+0x62/0x67
>  [<c0447ccd>] ? kthread+0x0/0x67
>  [<c0403506>] kernel_thread_helper+0x6/0x1a
> ---[ end trace bc53fa727ee2ae42 ]---
> ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
> ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x40000020
> ------------[ cut here ]------------
> WARNING: at
> /home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath9k/recv.c:532
> ath_stoprecv+0x80/0x87 [ath9k]()
> Hardware name: 945GM
> Modules linked in: 8021q garp stp llc michael_mic macvlan pktgen iscsi_tcp
> libiscsi_tcp libiscsi scsi_transport_iscsi nfs lockd fscache nfs_acl
> auth_rpcgss sunrpc p4_clockmod ipv6 uinput arc4 ecb ath9k snd_intel8x0
> mac80211 snd_ac97_codec ac97_bus snd_seq snd_seq_device ath9k_common snd_pcm
> ath9k_hw ath snd_timer microcode pcspkr cfg80211 i2c_i801 snd soundcore
> snd_page_alloc serio_raw e1000e iTCO_wdt iTCO_vendor_support yenta_socket
> floppy i915 drm_kms_helper drm i2c_algo_bit i2c_core video output [last
> unloaded: ipt_addrtype]
> Pid: 41, comm: kworker/u:2 Tainted: G        W   2.6.36-rc8-wl+ #12
> Call Trace:
>  [<c0434647>] warn_slowpath_common+0x65/0x7a
>  [<f9450e38>] ? ath_stoprecv+0x80/0x87 [ath9k]
>  [<c043466b>] warn_slowpath_null+0xf/0x13
>  [<f9450e38>] ath_stoprecv+0x80/0x87 [ath9k]
>  [<f944f580>] ath_set_channel+0x99/0x1ff [ath9k]
>  [<f94502b2>] ath9k_config+0x305/0x3d8 [ath9k]
>  [<f9246a2e>] ieee80211_hw_config+0x11b/0x125 [mac80211]
>  [<f924aa51>] ieee80211_scan_work+0x29e/0x3ed [mac80211]
>  [<c0443d72>] ? process_one_work+0x145/0x295
>  [<c0443dbc>] process_one_work+0x18f/0x295
>  [<c0443d72>] ? process_one_work+0x145/0x295
>  [<f924a7b3>] ? ieee80211_scan_work+0x0/0x3ed [mac80211]
>  [<c04453e5>] worker_thread+0xf9/0x1b8
>  [<c04452ec>] ? worker_thread+0x0/0x1b8
>  [<c0447d2f>] kthread+0x62/0x67
>  [<c0447ccd>] ? kthread+0x0/0x67
>  [<c0403506>] kernel_thread_helper+0x6/0x1a
> ---[ end trace bc53fa727ee2ae43 ]---
> ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
> sta126: direct probe to 00:18:e7:cb:ad:6e (try 1)
> sta130: direct probe to 00:18:e7:cb:ad:6e (try 1)
> sta91: no IPv6 routers present
> sta126: direct probe to 00:18:e7:cb:ad:6e (try 2)
> sta130: direct probe to 00:18:e7:cb:ad:6e (try 2)
> sta126: direct probe to 00:18:e7:cb:ad:6e (try 3)
> sta130: direct probe to 00:18:e7:cb:ad:6e (try 3)
> sta126: direct probe to 00:18:e7:cb:ad:6e timed out
> sta130: direct probe to 00:18:e7:cb:ad:6e timed out
> sta92: no IPv6 routers present
> ...

So I put the warning there for debugging purposes. The reason I put it
is we have no gaurantee we've told hardware to stop writing to that
area of memory so if we then race and start RX I think we can likely
run into a situation where we may not know which buffer hardware will
be writing to next.

I think we should add the warning on the next kernel development cycle
and address all of its causes, if hardware cannot be stopped I believe
we run the potential to also run into this same poison issue.

The RX poison issue is resolved then but the other issues are separate
issues which need to be debugged further. For example the stop TX dma
issue might be resolved by also preventing to start TX and stop TX
atomically. Something like what I did could likely also be done for
TX.

When I get some time (I have other uber higher priority issues now as
usual) I'll break this patch into a 3 or 2 patches and submit
upstream.

  Luis
