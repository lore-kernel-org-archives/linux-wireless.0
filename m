Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:49560 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbbA0VeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 16:34:20 -0500
Received: by mail-ie0-f172.google.com with SMTP id rd18so17864651iec.3
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 13:34:19 -0800 (PST)
Date: Tue, 27 Jan 2015 16:33:49 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Peter Oh <poh@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Replace ioread with wmb for data sync
Message-ID: <20150127213349.GA24933@localhost> (sfid-20150127_223425_034033_83AFD25A)
References: <1422311118-11320-1-git-send-email-poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422311118-11320-1-git-send-email-poh@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 26, 2015 at 02:25:18PM -0800, Peter Oh wrote:
> Using ioread() to perform data sync is excessive.
> Use compact API, wmb(), that intended to be used for the case.
> It reduces total 14 CPU clocks per interrupt.

Hi,

>  	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS + PCIE_INTR_CLR_ADDRESS,
>  			   PCIE_INTR_FIRMWARE_MASK | PCIE_INTR_CE_MASK_ALL);
>  
> -	/* IMPORTANT: this extra read transaction is required to
> -	 * flush the posted write buffer. */
> -	(void)ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
> -				PCIE_INTR_ENABLE_ADDRESS);
> +	/* invoke data sync barrier */
> +	wmb();
>  }

I am no expert in arcane PCI matters, but that looks suspicious to me.  I seem
to recall wmb() only enforced ordering, and maybe not even memory-IO ordering
on all platforms.  If you want to disable an irq, it really seems like you
would want to flush posted writes so you know the hardware has seen it.

-- 
Bob Copeland %% http://bobcopeland.com/
