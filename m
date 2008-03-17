Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:24406 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbYCQQPB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 12:15:01 -0400
Date: Mon, 17 Mar 2008 19:10:07 +0300
From: Dmitri Monakhov <dmonakhov@openvz.org>
To: linux-wireless@vger.kernel.org
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] fix error handling logic in generic_rndis_bind
Message-ID: <20080317161007.GA32154@dmon-lap.sw.ru> (sfid-20080317_161535_490734_F8EEF2A1)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
Today after i've plugged usbdevice to my notebook i've got OOPS
which was caused by generic_rndis_bind() probe function.
BUG LOG:
usb 2-2: new full speed USB device using uhci_hcd and address 2
usb 2-2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver cdc_ether
rndis_host 2-2:1.0: RNDIS_MSG_QUERY(0x00010202) failed, -47
BUG: unable to handle kernel paging request at virtual address fffffff4
printing eip: f8c0b6d3 *pde = 00798067 *pte = 00000000
Oops: 0002 [#1] SMP
Modules linked in: rndis_host cdc_ether usbnet mii autofs4 fuse rfcomm l2cap
bluetooth sunrpc ipv6 cpufreq_ondemand acpi_cpufreq dm_mirror dm_multipath
dm_mod snd_usb_audio snd_usb_lib snd_rawmidi snd_hda_intel snd_seq_dummy
thinkpad_acpi snd_seq_oss snd_seq_midi_event snd_seq i2c_i801 hwmon irda
crc_ccitt arc4 pcspkr
i2c_core ecb snd_seq_device blkcipher iTCO_wdt snd_pcm_oss battery
iTCO_vendor_support ac snd_mixer_oss snd_pcm video iwl3945 mac80211 snd_timer
output snd_page_alloc snd_hwdep cfg80211 button snd soundcore sg e1000 ata_piix
ahci libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd

Pid: 31296, comm: modprobe Not tainted (2.6.24.3-12.fc8 #1)
EIP: 0060:[<f8c0b6d3>] EFLAGS: 00210286 CPU: 1
EIP is at generic_rndis_bind+0x219/0x3ca [rndis_host]
EAX: fffffff4 EBX: 00000616 ECX: 00200096 EDX: 00200000
ESI: c7f40d7c EDI: 00002000 EBP: f6193800 ESP: c7f40d48
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 31296, ti=c7f40000 task=f635d3b0 task.ti=c7f40000)
Stack: 00010202 00000000 c7f40d80 c7f40d7c 00000000 000080d0 c7d3a600 00000001
       c7d3a600 f6192480 00000000 f6192000 c05d48c8 00000004 fffffff4 f6192480
       f8c0baa0 f8c0badc e8bae748 f8c3bea2 f7bbf5f8 f5543560 f6016390 c0498e56
Call Trace:
[<c05d48c8>] ether_setup+0x0/0x76
 [<f8c3bea2>] usbnet_probe+0x1f5/0x534 [usbnet]
 [<c0498e56>] iput+0x39/0x62
 [<c04c2405>] sysfs_addrm_finish+0x4a/0x194
 [<c0588583>] usb_autopm_do_device+0xd0/0xda
 [<c04c2d9c>] sysfs_create_link+0xc1/0x105
 [<c0588156>] usb_match_one_id+0x1c/0x71
 [<c0588ff7>] usb_probe_interface+0xbf/0x102
 [<c0571b31>] driver_probe_device+0xe7/0x165
 [<c04fc15f>] kobject_uevent_env+0x353/0x377
 [<c0571c55>] __driver_attach+0x0/0xa5
 [<c0571cc5>] __driver_attach+0x70/0xa5
 [<c05710e7>] bus_for_each_dev+0x37/0x59
 [<c057198f>] driver_attach+0x16/0x18
 [<c0571c55>] __driver_attach+0x0/0xa5
 [<c0571399>] bus_add_driver+0x6d/0x197
 [<c0588bdb>] usb_register_driver+0x6d/0xd4
 [<c044d204>] sys_init_module+0x14d6/0x15f9
 [<c0488e3b>] do_sync_read+0xc7/0x10a
 [<c04051da>] syscall_call+0x7/0xb
 [<c0620000>] xfrm_add_acquire+0x125/0x1bc
 =======================
Code: 74 24 34 c7 44 24 34 04 00 00 00 89 74 24 0c c7 44 24 04 00 00 00 00 c7 04
24 02 02 01 00 e8 de fc ff ff 85 c0 74 0a 8b 44 24 38 <c7> 00 00 00 00 00 f6 44
24 1c 02 74 0d 8b 44 24 38 83 38 01 0f
EIP: [<f8c0b6d3>] generic_rndis_bind+0x219/0x3ca [rndis_host] SS:ESP
0068:c7f40d48
---[ end trace dbf78b26ee59e9c9 ]---

BUGGY PLACE:

generic_rndis_bind(struct usbnet *dev, struct usb_interface *intf, int flags)
{
290	u32                     tmp, *phym
...
361	/* Check physical medium */
362   	reply_len = sizeof *phym;
363   	retval = rndis_query(dev, intf, u.buf, OID_GEN_PHYSICAL_MEDIUM,
364                   0, (void **) &phym, &reply_len);
365   	if (retval != 0)
	^^^^^^^^^^^^^^^^^ function returned with non zero code.
        If (retval < 0) then phym wasn't iniatilized :(.
366           /* OID is optional so don't fail here. */
367           *phym = RNDIS_PHYSICAL_MEDIUM_UNSPECIFIED;
              ^^^^^^ Redeferencing uniniatilized pointer.
...
}

Bug was introduced by following commit:
commit 039ee17d1baabaa21783a0d5ab3e8c6d8c794bdf
Author: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date:   Sun Jan 27 23:34:33 2008 +0200

Proposed patch follows:

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="generic_rndis_bind-fix.patch"

Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index a613247..bff8de6 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -362,6 +362,9 @@ generic_rndis_bind(struct usbnet *dev, struct usb_interface *intf, int flags)
 	reply_len = sizeof *phym;
 	retval = rndis_query(dev, intf, u.buf, OID_GEN_PHYSICAL_MEDIUM,
 			0, (void **) &phym, &reply_len);
+	if (retval < 0)
+		goto halt_fail_and_release;
+	
 	if (retval != 0)
 		/* OID is optional so don't fail here. */
 		*phym = RNDIS_PHYSICAL_MEDIUM_UNSPECIFIED;

--n8g4imXOkfNTN/H1--
