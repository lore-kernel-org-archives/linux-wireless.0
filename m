Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:51115 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbZHTUOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 16:14:39 -0400
Received: by yxe5 with SMTP id 5so185475yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 13:14:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0908192022g7d6a52b1v54f8bed16844c87e@mail.gmail.com>
References: <445f43ac0908191633xf9348cdu5bbdd3ac08e13260@mail.gmail.com>
	 <b6c5339f0908192022g7d6a52b1v54f8bed16844c87e@mail.gmail.com>
Date: Thu, 20 Aug 2009 13:14:40 -0700
Message-ID: <445f43ac0908201314h3aa10a00pc55f448be168ba64@mail.gmail.com>
Subject: Re: ath9k mesh beaconing behavior
From: Javier Cardona <javier@cozybit.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Andrey Yurovsky <andrey@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob,

Thanks for the pointer.  I reviewed the ath9k looking for ordering
problems in configuring the opmode.  I could not see anything wrong.
The opmode is set to NL80211_IFTYPE_MONITOR (6) when the device is
started, and to NL80211_IFTYPE_MESH_POINT (7) on add_interface.  At
that point beaconing is enabled and there is a new reset.  But I'm new
to this card, so I'm probably overlooking something.

I added the following tags to the code:

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1579,6 +1579,8 @@ static void ath9k_hw_set_operating_mode(struct
ath_hw *ah, int opmode)

        val = REG_READ(ah, AR_STA_ID1);
        val &= ~(AR_STA_ID1_STA_AP | AR_STA_ID1_ADHOC);
+       printk("ath9k_hw_set_operating_mode: %d\n", opmode);
+       WARN_ON(1);
        switch (opmode) {
        case NL80211_IFTYPE_AP:
                REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_STA_AP
diff --git a/drivers/net/wireless/ath/ath9k/main.c
b/drivers/net/wireless/ath/ath9k/main.c
index 9b9b4e8..730607e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1939,6 +1939,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
         * and then setup of the interrupt mask.
         */
        spin_lock_bh(&sc->sc_resetlock);
+       printk("ath9k_start: sc_ah=%p opmode = %d\n", sc->sc_ah,
sc->sc_ah->opmode);
        r = ath9k_hw_reset(sc->sc_ah, init_channel, false);
        if (r) {
                DPRINTF(sc, ATH_DBG_FATAL,
@@ -2207,6 +2208,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
        }

        /* Set the device opmode */
+       printk("ath9k_add_interface: sc_ah=%p opmode=%d\n", sc->sc_ah,
ic_opmode);
        sc->sc_ah->opmode = ic_opmode;

        /*

And this is the dmesg output after executing

modprobe ath9k debug=0x100
iw phy phy0 interface add mesh type mp mesh_id kangaroo
iw dev mesh set channel 11
ifconfig mesh up

dmesg:
[ 1977.840919] ath9k_start: sc_ah=c7398000 opmode = 6
[ 1977.844540] ath9k_hw_set_operating_mode: 6
[ 1977.844972] ------------[ cut here ]------------
[ 1977.845710] WARNING: at drivers/net/wireless/ath/ath9k/hw.c:1583
ath9k_hw_set_operating_mode+0x36/0xb6 [ath9k]()
[ 1977.846530] Hardware name: Uknown
[ 1977.846890] Modules linked in: ath9k mac80211 ath cfg80211 rfkill
[last unloaded: rfkill]
[ 1977.848896] Pid: 1725, comm: ifconfig Not tainted 2.6.31-rc6-wl #18
[ 1977.849505] Call Trace:
[ 1977.849931]  [<c021f5ea>] warn_slowpath_common+0x60/0x77
[ 1977.850611]  [<c021f60e>] warn_slowpath_null+0xd/0x10
[ 1977.851320]  [<c988e12f>] ath9k_hw_set_operating_mode+0x36/0xb6 [ath9k]
[ 1977.852243]  [<c9890b2b>] ath9k_hw_reset+0x705/0xe8a [ath9k]
[ 1977.852967]  [<c0220034>] ? printk+0x15/0x17
[ 1977.853796]  [<c989f182>] ath9k_start+0xd6/0x1c1 [ath9k]
[ 1977.854764]  [<c9868768>] ieee80211_open+0x1ec/0x4bf [mac80211]
[ 1977.855482]  [<c023217e>] ? __raw_notifier_call_chain+0xe/0x10
[ 1977.856068]  [<c04e5581>] dev_open+0x8a/0xc5
[ 1977.856688]  [<c04e31d0>] dev_change_flags+0x95/0x143
[ 1977.857234]  [<c0527e3e>] devinet_ioctl+0x210/0x45a
[ 1977.857877]  [<c0529d49>] inet_ioctl+0x88/0xa1
[ 1977.858508]  [<c04d6b1f>] ? sock_ioctl+0x0/0x1ee
[ 1977.859016]  [<c04d6ceb>] sock_ioctl+0x1cc/0x1ee
[ 1977.859640]  [<c04d6b1f>] ? sock_ioctl+0x0/0x1ee
[ 1977.860136]  [<c0290a39>] vfs_ioctl+0x19/0x50
[ 1977.860725]  [<c02912dd>] do_vfs_ioctl+0x472/0x4aa
[ 1977.861231]  [<c032575c>] ? selinux_file_ioctl+0x39/0x3d
[ 1977.861892]  [<c0291355>] sys_ioctl+0x40/0x5a
[ 1977.862525]  [<c0202a55>] syscall_call+0x7/0xb
[ 1977.862994] ---[ end trace 7b9c48f5bc2a0542 ]---
[ 1977.867463] ath9k_hw_set_operating_mode: 6
[ 1977.867910] ------------[ cut here ]------------
[ 1977.868702] WARNING: at drivers/net/wireless/ath/ath9k/hw.c:1583
ath9k_hw_set_operating_mode+0x36/0xb6 [ath9k]()
[ 1977.869583] Hardware name: Uknown
[ 1977.869964] Modules linked in: ath9k mac80211 ath cfg80211 rfkill
[last unloaded: rfkill]
[ 1977.872049] Pid: 1725, comm: ifconfig Tainted: G        W  2.6.31-rc6-wl #18
[ 1977.872714] Call Trace:
[ 1977.873149]  [<c021f5ea>] warn_slowpath_common+0x60/0x77
[ 1977.873837]  [<c021f60e>] warn_slowpath_null+0xd/0x10
[ 1977.874631]  [<c988e12f>] ath9k_hw_set_operating_mode+0x36/0xb6 [ath9k]
[ 1977.875331]  [<c988e1bd>] ath9k_hw_setopmode+0xe/0x10 [ath9k]
[ 1977.876326]  [<c98a1ea0>] ath_startrecv+0x96/0xc6 [ath9k]
[ 1977.877261]  [<c989f1c4>] ath9k_start+0x118/0x1c1 [ath9k]
[ 1977.878265]  [<c9868768>] ieee80211_open+0x1ec/0x4bf [mac80211]
[ 1977.879005]  [<c023217e>] ? __raw_notifier_call_chain+0xe/0x10
[ 1977.879737]  [<c04e5581>] dev_open+0x8a/0xc5
[ 1977.880237]  [<c04e31d0>] dev_change_flags+0x95/0x143
[ 1977.880928]  [<c0527e3e>] devinet_ioctl+0x210/0x45a
[ 1977.881604]  [<c0529d49>] inet_ioctl+0x88/0xa1
[ 1977.882110]  [<c04d6b1f>] ? sock_ioctl+0x0/0x1ee
[ 1977.882759]  [<c04d6ceb>] sock_ioctl+0x1cc/0x1ee
[ 1977.883276]  [<c04d6b1f>] ? sock_ioctl+0x0/0x1ee
[ 1977.883941]  [<c0290a39>] vfs_ioctl+0x19/0x50
[ 1977.884597]  [<c02912dd>] do_vfs_ioctl+0x472/0x4aa
[ 1977.885125]  [<c032575c>] ? selinux_file_ioctl+0x39/0x3d
[ 1977.885806]  [<c0291355>] sys_ioctl+0x40/0x5a
[ 1977.886306]  [<c0202a55>] syscall_call+0x7/0xb
[ 1977.886905] ---[ end trace 7b9c48f5bc2a0543 ]---
[ 1978.356622] ath9k_add_interface: sc_ah=c7398000 opmode=7
[ 1978.358378] ath9k: IBSS nexttbtt 4000 intval 1000 (1000)
[ 1978.358531] ath9k: TXDP9 = 7387000 (c7387000)
[ 1978.361738] ath9k_hw_set_operating_mode: 7
[ 1978.362168] ------------[ cut here ]------------
[ 1978.362938] WARNING: at drivers/net/wireless/ath/ath9k/hw.c:1583
ath9k_hw_set_operating_mode+0x36/0xb6 [ath9k]()
[ 1978.363798] Hardware name: Uknown
[ 1978.364173] Modules linked in: ath9k mac80211 ath cfg80211 rfkill
[last unloaded: rfkill]
[ 1978.366162] Pid: 1725, comm: ifconfig Tainted: G        W  2.6.31-rc6-wl #18
[ 1978.366809] Call Trace:
[ 1978.367240]  [<c021f5ea>] warn_slowpath_common+0x60/0x77
[ 1978.367910]  [<c021f60e>] warn_slowpath_null+0xd/0x10
[ 1978.368738]  [<c988e12f>] ath9k_hw_set_operating_mode+0x36/0xb6 [ath9k]
[ 1978.369661]  [<c9890b2b>] ath9k_hw_reset+0x705/0xe8a [ath9k]
[ 1978.370321]  [<c988b4f2>] ? ath9k_ioread32+0x2f/0x32 [ath9k]
[ 1978.371299]  [<c989f316>] ath_set_channel+0xa9/0x135 [ath9k]
[ 1978.372208]  [<c98a0f12>] ath9k_config+0x1c4/0x231 [ath9k]
[ 1978.373135]  [<c985f5f9>] ieee80211_hw_config+0x86/0x8e [mac80211]
[ 1978.374105]  [<c986897d>] ieee80211_open+0x401/0x4bf [mac80211]
[ 1978.374789]  [<c04e5581>] dev_open+0x8a/0xc5
[ 1978.375372]  [<c04e31d0>] dev_change_flags+0x95/0x143
[ 1978.375919]  [<c0527e3e>] devinet_ioctl+0x210/0x45a
[ 1978.376559]  [<c0529d49>] inet_ioctl+0x88/0xa1
[ 1978.377064]  [<c04d6b1f>] ? sock_ioctl+0x0/0x1ee
[ 1978.377690]  [<c04d6ceb>] sock_ioctl+0x1cc/0x1ee
[ 1978.378196]  [<c04d6b1f>] ? sock_ioctl+0x0/0x1ee
[ 1978.378829]  [<c0290a39>] vfs_ioctl+0x19/0x50
[ 1978.379449]  [<c02912dd>] do_vfs_ioctl+0x472/0x4aa
[ 1978.379971]  [<c032575c>] ? selinux_file_ioctl+0x39/0x3d
[ 1978.380628]  [<c0291355>] sys_ioctl+0x40/0x5a
[ 1978.381116]  [<c0202a55>] syscall_call+0x7/0xb
[ 1978.381691] ---[ end trace 7b9c48f5bc2a0544 ]---
[ 1978.384718] ath9k_hw_set_operating_mode: 7
[ 1978.385157] ------------[ cut here ]------------
[ 1978.385944] WARNING: at drivers/net/wireless/ath/ath9k/hw.c:1583
ath9k_hw_set_operating_mode+0x36/0xb6 [ath9k]()
[ 1978.386814] Hardware name: Uknown
[ 1978.387186] Modules linked in: ath9k mac80211 ath cfg80211 rfkill
[last unloaded: rfkill]
[ 1978.389095] Pid: 1725, comm: ifconfig Tainted: G        W  2.6.31-rc6-wl #18
[ 1978.389719] Call Trace:
[ 1978.390143]  [<c021f5ea>] warn_slowpath_common+0x60/0x77
[ 1978.390832]  [<c021f60e>] warn_slowpath_null+0xd/0x10
[ 1978.391675]  [<c988e12f>] ath9k_hw_set_operating_mode+0x36/0xb6 [ath9k]
[ 1978.392609]  [<c988e1bd>] ath9k_hw_setopmode+0xe/0x10 [ath9k]
[ 1978.393262]  [<c98a1ea0>] ath_startrecv+0x96/0xc6 [ath9k]
[ 1978.394299]  [<c989f355>] ath_set_channel+0xe8/0x135 [ath9k]
[ 1978.395230]  [<c98a0f12>] ath9k_config+0x1c4/0x231 [ath9k]
[ 1978.396177]  [<c985f5f9>] ieee80211_hw_config+0x86/0x8e [mac80211]
[ 1978.397187]  [<c986897d>] ieee80211_open+0x401/0x4bf [mac80211]
[ 1978.397940]  [<c04e5581>] dev_open+0x8a/0xc5
[ 1978.398582]  [<c04e31d0>] dev_change_flags+0x95/0x143
[ 1978.399143]  [<c0527e3e>] devinet_ioctl+0x210/0x45a
[ 1978.399787]  [<c0529d49>] inet_ioctl+0x88/0xa1
[ 1978.400429]  [<c04d6b1f>] ? sock_ioctl+0x0/0x1ee
[ 1978.400943]  [<c04d6ceb>] sock_ioctl+0x1cc/0x1ee
[ 1978.401588]  [<c04d6b1f>] ? sock_ioctl+0x0/0x1ee
[ 1978.402104]  [<c0290a39>] vfs_ioctl+0x19/0x50
[ 1978.402715]  [<c02912dd>] do_vfs_ioctl+0x472/0x4aa
[ 1978.403202]  [<c032575c>] ? selinux_file_ioctl+0x39/0x3d
[ 1978.403829]  [<c0291355>] sys_ioctl+0x40/0x5a
[ 1978.404448]  [<c0202a55>] syscall_call+0x7/0xb
[ 1978.404908] ---[ end trace 7b9c48f5bc2a0545 ]---

Any suggestions will be greatly appreciated.

Thanks,

Javier

On Wed, Aug 19, 2009 at 8:22 PM, Bob Copeland<me@bobcopeland.com> wrote:
> On Wed, Aug 19, 2009 at 7:33 PM, Javier Cardona<javier@cozybit.com> wrote:
>> Hi,
>>
>> Could someone familiar with the ath9k help us solve a problem with
>> mesh beaconing?
>
> I am not too familiar with ath9k, but I would suspect that
> there's an ordering issue with when enable_beacon is recognized,
> so beaconing doesn't start until the next reset() is called.
>
> E.g. this fix for ath5k sounds similar:
>
> commit 9718512d81a7f7bd0166d1e033f8395022ecb2e9
> Author: Bob Copeland <me@bobcopeland.com>
> Date:   Wed Jul 29 10:29:03 2009 -0400
>
>    ath5k: update PCU opmode whenever a new interface is added
>
> --
> Bob Copeland %% www.bobcopeland.com
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
