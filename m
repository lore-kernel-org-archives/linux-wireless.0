Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42175 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757761AbYAKLk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 06:40:28 -0500
Subject: [PATCH] iwlwifi: fix bad unlock balance
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Zhu Yi <yi.zhu@intel.com>, Tomas Winkler <tomasw@gmail.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 11:22:44 +0100
Message-Id: <1200046964.3861.157.camel@johannes.berg> (sfid-20080111_114032_958729_6413FB9F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[   98.083245] =====================================
[   98.083433] [ BUG: bad unlock balance detected! ]
[   98.083568] -------------------------------------
[   98.083704] pm-hibernate/4366 is trying to release lock (&priv->mutex) at:
[   98.083913] [<c0000000003e5c4c>] .mutex_unlock+0x18/0x2c
[   98.084077] but there are no more locks to release!
[   98.084217] 
[   98.084218] other info that might help us debug this:
[   98.084405] 3 locks held by pm-hibernate/4366:
[   98.084533]  #0:  (&buffer->mutex){--..}, at: [<c00000000013b708>] .sysfs_write_file+0x58/0x19c
[   98.084813]  #1:  (pm_mutex#2){--..}, at: [<c00000000008c130>] .hibernate+0x30/0x248
[   98.085072]  #2:  (dpm_mtx){--..}, at: [<c0000000002ab7e4>] .device_resume+0x44/0x74
[   98.085324] 
[   98.085325] stack backtrace:
[   98.085450] Call Trace:
[   98.085521] [c000000112da7320] [c00000000000e9d8] .show_stack+0x78/0x1a4 (unreliable)
[   98.085764] [c000000112da73d0] [c00000000000eb24] .dump_stack+0x20/0x34
[   98.085966] [c000000112da7450] [c00000000007a764] .print_unlock_inbalance_bug+0xf0/0x11c
[   98.086211] [c000000112da74f0] [c00000000007ded8] .lock_release_non_nested+0x108/0x1e8
[   98.086450] [c000000112da75a0] [c00000000007e16c] .lock_release+0x1b4/0x208
[   98.086662] [c000000112da7650] [c0000000003e5b64] .__mutex_unlock_slowpath+0x104/0x1d4
[   98.086901] [c000000112da76f0] [c0000000003e5c4c] .mutex_unlock+0x18/0x2c
[   98.087109] [c000000112da7770] [d0000000001bff04] .iwl4965_pci_resume+0x8f8/0x92c [iwl4965]


which is pretty obvious:

static int iwl4965_pci_resume(struct pci_dev *pdev)
{
        struct iwl4965_priv *priv = pci_get_drvdata(pdev);
        int err;

        printk(KERN_INFO "Coming out of suspend...\n");   

        pci_set_power_state(pdev, PCI_D0);
        err = pci_enable_device(pdev);
        pci_restore_state(pdev);

        /*
         * Suspend/Resume resets the PCI configuration space, so we have to
         * re-disable the RETRY_TIMEOUT register (0x41) to keep PCI Tx retries
         * from interfering with C3 CPU state. pci_restore_state won't help
         * here since it only restores the first 64 bytes pci config header.
         */
        pci_write_config_byte(pdev, 0x41, 0x00);
 
        iwl4965_resume(priv);
        mutex_unlock(&priv->mutex);                  /*** not locked!! ***/
 
        return 0;
}


The bad unlock was introduced in
c282d1fb959806b3c6644f5e31bd58a7f0b48b1b after both lock and unlock had
been removed in b24d22b1d12c436a86282347868785207cff8a88.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-01-11 11:21:24.649360569 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-01-11 11:21:32.269330729 +0100
@@ -8582,7 +8582,6 @@ static int iwl3945_pci_resume(struct pci
 	pci_write_config_byte(pdev, 0x41, 0x00);
 
 	iwl3945_resume(priv);
-	mutex_unlock(&priv->mutex);
 
 	return 0;
 }
--- everything.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-01-11 11:21:17.499335721 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-01-11 11:21:20.959331923 +0100
@@ -9146,7 +9146,6 @@ static int iwl4965_pci_resume(struct pci
 	pci_write_config_byte(pdev, 0x41, 0x00);
 
 	iwl4965_resume(priv);
-	mutex_unlock(&priv->mutex);
 
 	return 0;
 }


