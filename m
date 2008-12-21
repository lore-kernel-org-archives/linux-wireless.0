Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:30078 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbYLUHho (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 02:37:44 -0500
Received: by fk-out-0910.google.com with SMTP id 18so908675fkq.5
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 23:37:42 -0800 (PST)
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org, "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: regression: iwl3945 crashing after ifup
References: <87ljuahouv.fsf@litku.valot.fi>
	<1ba2fa240812201530l7464cbb8rf981aa840bb9b82@mail.gmail.com>
Date: Sun, 21 Dec 2008 09:37:37 +0200
In-Reply-To: <1ba2fa240812201530l7464cbb8rf981aa840bb9b82@mail.gmail.com> (Tomas Winkler's message of "Sun\, 21 Dec 2008 01\:30\:09 +0200")
Message-ID: <87ej02j7we.fsf@litku.valot.fi> (sfid-20081221_083751_929407_6504405D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Kalle Valo <kalle.valo@iki.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Tomas Winkler" <tomasw@gmail.com> writes:

> Please replace iwl3945_rx_queue_{alloc,free,reset} with
> iwl_rx_queu_{alloc,free,reset}  in iwl-3945.c and iwl3945-base.c

I tried the patch below but now it's crashing elsewhere. Didn't give
much thought for the changes, though.

> Hope it If it fixes your problem, I have queued a patch for this
> already just don't have access to it right now.

In cases where severe crashes are likely, like the case I'm having
right, please don't hold back the fixes. Send them to the list as soon
as possible, even as just RFT patches. That would save a lot of time,
both yours and the users.

I'll just use ethernet for now and wait for you proper fix. Thanks for
the quick reply, Tomas.

-- 
Kalle Valo


[  836.939739] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kd
[  836.939756] iwl3945: Copyright(c) 2003-2008 Intel Corporation
[  836.939879] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  836.939905] iwl3945 0000:03:00.0: setting latency timer to 64
[  836.985140] iwl3945 0000:03:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
[  836.985155] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
[  836.988200] phy1: Selected rate control algorithm 'iwl-3945-rs'
[  852.688879] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  852.689247] iwl3945 0000:03:00.0: irq 506 for MSI/MSI-X
[  852.689477] iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
[  852.778579] iwl3945 0000:03:00.0: iwlwifi-3945-2.ucode firmware file req failed: -2
[  852.778596] iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-1.ucode
[  852.825074] iwl3945 0000:03:00.0: Loaded firmware iwlwifi-3945-1.ucode, which is deprecated.  Please use API v2 instead.
[  852.825094] iwl3945 0000:03:00.0: Firmware has old API version. Expected 2, got 1. New firmware can be obtained from http://www.intellinuxwireless.org.
[  852.825104] iwl3945 0000:03:00.0: loaded firmware version 15.28.1.6
[  852.826181] BUG: unable to handle kernel paging request at f8671bc8
[  852.826224] IP: [<c01cdaab>] iowrite32+0xf/0x32
[  852.826241] *pde = 369c3067 *pte = 00000000 
[  852.826255] Oops: 0002 [#1] SMP 
[  852.826266] last sysfs file: /sys/class/firmware/0000:03:00.0/loading
[  852.826273] Modules linked in: iwl3945 netconsole configfs i915 drm rfcomm l2cap cpufreq_ondemand binfmt_misc ipv6 fuse acpi_cpufreq freq_table loop snd_hda_intel snd_pcm arc4 ecb snd_seq snd_timer snd_seq_device pcmcia iwlcore snd thinkpad_acpi mac80211 hci_usb soundcore psmouse rfkill lib80211 bluetooth yenta_socket rsrc_nonstatic i2c_i801 pcspkr cfg80211 pcmcia_core rng_core video backlight output battery ac snd_page_alloc button led_class evdev nvram ext3 jbd mbcache sha256_generic aes_i586 aes_generic cbc dm_crypt dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sd_mod ata_generic ata_piix libata scsi_mod ide_pci_generic ide_core sdhci_pci sdhci mmc_core ehci_hcd uhci_hcd usbcore e1000e thermal processor fan [last unloaded: iwl3945]
[  852.826721] 
[  852.826728] Pid: 13332, comm: ip Not tainted (2.6.28-rc9-wl #105) 1703Y1F
[  852.826736] EIP: 0060:[<c01cdaab>] EFLAGS: 00210096 CPU: 0
[  852.826745] EIP is at iowrite32+0xf/0x32
[  852.826752] EAX: f8671bc8 EBX: 00000000 ECX: 000000f8 EDX: f8671bc8
[  852.826760] ESI: 00000000 EDI: f27d0f40 EBP: f2457998 ESP: f2457998
[  852.826767]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  852.826774] Process ip (pid: 13332, ti=f2456000 task=f271fb40 task.ti=f2456000)
[  852.826780] Stack:
[  852.826784]  f24579c0 f86a9bae f27d1a1c f27d374c 00200082 00000000 000000f8 000000fd
[  852.826812]  00000000 f27d0f40 f24579e0 f8892b96 f27d374c f27d2de8 00200092 f27d0f40
[  852.826847]  00200286 f27d147c f24579f4 f8893d54 00200296 f8e38d4c f27d0f40 f2457a2c
[  852.826882] Call Trace:
[  852.826890]  [<f86a9bae>] ? iwl_rx_queue_update_write_ptr+0x363/0x3b1 [iwlcore]
[  852.826923]  [<f8892b96>] ? iwl3945_rx_queue_restock+0x114/0x120 [iwl3945]
[  852.826949]  [<f8893d54>] ? iwl3945_rx_replenish+0x23/0x31 [iwl3945]
[  852.826974]  [<f889dc01>] ? iwl3945_hw_nic_init+0x129/0xba3 [iwl3945]
[  852.826999]  [<f888b30d>] ? __iwl3945_up+0x1e3/0x55e [iwl3945]
[  852.827020]  [<f8896686>] ? iwl3945_mac_start+0x1154/0x13dd [iwl3945]
[  852.827059]  [<f87baa46>] ? ieee80211_open+0x2ad/0x68c [mac80211]
[  852.827092]  [<c01394d9>] ? clockevents_program_event+0xd4/0xe3
[  852.827108]  [<c01493a3>] ? __rcu_process_callbacks+0xcf/0x1b8
[  852.827121]  [<c0250091>] ? dev_open+0x6a/0xa4
[  852.827122]  [<c024fafe>] ? dev_change_flags+0xa2/0x157
[  852.827122]  [<c02566b9>] ? do_setlink+0x244/0x2fc
[  852.827122]  [<c01512c1>] ? get_page_from_freelist+0xa5/0x38a
[  852.827122]  [<c02577fe>] ? rtnl_newlink+0x292/0x3ff
[  852.827122]  [<c02575c6>] ? rtnl_newlink+0x5a/0x3ff
[  852.827122]  [<c0257606>] ? rtnl_newlink+0x9a/0x3ff
[  852.827122]  [<c02a1a88>] ? _read_unlock+0x8/0xa
[  852.827122]  [<c025756c>] ? rtnl_newlink+0x0/0x3ff
[  852.827122]  [<c0257552>] ? rtnetlink_rcv_msg+0x193/0x1ad
[  852.827122]  [<c02573bf>] ? rtnetlink_rcv_msg+0x0/0x1ad
[  852.827122]  [<c025d7c5>] ? netlink_rcv_skb+0x30/0x77
[  852.827122]  [<c02573b7>] ? rtnetlink_rcv+0x1c/0x24
[  852.827122]  [<c025d346>] ? netlink_unicast+0x1a9/0x20a
[  852.827122]  [<c025d5df>] ? netlink_sendmsg+0x238/0x245
[  852.827122]  [<c02451f8>] ? sock_sendmsg+0xde/0xf9
[  852.827122]  [<c01317ef>] ? autoremove_wake_function+0x0/0x33
[  852.827122]  [<c01317ef>] ? autoremove_wake_function+0x0/0x33
[  852.827122]  [<c01cb34c>] ? copy_from_user+0x39/0x121
[  852.827122]  [<c01cb34c>] ? copy_from_user+0x39/0x121
[  852.827122]  [<c024b40d>] ? verify_iovec+0x40/0x6f
[  852.827122]  [<c0245352>] ? sys_sendmsg+0x13f/0x192
[  852.827122]  [<c0245be1>] ? sys_recvmsg+0x116/0x17b
[  852.827122]  [<c01cb46f>] ? copy_to_user+0x3b/0x10a
[  852.827122]  [<c0245ab4>] ? move_addr_to_user+0x3b/0x52
[  852.827122]  [<c0245de9>] ? sys_getsockname+0x59/0x76
[  852.827122]  [<c02a1a9a>] ? _spin_unlock_bh+0x10/0x12
[  852.827122]  [<c0246c53>] ? release_sock+0x8d/0x95
[  852.827122]  [<c015ced6>] ? __vma_link+0x58/0x5c
[  852.827122]  [<c015cf30>] ? vma_link+0x56/0x7b
[  852.827122]  [<c0246100>] ? sys_socketcall+0x140/0x16d
[  852.827122]  [<c0102ea5>] ? sysenter_do_call+0x12/0x25
[  852.827122]  [<c02a0000>] ? wait_for_common+0xe/0x112
[  852.827122] Code: fa 89 c7 81 e2 ff ff 00 00 f3 6c eb 0c ba 06 44 34 c0 89 f8 e8 1b fe ff ff 5f 5d c3 55 81 fa ff ff 03 00 89 c1 89 e5 89 d0 76 04 <89> 0a eb 1d 81 fa 00 00 01 00 76 0b 81 e2 ff ff 00 00 89 c8 ef 
[  852.827122] EIP: [<c01cdaab>] iowrite32+0xf/0x32 SS:ESP 0068:f2457998
[  852.827122] ---[ end trace bfe3a6adace2717d ]---

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 131bae7..355c489 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1202,13 +1202,13 @@ int iwl3945_hw_nic_init(struct iwl_priv *priv)
 
 	/* Allocate the RX queue, or reset if it is already allocated */
 	if (!rxq->bd) {
-		rc = iwl3945_rx_queue_alloc(priv);
+		rc = iwl_rx_queue_alloc(priv);
 		if (rc) {
 			IWL_ERR(priv, "Unable to initialize Rx queue\n");
 			return -ENOMEM;
 		}
 	} else
-		iwl3945_rx_queue_reset(priv, rxq);
+		iwl_rx_queue_reset(priv, rxq);
 
 	iwl3945_rx_replenish(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4b4ed65..45490c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3308,7 +3308,7 @@ static int iwl3945_rx_queue_restock(struct iwl_priv *priv)
 
 	spin_lock_irqsave(&rxq->lock, flags);
 	write = rxq->write & ~0x7;
-	while ((iwl3945_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
+	while ((iwl_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
 		/* Get next free Rx buffer, remove from free list */
 		element = rxq->rx_free.next;
 		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
@@ -3334,7 +3334,7 @@ static int iwl3945_rx_queue_restock(struct iwl_priv *priv)
 		spin_lock_irqsave(&rxq->lock, flags);
 		rxq->need_update = 1;
 		spin_unlock_irqrestore(&rxq->lock, flags);
-		rc = iwl3945_rx_queue_update_write_ptr(priv, rxq);
+		rc = iwl_rx_queue_update_write_ptr(priv, rxq);
 		if (rc)
 			return rc;
 	}
@@ -3597,7 +3597,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 	r = le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF;
 	i = rxq->read;
 
-	if (iwl3945_rx_queue_space(rxq) > (RX_QUEUE_SIZE / 2))
+	if (iwl_rx_queue_space(rxq) > (RX_QUEUE_SIZE / 2))
 		fill_rx = 1;
 	/* Rx interrupt, but nothing sent from uCode */
 	if (i == r)
@@ -4103,7 +4103,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	/* uCode wakes up after power-down sleep */
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		IWL_DEBUG_ISR("Wakeup interrupt\n");
-		iwl3945_rx_queue_update_write_ptr(priv, &priv->rxq);
+		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
 		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq39[0]);
 		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq39[1]);
 		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq39[2]);
@@ -7756,7 +7756,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	iwl3945_dealloc_ucode_pci(priv);
 
 	if (priv->rxq.bd)
-		iwl3945_rx_queue_free(priv, &priv->rxq);
+		iwl_rx_queue_free(priv, &priv->rxq);
 	iwl3945_hw_txq_ctx_free(priv);
 
 	iwl3945_unset_hw_params(priv);
