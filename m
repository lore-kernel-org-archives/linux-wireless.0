Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17335 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3GKJg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 05:36:26 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH] ath10k:  Fix crash when using v1 hardware.
References: <1372804925-1701-1-git-send-email-greearb@candelatech.com>
Date: Thu, 11 Jul 2013 12:36:17 +0300
In-Reply-To: <1372804925-1701-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Tue, 2 Jul 2013 15:42:05
	-0700")
Message-ID: <87y59d5tgu.fsf@kamboji.qca.qualcomm.com> (sfid-20130711_113630_869237_1C61FCEF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> I put a v1 NIC from an TP-LINK AC 1750 AP in
> a 64-bit PC, and the OS crashes on bootup.  I'm not
> sure how broken my hardware is (possibly completely non
> functional), but at least with this patch it will no longer
> crash the OS.  Not sure it ever got far enough to try,
> but I also do not have firmware for the NIC.
>
> With this patch I get this info on module load:
>
> ath10k_pci 0000:05:00.0: BAR 0: assigned [mem 0xf4400000-0xf45fffff 64bit]
> ath10k_pci 0000:05:00.0: BAR 0: error updating (0xf4400004 != 0xffffffff)
> ath10k_pci 0000:05:00.0: BAR 0: error updating (high 0x000000 != 0xffffffff)
> ath10k_pci 0000:05:00.0: Refused to change power state, currently in D3
> ath10k: MSI-X interrupt handling (8 intrs)
> ath10k: Unable to wakeup target
> ath10k: target takes too long to wake up (awake count 1)
> ath10k: src_ring ffff88020c0d0a00:  write_index is out of bounds: 4294967295  nentries_mask: 15.
> ath10k: dest_ring ffff88020db2c000:  write_index is out of bounds: 4294967295  nentries_mask: 511.
> ath10k: dest_ring ffff880210d56400:  write_index is out of bounds: 4294967295  nentries_mask: 31.
> ath10k: src_ring ffff880210d57600:  write_index is out of bounds: 4294967295  nentries_mask: 31.
> ath10k: src_ring ffff88020fe70000:  write_index is out of bounds: 4294967295  nentries_mask: 2047.
> ath10k: src_ring ffff880212989b40:  write_index is out of bounds: 4294967295  nentries_mask: 1.
> ath10k: dest_ring ffff880212989960:  write_index is out of bounds: 4294967295  nentries_mask: 1.
> ath10k: Failed to get pcie state addr: -5
> ath10k: early firmware event indicated
> ------------[ cut here ]------------
> WARNING: at /home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath10k/ce.c:771 ath10k_ce_per_engine_service+0x53/0x1b4 [ath10k_pci]()
> ....
> (it hits the warning case about 5-6 times and then seems to quiesce OK).

I haven't seen this myself so it might be a hw problem, but difficult to
say.

> +	/* On v1 hardware at least, setup can fail, causing ce_id_state to
> +	 * be cleaned up, but this method is still called a few times.  Check
> +	 * for NULL here so we don't crash.  Probably a better fix is to stop
> +	 * the ath10k_pci_ce_tasklet sooner.
> +	 */
> +	if (WARN_ONCE(!ce_state, "ce_id_to_state[%i] is NULL\n", ce_id))
> +		return;
> +
> +	ctrl_addr = ce_state->ctrl_addr;
> +

The tests you add look like workarounds. I would prefer to try fix these
by going to the source of the problem. Maybe we should add
ath10k_pci_wake() and ath10k_do_pci_wake()?

Can you enable few debug logs, like ATH10K_DBG_PCI, and post them? That
would give more hint there things are going wrong.

-- 
Kalle Valo
