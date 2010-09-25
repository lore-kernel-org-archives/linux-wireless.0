Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57168 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0IYITr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Sep 2010 04:19:47 -0400
Received: by fxm3 with SMTP id 3so1117113fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 25 Sep 2010 01:19:46 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Joshua Smith <jesmith@kaon.com>
Subject: Re: Question about starting up an AP
Date: Sat, 25 Sep 2010 10:18:56 +0200
Cc: linux-wireless@vger.kernel.org,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com>
In-Reply-To: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201009251018.56907.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joshua,

Am Freitag 24 September 2010 schrieb Joshua Smith:
> BUG: unable to handle kernel NULL pointer dereference at 00000010
> IP: [<f8d2d901>] :rt2800pci:rt2800pci_clear_entry+0x1/0x40
> *pde = 00000000 
> Oops: 0000 [#1] SMP 
> Modules linked in: vga2usb usbvideo videodev v4l1_compat snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss pcmcia agpgart ppdev lp parport_pc parport pcspkr psmouse arc4 ecb rt2800pci rt2800lib crc_ccitt rt2x00pci rt2x00lib led_class compat_firmware_class mac80211 cfg80211 rfkill_backport ftdi_sio compat usbserial pcmcia_core eeprom_93cx6 sg snd_hda_intel e1000e snd_pcm snd_timer snd_page_alloc snd_hwdep snd soundcore evdev fuse aufs squashfs sqlzma unlzma [last unloaded: rsrc_nonstatic]
> 
> Pid: 5995, comm: hostapd Not tainted (2.6.27.8 #1)
> EIP: 0060:[<f8d2d901>] EFLAGS: 00210246 CPU: 3
> EIP is at rt2800pci_clear_entry+0x1/0x40 [rt2800pci]
> EAX: 00000000 EBX: f698863c ECX: 00200296 EDX: f8d2dee0
> ESI: f6988600 EDI: f5b6f000 EBP: 00000000 ESP: f6d75e4c
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process hostapd (pid: 5995, ti=f6d74000 task=f6ce2300 task.ti=f6d74000)
> Stack: f698863c fa00eaec 00000000 f5b6f000 00000000 f7b67000 f5b6e280 fa00c629 
>        f5b6f000 00000000 fa00ca3d f7b67480 00000001 fa177d4c 01b6e890 f7b67000 
>        00000000 f7b67000 00000001 00001003 00001002 c066c366 f7b67000 c0668ad0 
> Call Trace:
>  [<fa00eaec>] rt2x00queue_init_queues+0x5c/0x90 [rt2x00lib]
>  [<fa00c629>] rt2x00lib_enable_radio+0x29/0xa0 [rt2x00lib]
>  [<fa00ca3d>] rt2x00lib_start+0x5d/0xd0 [rt2x00lib]
>  [<fa177d4c>] ieee80211_do_open+0x21c/0x510 [mac80211]
>  [<c066c366>] dev_open+0x56/0xb0
>  [<c0668ad0>] dev_set_rx_mode+0x20/0x40
>  [<c066a67f>] dev_change_flags+0x7f/0x190
>  [<c06b1495>] devinet_ioctl+0x515/0x690
>  [<c0668d24>] __dev_get_by_name+0x74/0x90
>  [<c065d3f0>] sock_ioctl+0xd0/0x240
>  [<c065d320>] sock_ioctl+0x0/0x240
>  [<c018179b>] vfs_ioctl+0x2b/0x90
>  [<c0181a5b>] do_vfs_ioctl+0x25b/0x2a0
>  [<c0181af6>] sys_ioctl+0x56/0x70
>  [<c0103262>] syscall_call+0x7/0xb
>  [<c0700000>] add_card+0xad0/0xba0
>  =======================
> Code: 83 78 08 0e 74 14 8b 02 8b 48 04 85 c9 0f 99 c0 0f b6 c0 c3 8d b6 00 00 00 00 8b 02 8b 40 04 85 c0 0f 99 c0 0f b6 c0 c3 66 90 53 <8b> 48 10 8b 58 08 8b 40 04 83 78 08 0e 74 15 8b 11 83 c2 04 8b 
> EIP: [<f8d2d901>] rt2800pci_clear_entry+0x1/0x40 [rt2800pci] SS:ESP 0068:f6d75e4c
> ---[ end trace cff9a5c094bb8837 ]---

Could you please try this patch against the crash (just a shot in the dark)?

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 053fdd3..193fada 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -909,10 +909,8 @@ int rt2x00lib_start(struct rt2x00_dev *rt2x00dev)
 
 	/* Enable the radio */
 	retval = rt2x00lib_enable_radio(rt2x00dev);
-	if (retval) {
-		rt2x00queue_uninitialize(rt2x00dev);
+	if (retval)
 		return retval;
-	}
 
 	set_bit(DEVICE_STATE_STARTED, &rt2x00dev->flags);
  
-- 
1.7.1
