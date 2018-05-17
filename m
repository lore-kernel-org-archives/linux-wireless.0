Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751779AbeEQQkX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 May 2018 12:40:23 -0400
Date: Thu, 17 May 2018 18:40:04 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Carlos Manuel Santos <cmmpsantos@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: ACS ACR122U not working: pn533_usb 1-1:1.0: NFC: Couldn't
 poweron...
Message-ID: <20180517164004.GA8413@kroah.com> (sfid-20180517_184028_166758_E6C75FE2)
References: <CACyys_-Z9nnun3TdYFk+0qqoQHcK4CCyCNH-qaGGEf+5GFPkAQ@mail.gmail.com>
 <20180517141217.GA32551@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180517141217.GA32551@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding the network and NFC developers as this really is a NFC driver
bug, not a USB core issue...

On Thu, May 17, 2018 at 04:12:17PM +0200, Greg KH wrote:
> On Thu, May 17, 2018 at 02:10:57PM +0100, Carlos Manuel Santos wrote:
> > Hello.
> > I'm having troubles with this NFC card reader. It seems kernel driver
> > pn533 is not working properly.
> > At this moment I have my work stalled. I need to add NFC support to a
> > software product and I can't get the device to work. NFC tools won't
> > work, the device is not detected.
> > 
> > This is what I get from "dmesg":
> > 
> > [    4.182300] nfc: nfc_init: NFC Core ver 0.1
> > [    4.182318] NET: Registered protocol family 39
> > [    4.184676] hidraw: raw HID events driver (C) Jiri Kosina
> > [    4.193366] ------------[ cut here ]------------
> > [    4.193366] transfer buffer not dma capable
> > [    4.193398] WARNING: CPU: 2 PID: 259 at drivers/usb/core/hcd.c:1584
> > usb_hcd_map_urb_for_dma+0x413/0x570 [usbcore]
> > [    4.193399] Modules linked in: usbhid(+) pn533_usb(+) pn533 hid nfc
> > snd_soc_skl(+) rtsx_usb_ms snd_soc_skl_ipc memstick snd_hda_ext_core
> > snd_soc_sst_dsp snd_soc_sst_ipc ecdh_generic snd_soc_acpi snd_soc_core
> > snd_hda_codec_realtek(+) snd_hda_codec_generic snd_compress ac97_bus
> > snd_pcm_dmaengine arc4 intel_rapl x86_pkg_temp_thermal
> > intel_powerclamp coretemp kvm_intel snd_hda_intel kvm iTCO_wdt
> > snd_hda_codec iTCO_vendor_support iwlmvm i915 nls_iso8859_1 nls_cp437
> > mac80211 vfat fat ppdev irqbypass crct10dif_pclmul crc32_pclmul
> > ghash_clmulni_intel uvcvideo pcbc snd_hda_core iwlwifi
> > videobuf2_vmalloc videobuf2_memops aesni_intel videobuf2_v4l2
> > snd_hwdep aes_x86_64 crypto_simd glue_helper cryptd snd_pcm
> > intel_cstate videobuf2_common e1000e intel_uncore snd_timer cfg80211
> > intel_rapl_perf tpm_crb psmouse
> > [    4.193427]  videodev pcspkr input_leds intel_wmi_thunderbolt
> > wmi_bmof ptp snd pps_core i2c_i801 soundcore toshiba_acpi mei_me media
> > sparse_keymap toshiba_bluetooth mei intel_gtt industrialio
> > intel_pch_thermal shpchp parport_pc tpm_tis tpm_tis_core battery
> > rfkill parport evdev rtc_cmos mac_hid tpm rng_core ac sg crypto_user
> > ip_tables x_tables rtsx_usb_sdmmc mmc_core rtsx_usb ext4
> > crc32c_generic crc16 mbcache jbd2 fscrypto sr_mod cdrom sd_mod
> > serio_raw atkbd libps2 ahci libahci xhci_pci xhci_hcd crc32c_intel
> > libata usbcore scsi_mod usb_common i8042 serio nouveau led_class
> > mxm_wmi wmi i2c_algo_bit drm_kms_helper syscopyarea sysfillrect
> > sysimgblt fb_sys_fops ttm drm agpgart
> > [    4.193458] CPU: 2 PID: 259 Comm: systemd-udevd Not tainted 4.16.8-1-ARCH #1
> > [    4.193459] Hardware name: TOSHIBA SATELLITE PRO A50-C/SATELLITE
> > PRO A50-C, BIOS Version 7.50   09/26/2016
> > [    4.193467] RIP: 0010:usb_hcd_map_urb_for_dma+0x413/0x570 [usbcore]
> > [    4.193468] RSP: 0018:ffffa3b44282f9f8 EFLAGS: 00010282
> > [    4.193469] RAX: 0000000000000000 RBX: ffff981fc9e320c0 RCX: 0000000000000001
> > [    4.193470] RDX: 0000000080000001 RSI: 0000000000000002 RDI: 00000000ffffffff
> > [    4.193471] RBP: ffff981fd42f0000 R08: 0000000713ed01d2 R09: 000000000000001f
> > [    4.193472] R10: 0000000000000344 R11: 000000000000f300 R12: 00000000014000c0
> > [    4.193473] R13: 00000000fffffff5 R14: ffff981fd2592b98 R15: 00000000c0410280
> > [    4.193475] FS:  00007f4fb98d0d40(0000) GS:ffff981fe6d00000(0000)
> > knlGS:0000000000000000
> > [    4.193476] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [    4.193477] CR2: 0000562b4a68f6e8 CR3: 00000004532d6004 CR4: 00000000003606e0
> > [    4.193478] Call Trace:
> > [    4.193488]  usb_hcd_submit_urb+0x38d/0xb20 [usbcore]
> > [    4.193492]  ? pn533_usb_probe+0x61/0x4d0 [pn533_usb]
> > [    4.193495]  ? __kmalloc+0x19e/0x220
> > [    4.193498]  pn533_usb_probe+0x397/0x4d0 [pn533_usb]
> > [    4.193507]  usb_probe_interface+0xe4/0x2f0 [usbcore]
> > [    4.193511]  driver_probe_device+0x2b9/0x460
> > [    4.193514]  ? __driver_attach+0xb6/0xe0
> > [    4.193516]  ? driver_probe_device+0x460/0x460
> > [    4.193518]  ? bus_for_each_dev+0x76/0xc0
> > [    4.193520]  ? bus_add_driver+0x152/0x230
> > [    4.193522]  ? driver_register+0x6b/0xb0
> > [    4.193530]  ? usb_register_driver+0x7a/0x130 [usbcore]
> > [    4.193531]  ? 0xffffffffc13b6000
> > [    4.193534]  ? do_one_initcall+0x48/0x13b
> > [    4.193537]  ? free_unref_page_commit+0x6a/0x100
> > [    4.193539]  ? kmem_cache_alloc_trace+0xdc/0x1c0
> > [    4.193542]  ? do_init_module+0x5a/0x210
> > [    4.193544]  ? load_module+0x247a/0x29f0
> > [    4.193549]  ? SyS_init_module+0x139/0x180
> > [    4.193550]  ? SyS_init_module+0x139/0x180
> > [    4.193554]  ? do_syscall_64+0x74/0x190
> > [    4.193556]  ? entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> > [    4.193559] Code: 49 39 c9 73 30 80 3d 7d b5 02 00 00 41 bd f5 ff
> > ff ff 0f 85 57 ff ff ff 48 c7 c7 88 9d 6e c0 c6 05 63 b5 02 00 01 e8
> > 97 85 9a ec <0f> 0b 8b 53 64 e9 3a ff ff ff 65 48 8b 0c 25 00 5c 01 00
> > 48 8b
> > [    4.193589] ---[ end trace 37ff3cbaf04a5b5d ]---
> > [    4.193612] usb 1-1: NFC: Reader power on cmd error -11
> > [    4.193614] pn533_usb 1-1:1.0: NFC: Couldn't poweron the reader (error -11)
> > [    4.193618] pn533_usb: probe of 1-1:1.0 failed with error -11
> > [    4.193637] usbcore: registered new interface driver pn533_usb
> > [    4.198216] usbcore: registered new interface driver usbhid
> > 
> > 
> > Please find the full dmesg in the link below:
> > https://pastebin.com/ck4sZuUY
> 
> Odd that this driver has ever worked.  Has it worked for you on older
> kernels?
> 
> It looks like it is trying to send data off of the stack.  At first
> glance, I see at least two places it is doing this, which is what is
> causing the errors you are seeing.   I'll go audit the whole thing in a
> few hours when I get a chance.
> 
> Are you able to build and test a kernel patch if I make one for you?

Here's a totally untested, and not even built, patch that I knocked up
that should fix this type of issue.

I'll try to at least build it later tonight...

thanks,

greg k-h

--------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] NFC: pn533: don't send USB data off of the stack

It's amazing that this driver ever worked, but now that x86 doesn't
allow USB data to be sent off of the stack, it really does not work at
all.  Fix this up by properly allocating the data for the small
"commands" that get sent to the device.

The USB stack will free the buffer when the data has been transmitted,
that is why there is no kfree() to mirror the call to kmalloc().

Reported-by: Carlos Manuel Santos <cmmpsantos@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index e153e8b64bb8..15291cc4f4b5 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -150,10 +150,17 @@ static int pn533_usb_send_ack(struct pn533 *dev, gfp_t flags)
 	struct pn533_usb_phy *phy = dev->phy;
 	static const u8 ack[6] = {0x00, 0x00, 0xff, 0x00, 0xff, 0x00};
 	/* spec 7.1.1.3:  Preamble, SoPC (2), ACK Code (2), Postamble */
+	char *buffer;
 	int rc;
 
+	buffer = kmalloc(sizeof(ack), GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+	memcpy(buffer, ack, sizeof(ack));
+
 	phy->out_urb->transfer_buffer = (u8 *)ack;
 	phy->out_urb->transfer_buffer_length = sizeof(ack);
+	phy->out_urb |= URB_FREE_BUFFER;
 	rc = usb_submit_urb(phy->out_urb, flags);
 
 	return rc;
@@ -170,6 +177,7 @@ static int pn533_usb_send_frame(struct pn533 *dev,
 
 	phy->out_urb->transfer_buffer = out->data;
 	phy->out_urb->transfer_buffer_length = out->len;
+	phy->out_urb &= ~URB_FREE_BUFFER;
 
 	print_hex_dump_debug("PN533 TX: ", DUMP_PREFIX_NONE, 16, 1,
 			     out->data, out->len, false);
@@ -375,12 +383,18 @@ static int pn533_acr122_poweron_rdr(struct pn533_usb_phy *phy)
 	/* Power on th reader (CCID cmd) */
 	u8 cmd[10] = {PN533_ACR122_PC_TO_RDR_ICCPOWERON,
 		      0, 0, 0, 0, 0, 0, 3, 0, 0};
+	char *buffer;
 	int rc;
 	void *cntx;
 	struct pn533_acr122_poweron_rdr_arg arg;
 
 	dev_dbg(&phy->udev->dev, "%s\n", __func__);
 
+	buffer = kmalloc(sizeof(cmd), GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+	memcpy(buffer, cmd, sizeof(cmd));
+
 	init_completion(&arg.done);
 	cntx = phy->in_urb->context;  /* backup context */
 
@@ -389,6 +403,7 @@ static int pn533_acr122_poweron_rdr(struct pn533_usb_phy *phy)
 
 	phy->out_urb->transfer_buffer = cmd;
 	phy->out_urb->transfer_buffer_length = sizeof(cmd);
+	phy->out_urb |= URB_FREE_BUFFER;
 
 	print_hex_dump_debug("ACR122 TX: ", DUMP_PREFIX_NONE, 16, 1,
 		       cmd, sizeof(cmd), false);
