Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slowhand.arndnet.de ([88.198.19.76]:37432 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752046Ab0J0Swk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 14:52:40 -0400
Message-ID: <4CC874F4.5050908@arndnet.de>
Date: Wed, 27 Oct 2010 20:52:36 +0200
From: Arnd Hannemann <arnd@arndnet.de>
MIME-Version: 1.0
To: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: b43 sdio: WARNING: at drivers/mmc/core/core.c:237 mmc_wait_for_cmd
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

first of all: great! b43 sdio card works with open firmware!

However, on "rmmod b43" I get the following backtraces 
with current Linus git (v2.6.36-6794-g12ba8d1):


[  831.696189] b43-phy1 debug: Removing Interface type 2
[  831.698425] b43-phy1 debug: Wireless interface stopped
[  851.560519] ------------[ cut here ]------------
[  851.560531] WARNING: at drivers/mmc/core/core.c:237 mmc_wait_for_cmd+0x88/0x90()
[  851.560534] Hardware name: 20552PG
[  851.560536] Modules linked in: b43(-) ssb mmc_block binfmt_misc rfcomm sco bnep ppdev l2cap ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp kvm_intel kvm arc4 iwlagn snd_hda_codec_conexant snd_hda_intel snd_hda_codec iwlcore snd_hwdep snd_pcm thinkpad_acpi mac80211 snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq r852 joydev snd_timer sm_common pcmcia nand snd_seq_device cfg80211 sdhci_pci btusb psmouse tpm_tis yenta_socket nand_ids lp snd pcmcia_rsrc nand_ecc bluetooth sdhci tpm pcmcia_core parport mtd snd_page_alloc serio_raw tpm_bios soundcore nvram led_class sha256_generic aes_i586 aes_generic dm_crypt i915 drm_kms_helper drm ahci intel_agp i2c_algo_bit intel_gtt e1000e libahci video agpgart output
[  851.560620] Pid: 2504, comm: rmmod Not tainted 2.6.36-titan0+ #1
[  851.560622] Call Trace:
[  851.560631]  [<c014a102>] warn_slowpath_common+0x72/0xa0
[  851.560636]  [<c04d94c8>] ? mmc_wait_for_cmd+0x88/0x90
[  851.560641]  [<c04d94c8>] ? mmc_wait_for_cmd+0x88/0x90
[  851.560645]  [<c014a152>] warn_slowpath_null+0x22/0x30
[  851.560649]  [<c04d94c8>] mmc_wait_for_cmd+0x88/0x90
[  851.560655]  [<c0401585>] ? device_release+0x25/0x80
[  851.560660]  [<c04df210>] mmc_io_rw_direct_host+0xa0/0x150
[  851.560665]  [<c04df370>] mmc_io_rw_direct+0x30/0x40
[  851.560669]  [<c04e06e7>] sdio_disable_func+0x37/0xa0
[  851.560683]  [<f8dfcb80>] b43_sdio_remove+0x30/0x50 [b43]
[  851.560687]  [<c04df8cc>] sdio_bus_remove+0x1c/0x60
[  851.560692]  [<c016d39f>] ? blocking_notifier_call_chain+0x1f/0x30
[  851.560697]  [<c0404991>] __device_release_driver+0x51/0xb0
[  851.560701]  [<c0404a7f>] driver_detach+0x8f/0xa0
[  851.560705]  [<c0403c83>] bus_remove_driver+0x63/0xa0
[  851.560709]  [<c0405039>] driver_unregister+0x49/0x80
[  851.560713]  [<c0405039>] ? driver_unregister+0x49/0x80
[  851.560718]  [<c04dfad7>] sdio_unregister_driver+0x17/0x20
[  851.560727]  [<f8dfcb42>] b43_sdio_exit+0x12/0x20 [b43]
[  851.560734]  [<f8dfe76f>] b43_exit+0x17/0x3c [b43]
[  851.560740]  [<c017fb8d>] sys_delete_module+0x13d/0x200
[  851.560747]  [<c01fd7d2>] ? do_munmap+0x212/0x300
[  851.560752]  [<c010311f>] sysenter_do_call+0x12/0x28
[  851.560757] ---[ end trace 31e14488072d2f7d ]---
[  851.560759] ------------[ cut here ]------------
[  851.560764] WARNING: at drivers/mmc/core/core.c:164 mmc_wait_for_req+0xea/0x100()
[  851.560767] Hardware name: 20552PG
[  851.560769] Modules linked in: b43(-) ssb mmc_block binfmt_misc rfcomm sco bnep ppdev l2cap ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp kvm_intel kvm arc4 iwlagn snd_hda_codec_conexant snd_hda_intel snd_hda_codec iwlcore snd_hwdep snd_pcm thinkpad_acpi mac80211 snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq r852 joydev snd_timer sm_common pcmcia nand snd_seq_device cfg80211 sdhci_pci btusb psmouse tpm_tis yenta_socket nand_ids lp snd pcmcia_rsrc nand_ecc bluetooth sdhci tpm pcmcia_core parport mtd snd_page_alloc serio_raw tpm_bios soundcore nvram led_class sha256_generic aes_i586 aes_generic dm_crypt i915 drm_kms_helper drm ahci intel_agp i2c_algo_bit intel_gtt e1000e libahci video agpgart output
[  851.560848] Pid: 2504, comm: rmmod Tainted: G        W   2.6.36-titan0+ #1
[  851.560850] Call Trace:
[  851.560855]  [<c014a102>] warn_slowpath_common+0x72/0xa0
[  851.560860]  [<c04d942a>] ? mmc_wait_for_req+0xea/0x100
[  851.560865]  [<c04d942a>] ? mmc_wait_for_req+0xea/0x100
[  851.560869]  [<c014a152>] warn_slowpath_null+0x22/0x30
[  851.560873]  [<c04d942a>] mmc_wait_for_req+0xea/0x100
[  851.560878]  [<c04d94ac>] mmc_wait_for_cmd+0x6c/0x90
[  851.560882]  [<c04d99d0>] ? mmc_wait_done+0x0/0x20
[  851.560886]  [<c04df210>] mmc_io_rw_direct_host+0xa0/0x150
[  851.560891]  [<c04df370>] mmc_io_rw_direct+0x30/0x40
[  851.560895]  [<c04e06e7>] sdio_disable_func+0x37/0xa0
[  851.560906]  [<f8dfcb80>] b43_sdio_remove+0x30/0x50 [b43]
[  851.560910]  [<c04df8cc>] sdio_bus_remove+0x1c/0x60
[  851.560914]  [<c016d39f>] ? blocking_notifier_call_chain+0x1f/0x30
[  851.560920]  [<c0404991>] __device_release_driver+0x51/0xb0
[  851.560924]  [<c0404a7f>] driver_detach+0x8f/0xa0
[  851.560928]  [<c0403c83>] bus_remove_driver+0x63/0xa0
[  851.560932]  [<c0405039>] driver_unregister+0x49/0x80
[  851.560937]  [<c0405039>] ? driver_unregister+0x49/0x80
[  851.560941]  [<c04dfad7>] sdio_unregister_driver+0x17/0x20
[  851.560950]  [<f8dfcb42>] b43_sdio_exit+0x12/0x20 [b43]
[  851.560957]  [<f8dfe76f>] b43_exit+0x17/0x3c [b43]
[  851.560962]  [<c017fb8d>] sys_delete_module+0x13d/0x200
[  851.560968]  [<c01fd7d2>] ? do_munmap+0x212/0x300
[  851.560972]  [<c010311f>] sysenter_do_call+0x12/0x28
[  851.560976] ---[ end trace 31e14488072d2f7e ]---
[  851.561027] ------------[ cut here ]------------
[  851.561035] WARNING: at drivers/mmc/core/core.c:237 mmc_wait_for_cmd+0x88/0x90()
[  851.561038] Hardware name: 20552PG
[  851.561040] Modules linked in: b43(-) ssb mmc_block binfmt_misc rfcomm sco bnep ppdev l2cap ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp kvm_intel kvm arc4 iwlagn snd_hda_codec_conexant snd_hda_intel snd_hda_codec iwlcore snd_hwdep snd_pcm thinkpad_acpi mac80211 snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq r852 joydev snd_timer sm_common pcmcia nand snd_seq_device cfg80211 sdhci_pci btusb psmouse tpm_tis yenta_socket nand_ids lp snd pcmcia_rsrc nand_ecc bluetooth sdhci tpm pcmcia_core parport mtd snd_page_alloc serio_raw tpm_bios soundcore nvram led_class sha256_generic aes_i586 aes_generic dm_crypt i915 drm_kms_helper drm ahci intel_agp i2c_algo_bit intel_gtt e1000e libahci video agpgart output
[  851.561115] Pid: 2504, comm: rmmod Tainted: G        W   2.6.36-titan0+ #1
[  851.561118] Call Trace:
[  851.561123]  [<c014a102>] warn_slowpath_common+0x72/0xa0
[  851.561128]  [<c04d94c8>] ? mmc_wait_for_cmd+0x88/0x90
[  851.561132]  [<c04d94c8>] ? mmc_wait_for_cmd+0x88/0x90
[  851.561136]  [<c014a152>] warn_slowpath_null+0x22/0x30
[  851.561140]  [<c04d94c8>] mmc_wait_for_cmd+0x88/0x90
[  851.561145]  [<c04d99d0>] ? mmc_wait_done+0x0/0x20
[  851.561149]  [<c04df210>] mmc_io_rw_direct_host+0xa0/0x150
[  851.561153]  [<c0[  851.561157]  [<c04e0722>] sdio_disable_func+0x72/0xa0
[  851.561167]  [<f8dfcb80>] b43_sdio_remove+0x30/0x50 [b43]
[  851.561171]  [<c04df8cc>] sdio_bus_remove+0x1c/0x60
[  851.561175]  [<c016d39f>] ? blocking_notifier_call_chain+0x1f/0x30
[  851.561180]  [<c0404991>] __device_release_driver+0x51/0xb0
[  851.561184]  [<c0404a7f>] driver_detach+0x8f/0xa0
[  851.561188]  [<c0403c83>] bus_remove_driver+0x63/0xa0
[  851.561193]  [<c0405039>] driver_unregister+0x49/0x80
[  851.561197]  [<c0405039>] ? driver_unregister+0x49/0x80
[  851.561201]  [<c04dfad7>] sdio_unregister_driver+0x17/0x20
[  851.561209]  [<f8dfcb42>] b43_sdio_exit+0x12/0x20 [b43]
[  851.561217]  [<f8dfe76f>] b43_exit+0x17/0x3c [b43]
[  851.561221]  [<c017fb8d>] sys_delete_module+0x13d/0x200
[  851.561226]  [<c01fd7d2>] ? do_munmap+0x212/0x300
[  851.561231]  [<c010311f>] sysenter_do_call+0x12/0x28
[  851.561234] ---[ end trace 31e14488072d2f7f ]---
[  851.561236] ------------[ cut here ]------------
[  851.561240] WARNING: at drivers/mmc/core/core.c:164 mmc_wait_for_req+0xea/0x100()
[  851.561243] Hardware name: 20552PG
[  851.561245] Modules linked in: b43(-) ssb mmc_block binfmt_misc rfcomm sco bnep ppdev l2cap ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp kvm_intel kvm arc4 iwlagn snd_hda_codec_conexant snd_hda_intel snd_hda_codec iwlcore snd_hwdep snd_pcm thinkpad_acpi mac80211 snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq r852 joydev snd_timer sm_common pcmcia nand snd_seq_device cfg80211 sdhci_pci btusb psmouse tpm_tis yenta_socket nand_ids lp snd pcmcia_rsrc nand_ecc bluetooth sdhci tpm pcmcia_core parport mtd snd_page_alloc serio_raw tpm_bios soundcore nvram led_class sha256_generic aes_i586 aes_generic dm_crypt i915 drm_kms_helper drm ahci intel_agp i2c_algo_bit intel_gtt e1000e libahci video agpgart output
[  851.561317] Pid: 2504, comm: rmmod Tainted: G        W   2.6.36-titan0+ #1
[  851.561320] Call Trace:
[  851.561324]  [<c014a102>] warn_slowpath_common+0x72/0xa0
[  851.561329]  [<c04d942a>] ? mmc_wait_for_req+0xea/0x100
[  851.561333]  [<c04d942a>] ? mmc_wait_for_req+0xea/0x100
[  851.561338]  [<c014a152>] warn_slowpath_null+0x22/0x30
[  851.561342]  [<c04d942a>] mmc_wait_for_req+0xea/0x100
[  851.561346]  [<c04d94ac>] mmc_wait_for_cmd+0x6c/0x90
[  851.561351]  [<c04d99d0>] ? mmc_wait_done+0x0/0x20
[  851.561355]  [<c04df210>] mmc_io_rw_direct_host+0xa0/0x150
[  851.561359]  [<c04df370>] mmc_io_rw_direct+0x30/0x40
[  851.561363]  [<c04e0722>] sdio_disable_func+0x72/0xa0
[  851.561372]  [<f8dfcb80>] b43_sdio_remove+0x30/0x50 [b43]
[  851.561377]  [<c04df8cc>] sdio_bus_remove+0x1c/0x60
[  851.561381]  [<c016d39f>] ? blocking_notifier_call_chain+0x1f/0x30
[  851.561385]  [<c0404991>] __device_release_driver+0x51/0xb0
[  851.561390]  [<c0404a7f>] driver_detach+0x8f/0xa0
[  851.561394]  [<c0403c83>] bus_remove_driver+0x63/0xa0
[  851.561398]  [<c0405039>] driver_unregister+0x49/0x80
[  851.561402]  [<c0405039>] ? driver_unregister+0x49/0x80
[  851.561406]  [<c04dfad7>] sdio_unregister_driver+0x17/0x20
[  851.561415]  [<f8dfcb42>] b43_sdio_exit+0x12/0x20 [b43]
[  851.561422]  [<f8dfe76f>] b43_exit+0x17/0x3c [b43]
[  851.561426]  [<c017fb8d>] sys_delete_module+0x13d/0x200
[  851.561431]  [<c01fd7d2>] ? do_munmap+0x212/0x300
[  851.561435]  [<c010311f>] sysenter_do_call+0x12/0x28
4df370>] mmc_io_rw_direct+0x30/0x40
[  851.561234] ---[ end trace 31e14488072d2f7f ]---
[  851.561236] ------------[ cut here ]------------
[  851.561240] WARNING: at drivers/mmc/core/core.c:164 mmc_wait_for_req+0xea/0x100()
[  851.561243] Hardware name: 20552PG
[  851.561245] Modules linked in: b43(-) ssb mmc_block binfmt_misc rfcomm sco bnep ppdev l2cap ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp kvm_intel kvm arc4 iwlagn snd_hda_codec_conexant snd_hda_intel snd_hda_codec iwlcore snd_hwdep snd_pcm thinkpad_acpi mac80211 snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq r852 joydev snd_timer sm_common pcmcia nand snd_seq_device cfg80211 sdhci_pci btusb psmouse tpm_tis yenta_socket nand_ids lp snd pcmcia_rsrc nand_ecc bluetooth sdhci tpm pcmcia_core parport mtd snd_page_alloc serio_raw tpm_bios soundcore nvram led_class sha256_generic aes_i586 aes_generic dm_crypt i915 drm_kms_helper drm ahci intel_agp i2c_algo_bit intel_gtt e1000e libahci video agpgart output
[  851.561317] Pid: 2504, comm: rmmod Tainted: G        W   2.6.36-titan0+ #1
[  851.561320] Call Trace:
[  851.561324]  [<c014a102>] warn_slowpath_common+0x72/0xa0
[  851.561329]  [<c04d942a>] ? mmc_wait_for_req+0xea/0x100
[  851.561333]  [<c04d942a>] ? mmc_wait_for_req+0xea/0x100
[  851.561338]  [<c014a152>] warn_slowpath_null+0x22/0x30
[  851.561342]  [<c04d942a>] mmc_wait_for_req+0xea/0x100
[  851.561346]  [<c04d94ac>] mmc_wait_for_cmd+0x6c/0x90
[  851.561351]  [<c04d99d0>] ? mmc_wait_done+0x0/0x20
[  851.561355]  [<c04df210>] mmc_io_rw_direct_host+0xa0/0x150
[  851.561359]  [<c04df370>] mmc_io_rw_direct+0x30/0x40
[  851.561363]  [<c04e0722>] sdio_disable_func+0x72/0xa0
[  851.561372]  [<f8dfcb80>] b43_sdio_remove+0x30/0x50 [b43]
[  851.561377]  [<c04df8cc>] sdio_bus_remove+0x1c/0x60
[  851.561381]  [<c016d39f>] ? blocking_notifier_call_chain+0x1f/0x30
[  851.561385]  [<c0404991>] __device_release_driver+0x51/0xb0
[  851.561390]  [<c0404a7f>] driver_detach+0x8f/0xa0
[  851.561394]  [<c0403c83>] bus_remove_driver+0x63/0xa0
[  851.561398]  [<c0405039>] driver_unregister+0x49/0x80
[  851.561402]  [<c0405039>] ? driver_unregister+0x49/0x80
[  851.561406]  [<c04dfad7>] sdio_unregister_driver+0x17/0x20
[  851.561415]  [<f8dfcb42>] b43_sdio_exit+0x12/0x20 [b43]
[  851.561422]  [<f8dfe76f>] b43_exit+0x17/0x3c [b43]
[  851.561426]  [<c017fb8d>] sys_delete_module+0x13d/0x200
[  851.561431]  [<c01fd7d2>] ? do_munmap+0x212/0x300
[  851.561435]  [<c010311f>] sysenter_do_call+0x12/0x28
[  851.561438] ---[ end trace 31e14488072d2f80 ]---

Regards,
Arnd


