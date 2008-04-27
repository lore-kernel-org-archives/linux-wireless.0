Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:42681 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYD0Cx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 22:53:29 -0400
Date: Sat, 26 Apr 2008 22:53:24 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: compat-2.6: rndis_wlan/rndis_host/usbnet problem(?)
Message-ID: <20080427025324.GB17936@ruslug.rutgers.edu> (sfid-20080427_045356_500516_55F6AF36)
References: <20080421200409.vvow4d67okcw84kg@hayate.ip6> <20080426045909.GA17936@ruslug.rutgers.edu> <20080426181848.foifd2bcw004kw4g@naisho.dyndns.info> <43e72e890804261126n7c4463c9y2d4bb4dc444be096@mail.gmail.com> <20080427004052.5sespv7h6o4wk8c0@hayate.ip6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080427004052.5sespv7h6o4wk8c0@hayate.ip6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 27, 2008 at 12:40:52AM +0300, Jussi Kivilinna wrote:
> Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:
> 
> >
> >Does the driver rely on all the new stuff? Or just he one you mentioned?
> >
> 
> Driver rely on the patch adding 'driver_priv' pointer to 'struct  
> usbnet' and the cdc_ether.c patch. Without cdc_ether.c patch, device  
> fails to bind. With those patches + rndis_* changes, driver should  
> work (atleast) on 2.6.20 and up. I'll check this when I find some time.

Ok I added cdc_ether.c and it compiles now if you use
compat-wireless.git and wireles-testing.git to pull. I tested this
only on 2.6.24 though, 2.6.22 compile may be broken now. We'll have
to test that.

OK so regardless I ran into issues with a 13b1:0026 Linksys
(WUSB54GSC). Either I'm really not understanding this driver well or
it wasn't tested well. I take it its the first... The first oops I
run into is with access to the net_device on rndis_wext_bind(). I fixed
that (patch at the bottom) but then I run into a bug on
generic_rndis_bind() when accessing the net_device ....
I just didn't get that as I am sure to be setting it.

I then note that somehow generic_rndis_bind() is being run first
than rndis_wext_bind()! How is this happening?

Oops #1: rndis_wext_bind() accessing a unalloc'd net_device

[ 1969.681181] usb 4-3: new high speed USB device using ehci_hcd and address 2
[ 1969.816195] usb 4-3: configuration #1 chosen from 1 choice
[ 1969.902318] usbcore: registered new interface driver cdc_ether
[ 1969.904520] usb 4-3: bad CDC descriptors
[ 1969.904860] usbcore: registered new interface driver rndis_host
[ 1969.909437] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
[ 1969.909446] printing eip: f8b81303 *pde = 00000000 
[ 1969.909451] Oops: 0002 [#1] SMP 
[ 1969.909455] Modules linked in: rndis_wlan rndis_host cdc_ether usbnet mii af_packet rfcomm l2cap bluetooth sonypi i915 drm ppdev ipv6 acpi_cpufreq cpufreq_userspace cpufreq_powersave cpufreq_conservative cpufreq_ondemand cpufreq_stats freq_table sbs sbshc container dock aes_i586 dm_crypt dm_mod sbp2 parport_pc lp parport fuse joydev arc4 snd_hda_intel ecb blkcipher snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_seq_dummy sky2 snd_seq_oss sony_laptop snd_seq_midi snd_rawmidi snd_seq_midi_event video output tifm_7xx1 serio_raw snd_seq snd_timer snd_seq_device tifm_core psmouse yenta_socket button snd battery ac rsrc_nonstatic pcmcia_core intel_agp agpgart shpchp pci_hotplug pcspkr evdev iTCO_wdt iTCO_vendor_support soundcore ext3 jbd mbcache sg sr_mod sd_mod cdrom ata_generic pata_acpi ata_piix libata ohci1394 scsi_mod ieee1394 ehci_hcd uhci_hcd usbcore thermal processor fan
[ 1969.909525] 
[ 1969.909528] Pid: 15034, comm: modprobe Not tainted (2.6.24-8-generic #1)
[ 1969.909531] EIP: 0060:[<f8b81303>] EFLAGS: 00010246 CPU: 0
[ 1969.909540] EIP is at rndis_wext_bind+0x43/0x340 [rndis_wlan]
[ 1969.909543] EAX: 00000000 EBX: fffffff4 ECX: 0000007e EDX: c03c76a7
[ 1969.909545] ESI: f5e7d480 EDI: 00000000 EBP: f5e7d800 ESP: e465dd3c
[ 1969.909548]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 1969.909551] Process modprobe (pid: 15034, ti=e465c000 task=f0aff680 task.ti=e465c000)
[ 1969.909554] Stack: 00000000 e465dd88 00000000 f745e200 00000001 f7c08f30 000080d0 f8b82064 
[ 1969.909561]        fffffff4 f5e7d000 00000480 c02a461e c0210ded c02b5410 c03c76a7 f8b82064 
[ 1969.909568]        fffffff4 f5e7d480 f8b82280 f5e7d000 f8b8254e f8c0110c f76dcea0 e64902a0 
[ 1969.909575] Call Trace:
[ 1969.909588]  [<c02a461e>] alloc_netdev_mq+0x8e/0xc0
[ 1969.909597]  [<c0210ded>] ida_get_new_above+0x7d/0x180
[ 1969.909603]  [<c02b5410>] ether_setup+0x0/0x80
[ 1969.909619]  [<f8c0110c>] usbnet_probe+0x21c/0x590 [usbnet]
[ 1969.909632]  [<c01a14d5>] iput+0x35/0x70
[ 1969.909639]  [<c01d3b3b>] sysfs_addrm_finish+0x4b/0x1c0
[ 1969.909651]  [<c0317518>] mutex_lock+0x8/0x20
[ 1969.909660]  [<f888f7fb>] usb_autopm_do_device+0x7b/0x100 [usbcore]
[ 1969.909689]  [<f888f367>] usb_match_one_id+0x27/0xb0 [usbcore]
[ 1969.909718]  [<f88905a9>] usb_probe_interface+0xb9/0x140 [usbcore]
[ 1969.909747]  [<c027eac8>] driver_probe_device+0x88/0x190
[ 1969.909753]  [<c0212140>] kobject_uevent_env+0xf0/0x3d0
[ 1969.909764]  [<c027ed3e>] __driver_attach+0x9e/0xa0
[ 1969.909772]  [<c027defb>] bus_for_each_dev+0x3b/0x60
[ 1969.909782]  [<c027e946>] driver_attach+0x16/0x20
[ 1969.909786]  [<c027eca0>] __driver_attach+0x0/0xa0
[ 1969.909791]  [<c027e27a>] bus_add_driver+0x8a/0x1e0
[ 1969.909802]  [<f88900ee>] usb_register_driver+0x8e/0x110 [usbcore]
[ 1969.909830]  [<c01515d6>] sys_init_module+0x126/0x19c0
[ 1969.909840]  [<f89934c4>] __ext3_journal_stop+0x24/0x50 [ext3]
[ 1969.909888]  [<c01053c2>] sysenter_past_esp+0x6b/0xa9
[ 1969.909903]  =======================
[ 1969.909905] Code: 01 00 00 00 e8 ff 41 73 c7 85 c0 89 c5 0f 84 80 02 00 00 8b 86 08 02 00 00 b9 7e 00 00 00 89 44 24 08 89 46 10 31 c0 8b 7c 24 08 <f3> ab b9 08 00 00 00 8b 7c 24 08 f3 ab 8b 44 24 08 ba 59 25 b8 
[ 1969.909941] EIP: [<f8b81303>] rndis_wext_bind+0x43/0x340 [rndis_wlan] SS:ESP 0068:e465dd3c
[ 1969.909949] ---[ end trace d5fd46677044ba2e ]---


------------------------------------------------------

I then fixed this... but then

Oops #2:

[  490.193497] usb 4-3: new high speed USB device using ehci_hcd and address 2
[  490.328184] usb 4-3: configuration #1 chosen from 1 choice
[  490.446129] usbcore: registered new interface driver cdc_ether
[  490.448431] BUG: unable to handle kernel NULL pointer dereference at virtual address 000000d6
[  490.448437] printing eip: f8e405e0 *pde = 00000000 
[  490.448443] Oops: 0000 [#1] SMP 
[  490.448447] Modules linked in: rndis_host cdc_ether usbnet mii rfcomm l2cap bluetooth sonypi i915 drm ppdev ipv6 acpi_cpufreq cpufreq_userspace cpufreq_powersave cpufreq_conservative cpufreq_ondemand cpufreq_stats freq_table sbs sbshc container dock aes_i586 dm_crypt dm_mod sbp2 parport_pc lp parport fuse joydev pcmcia arc4 snd_hda_intel ecb blkcipher snd_pcm_oss snd_mixer_oss snd_pcm iwl3945 snd_page_alloc snd_hwdep mac80211 sky2 snd_seq_dummy cfg80211 sony_laptop snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event video output tifm_7xx1 snd_seq serio_raw snd_timer snd_seq_device tifm_core yenta_socket psmouse battery rsrc_nonstatic pcmcia_core snd ac button soundcore shpchp pci_hotplug pcspkr iTCO_wdt iTCO_vendor_support intel_agp agpgart evdev ext3 jbd mbcache sg sr_mod sd_mod cdrom ata_generic pata_acpi ohci1394 ieee1394 ata_piix libata scsi_mod ehci_hcd uhci_hcd usbcore thermal processor fan
[  490.448518] 
[  490.448521] Pid: 9304, comm: modprobe Not tainted (2.6.24-8-generic #1)
[  490.448524] EIP: 0060:[<f8e405e0>] EFLAGS: 00010246 CPU: 1
[  490.448530] EIP is at generic_rndis_bind+0x80/0x4c0 [rndis_host]
[  490.448533] EAX: 00000000 EBX: f1d1f480 ECX: f7064e68 EDX: 00000000
[  490.448536] ESI: f8e40c40 EDI: f1d1f000 EBP: f1d1f800 ESP: f1f25d40
[  490.448539]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  490.448542] Process modprobe (pid: 9304, ti=f1f24000 task=f27650e0 task.ti=f1f24000)
[  490.448544] Stack: f1f25d88 c03f2b44 00000282 00000001 f7c08f30 000080d0 f1d1f480 00000001 
[  490.448552]        f27d4c00 00000000 00000000 c0210ded c02b5410 c03c76a7 f8e40c00 fffffff4 
[  490.448559]        f1d1f480 f8e40c40 f1d1f000 f8e40c7c f8e1010c f626fcc0 e94f2e70 00000001 
[  490.448566] Call Trace:
[  490.448575]  [<c0210ded>] ida_get_new_above+0x7d/0x180
[  490.448583]  [<c02b5410>] ether_setup+0x0/0x80
[  490.448594]  [<f8e1010c>] usbnet_probe+0x21c/0x590 [usbnet]
[  490.448603]  [<c01a14d5>] iput+0x35/0x70
[  490.448609]  [<c01d3b3b>] sysfs_addrm_finish+0x4b/0x1c0
[  490.448618]  [<c0317518>] mutex_lock+0x8/0x20
[  490.448626]  [<f888f7fb>] usb_autopm_do_device+0x7b/0x100 [usbcore]
[  490.448650]  [<f888f367>] usb_match_one_id+0x27/0xb0 [usbcore]
[  490.448673]  [<f88905a9>] usb_probe_interface+0xb9/0x140 [usbcore]
[  490.448696]  [<c027eac8>] driver_probe_device+0x88/0x190
[  490.448701]  [<c0212140>] kobject_uevent_env+0xf0/0x3d0
[  490.448710]  [<c027ed3e>] __driver_attach+0x9e/0xa0
[  490.448717]  [<c027defb>] bus_for_each_dev+0x3b/0x60
[  490.448725]  [<c027e946>] driver_attach+0x16/0x20
[  490.448729]  [<c027eca0>] __driver_attach+0x0/0xa0
[  490.448733]  [<c027e27a>] bus_add_driver+0x8a/0x1e0
[  490.448743]  [<f88900ee>] usb_register_driver+0x8e/0x110 [usbcore]
[  490.448767]  [<c01515d6>] sys_init_module+0x126/0x19c0
[  490.448775]  [<f89814c4>] __ext3_journal_stop+0x24/0x50 [ext3]
[  490.448823]  [<c01053c2>] sysenter_past_esp+0x6b/0xa9
[  490.448838]  =======================
[  490.448840] Code: c0 89 44 24 24 0f 88 b4 00 00 00 8b 54 24 28 c7 45 00 02 00 00 00 c7 45 04 18 00 00 00 c7 45 0c 01 00 00 00 c7 45 10 00 00 00 00 <0f> b7 82 d6 00 00 00 83 c0 2c 66 89 82 d6 00 00 00 8b 4c 24 18 
[  490.448876] EIP: [<f8e405e0>] generic_rndis_bind+0x80/0x4c0 [rndis_host] SS:ESP 0068:f1f25d40
[  490.448883] ---[ end trace 2f04c22abb8ee132 ]---

-------------------------

Anyway, here is my patch in case it helps. It fixes Oops #1.

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index d0b1fb1..002cb18 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2449,22 +2449,24 @@ static int bcm4320_early_init(struct usbnet *dev)
 
 static int rndis_wext_bind(struct usbnet *dev, struct usb_interface *intf)
 {
-	struct net_device *net = dev->net;
+	struct net_device *net;
 	struct rndis_wext_private *priv;
 	int retval, len;
 	__le32 tmp;
 
-	/* allocate rndis private data */
-	priv = kmalloc(sizeof(struct rndis_wext_private), GFP_KERNEL);
-	if (!priv)
+	/* allocate net_device and rndis private data */
+	net = alloc_etherdev(sizeof(struct rndis_wext_private));
+	if (!net)
 		return -ENOMEM;
 
 	/* These have to be initialized before calling generic_rndis_bind().
 	 * Otherwise we'll be in big trouble in rndis_wext_early_init().
 	 */
-	dev->driver_priv = priv;
-	memset(priv, 0, sizeof(*priv));
-	memset(priv->name, 0, sizeof(priv->name));
+	/* Huh, where is rndis_wext_early_init() ? */
+	dev->net = net;
+	priv = dev->driver_priv = netdev_priv(net);
+	priv->usbdev = dev;
+
 	strcpy(priv->name, "IEEE802.11");
 	net->wireless_handlers = &rndis_iw_handlers;
 	priv->usbdev = dev;
@@ -2524,7 +2526,7 @@ static int rndis_wext_bind(struct usbnet *dev, struct usb_interface *intf)
 	return 0;
 
 fail:
-	kfree(priv);
+	free_netdev(net);
 	return retval;
 }
 
