Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53336 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790Ab0J1A6J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 20:58:09 -0400
Message-ID: <4CC8CAAE.3040100@lwfinger.net>
Date: Wed, 27 Oct 2010 19:58:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arnd Hannemann <arnd@arndnet.de>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: b43 sdio: WARNING: at drivers/mmc/core/core.c:237 mmc_wait_for_cmd
References: <4CC874F4.5050908@arndnet.de>
In-Reply-To: <4CC874F4.5050908@arndnet.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/27/2010 01:52 PM, Arnd Hannemann wrote:
> Hi,
> 
> first of all: great! b43 sdio card works with open firmware!
> 
> However, on "rmmod b43" I get the following backtraces 
> with current Linus git (v2.6.36-6794-g12ba8d1):
> 
> 
> [  831.696189] b43-phy1 debug: Removing Interface type 2
> [  831.698425] b43-phy1 debug: Wireless interface stopped
> [  851.560519] ------------[ cut here ]------------
> [  851.560531] WARNING: at drivers/mmc/core/core.c:237 mmc_wait_for_cmd+0x88/0x90()
> [  851.560534] Hardware name: 20552PG
> [  851.560536] Modules linked in: b43(-) ssb mmc_block binfmt_misc rfcomm sco bnep ppdev l2cap ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp kvm_intel kvm arc4 iwlagn snd_hda_codec_conexant snd_hda_intel snd_hda_codec iwlcore snd_hwdep snd_pcm thinkpad_acpi mac80211 snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq r852 joydev snd_timer sm_common pcmcia nand snd_seq_device cfg80211 sdhci_pci btusb psmouse tpm_tis yenta_socket nand_ids lp snd pcmcia_rsrc nand_ecc bluetooth sdhci tpm pcmcia_core parport mtd snd_page_alloc serio_raw tpm_bios soundcore nvram led_class sha256_generic aes_i586 aes_generic dm_crypt i915 drm_kms_helper drm ahci intel_agp i2c_algo_bit intel_gtt e1000e libahci video agpgart output
> [  851.560620] Pid: 2504, comm: rmmod Not tainted 2.6.36-titan0+ #1
> [  851.560622] Call Trace:
> [  851.560631]  [<c014a102>] warn_slowpath_common+0x72/0xa0
> [  851.560636]  [<c04d94c8>] ? mmc_wait_for_cmd+0x88/0x90
> [  851.560641]  [<c04d94c8>] ? mmc_wait_for_cmd+0x88/0x90
> [  851.560645]  [<c014a152>] warn_slowpath_null+0x22/0x30
> [  851.560649]  [<c04d94c8>] mmc_wait_for_cmd+0x88/0x90
> [  851.560655]  [<c0401585>] ? device_release+0x25/0x80
> [  851.560660]  [<c04df210>] mmc_io_rw_direct_host+0xa0/0x150
> [  851.560665]  [<c04df370>] mmc_io_rw_direct+0x30/0x40
> [  851.560669]  [<c04e06e7>] sdio_disable_func+0x37/0xa0
> [  851.560683]  [<f8dfcb80>] b43_sdio_remove+0x30/0x50 [b43]
> [  851.560687]  [<c04df8cc>] sdio_bus_remove+0x1c/0x60
> [  851.560692]  [<c016d39f>] ? blocking_notifier_call_chain+0x1f/0x30
> [  851.560697]  [<c0404991>] __device_release_driver+0x51/0xb0
> [  851.560701]  [<c0404a7f>] driver_detach+0x8f/0xa0
> [  851.560705]  [<c0403c83>] bus_remove_driver+0x63/0xa0
> [  851.560709]  [<c0405039>] driver_unregister+0x49/0x80
> [  851.560713]  [<c0405039>] ? driver_unregister+0x49/0x80
> [  851.560718]  [<c04dfad7>] sdio_unregister_driver+0x17/0x20
> [  851.560727]  [<f8dfcb42>] b43_sdio_exit+0x12/0x20 [b43]
> [  851.560734]  [<f8dfe76f>] b43_exit+0x17/0x3c [b43]
> [  851.560740]  [<c017fb8d>] sys_delete_module+0x13d/0x200
> [  851.560747]  [<c01fd7d2>] ? do_munmap+0x212/0x300
> [  851.560752]  [<c010311f>] sysenter_do_call+0x12/0x28
> [  851.560757] ---[ end trace 31e14488072d2f7d ]---
> [  851.560759] ------------[ cut here ]------------

I'm not an expert on the sdio interface, but I'll take a crack at this.

The first WARN_ON comes because the host has not been claimed. Please try the
following patch so that we know if it is claimed when b43_sdio_remove() is
entered and ssb_unregister_bus() clears it, or it has not been claimed when the
routine is entered. If the latter, we will likely need to surround the
sdio_disable_func() calls with sdio_claim_host()...sdio_remove_host() statements.

Larry

---


Index: wireless-testing/drivers/net/wireless/b43/sdio.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/sdio.c
+++ wireless-testing/drivers/net/wireless/b43/sdio.c
@@ -18,6 +18,7 @@
 #include <linux/mmc/sdio_ids.h>
 #include <linux/slab.h>
 #include <linux/ssb/ssb.h>
+#include <linux/mmc/host.h>

 #include "sdio.h"
 #include "b43.h"
@@ -174,7 +175,11 @@ static void b43_sdio_remove(struct sdio_
 {
 	struct b43_sdio *sdio = sdio_get_drvdata(func);

+	printk(KERN_INFO "b43-sdio: before ssb_bus_unregister, claimed is %d\n",
+	       func->card->host->claimed);
 	ssb_bus_unregister(&sdio->ssb);
+	printk(KERN_INFO "b43-sdio: before sdio_disable_func, claimed is %d\n",
+	       func->card->host->claimed);
 	sdio_disable_func(func);
 	kfree(sdio);
 	sdio_set_drvdata(func, NULL);
