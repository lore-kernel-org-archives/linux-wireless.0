Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43630 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbcF3K4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 06:56:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: Fix crash during card removal
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1465478927-21401-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
	<linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <d95e54d0554c4c55aae695d5be61d9ed@euamsexm01a.eu.qualcomm.com> (sfid-20160630_125719_727084_494A8335)
Date: Thu, 30 Jun 2016 12:51:13 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Usually when the firmware crashes we check for the value
> 'FW_IND_EVENT_PENDING' in 'FW_INDICATOR_ADDRESS' and proceed with
> disabling the irq and dumping firmware 'crash dump'. Now
> when the PCI card is unplugged from the device the PCI controller
> seems to generate a spurious interrupt after some time which
> was as treated a firmware crash and resulting in the below race
> condition (and eventually crashing the system)
> 
> 	ath10k_core_unregister -> ath10k_core_free_board_files
> 
> 	...... device unplug spurious interrupt .........
> 
> 	ath10k_pci_taklet -> ath10k_pci_fw_crashed_dump  ...etc
> 
> Clearly even after the firmware board files related data structure
> is freed up we are getting a spurious interrupt from PCI with 0xfffffff
> in the 'FW_INDICATOR_ADDRESS' resulting in scheduling of the pci tasklet
> and doing a crash dump, printing f/w board related info resulting in the
> below crash. Fix this by detecting this spurious interrupt in ath10k PCI
> irq handler itself and return IRQ_NONE. Thanks to Michal Kazior for
> helping us conclude the most appropriate fix.
> 
> Call trace:
> 
>  EIP is at ath10k_debug_print_board_info+0x39/0xb0
> [ath10k_core]
> EAX: 00000000 EBX: d4de15a0 ECX: 00000000 EDX: 00000064
> ESI: f615ddd0 EDI: f8530000 EBP: f615de3c ESP: f615ddbc
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> CR0: 80050033 CR2: 00000004 CR3: 01c0a000 CR4: 000006f0
> Stack:
>  f615ddd0 00000064 f8b4ecdd 00000000 00000000 00412f4e
> 00000000 00000000
> 00000000 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000
>  00000000 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000
> Call Trace:
>   [<f8b1f517>] ath10k_print_driver_info+0x17/0x30
> [ath10k_core]
> [<f875463a>] ath10k_pci_fw_crashed_dump+0x7a/0xe0
> [ath10k_pci]
> [<f87549d0>] ath10k_pci_tasklet+0x70/0x90 [ath10k_pci]
> [<c106151e>] tasklet_action+0x9e/0xb0
> 
> Cc: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

fb7caababc02 ath10k: fix crash during card removal

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9167045/

