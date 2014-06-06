Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:25964 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaFFJdt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 05:33:49 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath10k:  provide firmware crash info via debugfs.
References: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
Date: Fri, 6 Jun 2014 12:33:44 +0300
In-Reply-To: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Wed, 4 Jun 2014 11:01:39
	-0700")
Message-ID: <87y4xal6vb.fsf@kamboji.qca.qualcomm.com> (sfid-20140606_113354_418868_3A8D3833)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> Store the firmware crash registers and last 128 or so
> firmware debug-log ids and present them to user-space
> via debugfs.
>
> Should help with figuring out why the firmware crashed.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Review part 2.

> @@ -875,6 +877,80 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
>  			   reg_dump_values[i + 2],
>  			   reg_dump_values[i + 3]);
>  
> +	/* Dump the debug logs on the target */
> +	host_addr = host_interest_item_address(HI_ITEM(hi_dbglog_hdr));
> +	if (ath10k_pci_diag_read_mem(ar, host_addr,
> +				     &reg_dump_area, sizeof(u32)) != 0) {
> +		ath10k_warn("failed to read hi_dbglog_hdr\n");

Please print the error code.

> +		goto save_regs_and_restart;
> +	}
> +
> +	ath10k_err("target register Debug Log Location: 0x%08X\n",
> +		   reg_dump_area);

Is this needed? I think this more like debug log material than something
we should report to the user.

> +	ret = ath10k_pci_diag_read_mem(ar, reg_dump_area,
> +				       &dbg_hdr, sizeof(dbg_hdr));
> +	if (ret != 0) {
> +		ath10k_err("failed to dump Debug Log Area\n");

ath10k_warn("failed to dump debug log area: %d\n", ret);

> +		goto save_regs_and_restart;
> +	}
> +
> +	ath10k_err("Debug Log Header, dbuf: 0x%x  dropped: %i\n",
> +		   dbg_hdr.dbuf, dbg_hdr.dropped);

ath10k_dbg()?

> +	dbufp = dbg_hdr.dbuf;
> +	i = 0;
> +	while (dbufp) {

for (i = 0; dbufp > 0; i++)?

> +		struct ath10k_fw_dbglog_buf dbuf;

Please move to the beginning of the function.

> +		ret = ath10k_pci_diag_read_mem(ar, dbufp,
> +					       &dbuf, sizeof(dbuf));
> +		if (ret != 0) {
> +			ath10k_err("failed to read Debug Log Area: 0x%x\n",
> +				   dbufp);

ath10k_warn("failed to read debug log area: %d\n");

> +			goto save_regs_and_restart;
> +		}
> +
> +		/* We have a buffer of data */
> +		ath10k_err("[%i] next: 0x%x buf: 0x%x sz: %i len: %i count: %i free: %i\n",
> +			   i, dbuf.next, dbuf.buffer, dbuf.bufsize, dbuf.length,
> +			   dbuf.count, dbuf.free);

ath10k_dbg()?

> +		if (dbuf.buffer && dbuf.length) {

I would prefer inverse here to keep the indentation clean, something
like:

if (dbuf.buffer == 0 || dbug.length == 0)
        goto next;

> +			u8 *buffer = kmalloc(dbuf.length, GFP_ATOMIC);

Should we have a maximum for the length so that we don't allocate insane
amounts of memory by accident?

> +			if (buffer) {

Again I would prefer the inverse:

if (!buf)
   break;

I assume there's no sense continuing here if kmalloc fails and better
just bail out.

> +				ret = ath10k_pci_diag_read_mem(ar, dbuf.buffer,
> +							       buffer,
> +							       dbuf.length);
> +				if (ret != 0) {
> +					ath10k_err("failed to read Debug Log buffer: 0x%x\n",
> +						   dbuf.buffer);

ath10k_warn("failed to read debug log buffer: %d\n", ret);

> +					kfree(buffer);
> +					goto save_regs_and_restart;
> +				}
> +
> +				ath10k_dbg_save_fw_dbg_buffer(ar, buffer,
> +							      dbuf.length);
> +				kfree(buffer);

Instead of doing atomic allocations multiple times in a loop, would it
be better to allocate just one buffer before the loop and free it
afterwards?

> +			}
> +		}
> +		dbufp = dbuf.next;
> +		if (dbufp == dbg_hdr.dbuf) {
> +			/* It is a circular buffer it seems, bail if next
> +			 * is head
> +			 */
> +			break;
> +		}
> +		i++;
> +	} /* While we have a debug buffer to read */
> +
> +save_regs_and_restart:

exit_save_regs:

> +	if (!ar->crashed_since_read) {
> +		ar->crashed_since_read = true;
> +		memcpy(ar->reg_dump_values, reg_dump_values,
> +		       sizeof(ar->reg_dump_values));
> +	}

How is the locking handled in this function?

> +do_restart:

exit:

>  	queue_work(ar->workqueue, &ar->restart_work);
>  }

-- 
Kalle Valo
