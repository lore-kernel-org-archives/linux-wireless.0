Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:33403 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbZBCSQr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 13:16:47 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH v2.6.29] iwlwifi: save PCI state before suspend, restore after resume
Date: Tue,  3 Feb 2009 10:20:03 -0800
Message-Id: <1233685203-5093-1-git-send-email-reinette.chatre@intel.com> (sfid-20090203_191649_934585_7B5FA0D4)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the right thing to do and fixes the following warning:

[  115.012278] ------------[ cut here ]------------
[  115.012281] WARNING: at drivers/pci/pci-driver.c:370
pci_legacy_suspend+0x85/0xc2()
[  115.012285] Hardware name: Latitude D630
[  115.012301] PCI PM: Device state not saved by
iwl3945_pci_suspend+0x0/0x4c [iwl3945]
[  115.012304] Modules linked in: fuse nfsd lockd nfs_acl auth_rpcgss
exportfs sunrpc ipv6 acpi_cpufreq kvm_intel kvm snd_hda_codec_idt
snd_hda_intel snd_hda_codec snd_hwdep arc4 snd_seq_device snd_pcm_oss
snd_mixer_oss ecb snd_pcm cryptomgr aead snd_timer crypto_blkcipher
snd snd_page_alloc ohci1394 crypto_hash crypto_algapi ch341 ieee1394
usbserial thermal iwl3945 mac80211 led_class lib80211 tg3 processor
i2c_i801 i2c_core sg cfg80211 libphy usbhid battery ac button sr_mod
cdrom evdev dcdbas ata_generic ata_piix libata sd_mod scsi_mod ext3
jbd mbcache uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
microcode]
[  115.012374] Pid: 4163, comm: pm-suspend Not tainted
2.6.29-rc3-00227-gf1dd849-dirty #67
[  115.012377] Call Trace:
[  115.012382]  [<ffffffff8023d04d>] warn_slowpath+0xb1/0xed
[  115.012387]  [<ffffffff80450b5e>] ? _spin_unlock_irqrestore+0x5c/0x78
[  115.012390]  [<ffffffff80254f08>] ? up+0x34/0x39
[  115.012394]  [<ffffffff80362319>] ? acpi_ut_release_mutex+0x5d/0x61
[  115.012397]  [<ffffffff803584b2>] ? acpi_get_data+0x5e/0x70
[  115.012400]  [<ffffffff80363dd9>] ? acpi_bus_get_device+0x25/0x39
[  115.012403]  [<ffffffff80363e98>] ? acpi_bus_power_manageable+0x11/0x29
[  115.012406]  [<ffffffff803462f7>] ? acpi_pci_power_manageable+0x17/0x19
[  115.012410]  [<ffffffff8033ddfd>] ? pci_set_power_state+0xcc/0x101
[  115.012418]  [<ffffffffa01f28e9>] ? iwl3945_pci_suspend+0x0/0x4c [iwl3945]
[  115.012422]  [<ffffffff803401e6>] pci_legacy_suspend+0x85/0xc2
[  115.012425]  [<ffffffff80340316>] pci_pm_suspend+0x34/0x86
[  115.012429]  [<ffffffff8039d7ce>] pm_op+0x52/0xe5
[  115.012432]  [<ffffffff8039dd78>] device_suspend+0x32a/0x451
[  115.012436]  [<ffffffff80269ec2>] suspend_devices_and_enter+0x3e/0x13a
[  115.012439]  [<ffffffff8026a128>] enter_state+0x110/0x164
[  115.012442]  [<ffffffff8026a233>] state_store+0xb7/0xd7
[  115.012446]  [<ffffffff8032f95f>] kobj_attr_store+0x17/0x19
[  115.012449]  [<ffffffff80307d64>] sysfs_write_file+0xe4/0x119
[  115.012453]  [<ffffffff802baa7a>] vfs_write+0xae/0x137
[  115.012456]  [<ffffffff802babc7>] sys_write+0x47/0x70
[  115.012459]  [<ffffffff8020b73a>] system_call_fastpath+0x16/0x1b
[  115.012467] ---[ end trace 829828966f6f24dc ]---

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Ming Lei <tom.leiming@gmail.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---
This is not needed in wireless-testing as these functions in
wireless-testing are already doing the right thing.

 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 ++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b35c881..c01ea48 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4042,6 +4042,7 @@ static int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		priv->is_open = 1;
 	}
 
+	pci_save_state(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
@@ -4052,6 +4053,7 @@ static int iwl_pci_resume(struct pci_dev *pdev)
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
 
 	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
 
 	if (priv->is_open)
 		iwl_mac_start(priv->hw);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 95d0198..5b44d32 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -8143,6 +8143,7 @@ static int iwl3945_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		priv->is_open = 1;
 	}
 
+	pci_save_state(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
@@ -8153,6 +8154,7 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)
 	struct iwl3945_priv *priv = pci_get_drvdata(pdev);
 
 	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
 
 	if (priv->is_open)
 		iwl3945_mac_start(priv->hw);
-- 
1.5.4.3

