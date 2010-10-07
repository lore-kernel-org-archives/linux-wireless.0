Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51056 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab0JGVbx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 17:31:53 -0400
Received: by yxp4 with SMTP id 4so124537yxp.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Oct 2010 14:31:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1286479642.20974.32.camel@jlt3.sipsolutions.net>
References: <4CAB59B2.5050106@candelatech.com> <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com>
 <4CAB5F3D.9060201@candelatech.com> <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com>
 <4CAB627F.8020804@candelatech.com> <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com>
 <4CAB64AD.4080105@candelatech.com> <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com>
 <4CAB6B08.4050801@candelatech.com> <4CAE0474.4090605@candelatech.com>
 <1286475250.20974.22.camel@jlt3.sipsolutions.net> <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com>
 <4CAE13F6.2010003@candelatech.com> <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com>
 <4CAE1DFB.303@candelatech.com> <1286479642.20974.32.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 7 Oct 2010 14:31:29 -0700
Message-ID: <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 7, 2010 at 12:27 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-10-07 at 12:22 -0700, Ben Greear wrote:
>
>> After reboot, and re-run of the script,
>> I saw this in the logs, and shortly after,
>> the SLUB poison warning dumped to screen.
>>
>> Maybe those DMA errors are serious?
>
>> ath: Failed to stop TX DMA in 100 msec after killing last frame
>> ath: Failed to stop TX DMA. Resetting hardware!
>
> That's TX DMA, it can hardly result in invalid memory writes like the
> ones you've been seeing.
>
> I'm still convinced something is wrong with ath9k RX DMA, as you've seen
> the contents of frames written to already freed memory regions. Since I
> don't know anything about ath9k, you should probably not rely on me
> though :-)

I'm on this now. Lets play.

I had to remove  /lib/udev/rules.d/75-persistent-net-generator.rules
to avoid Ubuntu trying to remember the device names and it creating
stax_rename names.
I just ran your script with some modifications. You can find it here:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/scripts/poo.pl

I then ran:

for i in $(seq 0 31) ; do sudo dhclient seq$i; done

It took about 10 minutes to get IP addresses for all interfaces but it
got there eventually. Odd enough I was unable to ping the AP from any
interface though. Not sure what that was about. But I got no oops, no
slub dump. All I got was some more delba warnings which seems to
indicate we haven't caught all the cases for its use:

[ 3622.660344] addBA response timer expired on tid 0
[ 3622.660373] Tx BA session stop requested for 68:7f:74:3b:b1:0f tid 0
[ 3622.680133] addBA response timer expired on tid 0
[ 3622.687196] Tx BA session stop requested for 68:7f:74:3b:b1:0f tid 0
[ 3623.110077] addBA response timer expired on tid 0
[ 3623.110123] Tx BA session stop requested for 68:7f:74:3b:b1:0f tid 0
[ 3628.935895] sta10: authenticate with 68:7f:74:3b:b1:10 (try 1)
[ 3628.937194] switched off addBA timer for tid 0
[ 3628.937196] Aggregation is on for tid 0
[ 3628.937239] Stopping Tx BA session for 68:7f:74:3b:b1:0f tid 0
[ 3628.937243] ------------[ cut here ]------------
[ 3628.937263] WARNING: at include/net/mac80211.h:2694
rate_control_send_low+0xd3/0x140 [mac80211]()
[ 3628.937265] Hardware name: 6460DWU
[ 3628.937266] Modules linked in: binfmt_misc ppdev
snd_hda_codec_analog rfcomm sco bridge joydev stp bnep l2cap nouveau
ath9k snd_hda_intel mac80211 snd_hda_codec snd_hwdep snd_pcm ttm btusb
ath9k_common thinkpad_acpi ath9k_hw bluetooth drm_kms_helper
snd_seq_midi snd_rawmidi pcmcia snd_seq_midi_event drm snd_seq ath
snd_timer snd_seq_device tpm_tis i2c_algo_bit cfg80211 snd nvram tpm
tpm_bios yenta_socket pcmcia_rsrc video psmouse output pcmcia_core
serio_raw soundcore snd_page_alloc intel_agp lp parport ohci1394
e1000e ieee1394 ahci libahci
[ 3628.937307] Pid: 49, comm: kworker/u:3 Tainted: G        W
2.6.36-rc6-wl+ #263
[ 3628.937310] Call Trace:
[ 3628.937317]  [<ffffffff8105ffcf>] warn_slowpath_common+0x7f/0xc0
[ 3628.937320]  [<ffffffff8106002a>] warn_slowpath_null+0x1a/0x20
[ 3628.937329]  [<ffffffffa032f603>] rate_control_send_low+0xd3/0x140 [mac80211]
[ 3628.937336]  [<ffffffffa038bfd8>] ath_get_rate+0x48/0x570 [ath9k]
[ 3628.937340]  [<ffffffff812b9f39>] ? put_dec+0x59/0x60
[ 3628.937349]  [<ffffffffa032f42e>] rate_control_get_rate+0x8e/0x190 [mac80211]
[ 3628.937360]  [<ffffffffa0339928>]
ieee80211_tx_h_rate_ctrl+0x1a8/0x4e0 [mac80211]
[ 3628.937370]  [<ffffffffa033a000>] invoke_tx_handlers+0x100/0x140 [mac80211]
[ 3628.937379]  [<ffffffffa033a0c5>] ieee80211_tx+0x85/0x240 [mac80211]
[ 3628.937384]  [<ffffffff8147b890>] ? skb_release_data+0xd0/0xe0
[ 3628.937386]  [<ffffffff8147d72f>] ? pskb_expand_head+0x10f/0x1a0
[ 3628.937397]  [<ffffffffa033a336>] ieee80211_xmit+0xb6/0x1d0 [mac80211]
[ 3628.937399]  [<ffffffff8147b9d3>] ? __alloc_skb+0x83/0x170
[ 3628.937409]  [<ffffffffa033a4a4>] ieee80211_tx_skb+0x54/0x70 [mac80211]
[ 3628.937418]  [<ffffffffa03230ad>] ieee80211_send_delba+0x11d/0x190 [mac80211]
[ 3628.937427]  [<ffffffffa0323a18>]
ieee80211_stop_tx_ba_cb+0x1b8/0x240 [mac80211]
[ 3628.937431]  [<ffffffff81036c89>] ? default_spin_lock_flags+0x9/0x10
[ 3628.937440]  [<ffffffffa032e031>] ieee80211_iface_work+0x271/0x340 [mac80211]
[ 3628.937450]  [<ffffffffa032ddc0>] ? ieee80211_iface_work+0x0/0x340 [mac80211]
[ 3628.937453]  [<ffffffff8107a203>] process_one_work+0x123/0x440
[ 3628.937457]  [<ffffffff8107c750>] worker_thread+0x170/0x400
[ 3628.937460]  [<ffffffff8107c5e0>] ? worker_thread+0x0/0x400
[ 3628.937463]  [<ffffffff81080b76>] kthread+0x96/0xa0
[ 3628.937466]  [<ffffffff8100bea4>] kernel_thread_helper+0x4/0x10
[ 3628.937469]  [<ffffffff81080ae0>] ? kthread+0x0/0xa0
[ 3628.937472]  [<ffffffff8100bea0>] ? kernel_thread_helper+0x0/0x10
[ 3628.937474] ---[ end trace 9dd0d025ccb9b75c ]---
[ 3628.937980] switched off addBA timer for tid 0
[ 3628.937982] Aggregation is on for tid 0

But other than this I got nothing. I left the box sit there for about
1 hour and came back and it was still going with no issues. Mind you,
I can't ping but that seems like another issue.

You can find my logs here:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/logs/2010/10-07-stress-sta-01/

  Luis
