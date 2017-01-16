Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34574 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751357AbdAPAy4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Jan 2017 19:54:56 -0500
Date: Sun, 15 Jan 2017 16:54:52 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>
Subject: Re: [PATCH v2 2/3] mwifiex: pcie: don't loop/retry interrupt status
 checks
Message-ID: <20170116005452.GI23285@dtor-ws> (sfid-20170116_015509_873177_B957BF85)
References: <20170113233538.36196-1-briannorris@chromium.org>
 <20170113233538.36196-2-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170113233538.36196-2-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 13, 2017 at 03:35:37PM -0800, Brian Norris wrote:
> The following sequence occurs when using IEEE power-save on 8997:
> (a) driver sees SLEEP event
> (b) driver issues SLEEP CONFIRM
> (c) driver recevies CMD interrupt; within the interrupt processing loop,
>     we do (d) and (e):
> (d) wait for FW sleep cookie (and often time out; it takes a while), FW
>     is putting card into low power mode
> (e) re-check PCIE_HOST_INT_STATUS register; quit loop with 0 value
> 
> But at (e), no one actually signaled an interrupt (i.e., we didn't check
> adapter->int_status). And what's more, because the card is going to
> sleep, this register read appears to take a very long time in some cases
> -- 3 milliseconds in my case!
> 
> Now, I propose that (e) is completely unnecessary. If there were any
> additional interrupts signaled after the start of this loop, then the
> interrupt handler would have set adapter->int_status to non-zero and
> queued more work for the main loop -- and we'd catch it on the next
> iteration of the main loop.
> 
> So this patch drops all the looping/re-reading of PCIE_HOST_INT_STATUS,
> which avoids the problematic (and slow) register read in step (e).
> 
> Incidentally, this is a very similar issue to the one fixed in commit
> ec815dd2a5f1 ("mwifiex: prevent register accesses after host is
> sleeping"), except that the register read is just very slow instead of
> fatal in this case.
> 
> Tested on 8997 in both MSI and (though not technically supported at the
> moment) MSI-X mode.

Well, that kills interrupt mitigation and with PCIE that might be
somewhat important (SDIO is too slow to be important I think) and might
cost you throughput.

OTOH maybe Marvell should convert PICE to NAPI to make this more
obvious and probably more correct.

> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> v2:
>  * new in v2, replacing an attempt to mess with step (d) above
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 102 +++++++++-------------------
>  1 file changed, 32 insertions(+), 70 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 3f4cda2d3b61..194e0e04c3b1 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -2332,79 +2332,41 @@ static int mwifiex_process_pcie_int(struct mwifiex_adapter *adapter)
>  			}
>  		}
>  	}
> -	while (pcie_ireg & HOST_INTR_MASK) {
> -		if (pcie_ireg & HOST_INTR_DNLD_DONE) {
> -			pcie_ireg &= ~HOST_INTR_DNLD_DONE;
> -			mwifiex_dbg(adapter, INTR,
> -				    "info: TX DNLD Done\n");
> -			ret = mwifiex_pcie_send_data_complete(adapter);
> -			if (ret)
> -				return ret;
> -		}
> -		if (pcie_ireg & HOST_INTR_UPLD_RDY) {
> -			pcie_ireg &= ~HOST_INTR_UPLD_RDY;
> -			mwifiex_dbg(adapter, INTR,
> -				    "info: Rx DATA\n");
> -			ret = mwifiex_pcie_process_recv_data(adapter);
> -			if (ret)
> -				return ret;
> -		}
> -		if (pcie_ireg & HOST_INTR_EVENT_RDY) {
> -			pcie_ireg &= ~HOST_INTR_EVENT_RDY;
> -			mwifiex_dbg(adapter, INTR,
> -				    "info: Rx EVENT\n");
> -			ret = mwifiex_pcie_process_event_ready(adapter);
> -			if (ret)
> -				return ret;
> -		}
> -
> -		if (pcie_ireg & HOST_INTR_CMD_DONE) {
> -			pcie_ireg &= ~HOST_INTR_CMD_DONE;
> -			if (adapter->cmd_sent) {
> -				mwifiex_dbg(adapter, INTR,
> -					    "info: CMD sent Interrupt\n");
> -				adapter->cmd_sent = false;
> -			}
> -			/* Handle command response */
> -			ret = mwifiex_pcie_process_cmd_complete(adapter);
> -			if (ret)
> -				return ret;
> -			if (adapter->hs_activated)
> -				return ret;
> -		}
> -
> -		if (card->msi_enable) {
> -			spin_lock_irqsave(&adapter->int_lock, flags);
> -			adapter->int_status = 0;
> -			spin_unlock_irqrestore(&adapter->int_lock, flags);
> -		}
> -
> -		if (mwifiex_pcie_ok_to_access_hw(adapter)) {
> -			if (mwifiex_read_reg(adapter, PCIE_HOST_INT_STATUS,
> -					     &pcie_ireg)) {
> -				mwifiex_dbg(adapter, ERROR,
> -					    "Read register failed\n");
> -				return -1;
> -			}
>  
> -			if ((pcie_ireg != 0xFFFFFFFF) && (pcie_ireg)) {
> -				if (mwifiex_write_reg(adapter,
> -						      PCIE_HOST_INT_STATUS,
> -						      ~pcie_ireg)) {
> -					mwifiex_dbg(adapter, ERROR,
> -						    "Write register failed\n");
> -					return -1;
> -				}
> -			}
> -
> -		}
> -		if (!card->msi_enable) {
> -			spin_lock_irqsave(&adapter->int_lock, flags);
> -			pcie_ireg |= adapter->int_status;
> -			adapter->int_status = 0;
> -			spin_unlock_irqrestore(&adapter->int_lock, flags);
> +	if (pcie_ireg & HOST_INTR_DNLD_DONE) {
> +		pcie_ireg &= ~HOST_INTR_DNLD_DONE;
> +		mwifiex_dbg(adapter, INTR, "info: TX DNLD Done\n");
> +		ret = mwifiex_pcie_send_data_complete(adapter);
> +		if (ret)
> +			return ret;
> +	}
> +	if (pcie_ireg & HOST_INTR_UPLD_RDY) {
> +		pcie_ireg &= ~HOST_INTR_UPLD_RDY;
> +		mwifiex_dbg(adapter, INTR, "info: Rx DATA\n");
> +		ret = mwifiex_pcie_process_recv_data(adapter);
> +		if (ret)
> +			return ret;
> +	}
> +	if (pcie_ireg & HOST_INTR_EVENT_RDY) {
> +		pcie_ireg &= ~HOST_INTR_EVENT_RDY;
> +		mwifiex_dbg(adapter, INTR, "info: Rx EVENT\n");
> +		ret = mwifiex_pcie_process_event_ready(adapter);
> +		if (ret)
> +			return ret;
> +	}
> +	if (pcie_ireg & HOST_INTR_CMD_DONE) {
> +		pcie_ireg &= ~HOST_INTR_CMD_DONE;
> +		if (adapter->cmd_sent) {
> +			mwifiex_dbg(adapter, INTR,
> +				    "info: CMD sent Interrupt\n");
> +			adapter->cmd_sent = false;
>  		}
> +		/* Handle command response */
> +		ret = mwifiex_pcie_process_cmd_complete(adapter);
> +		if (ret)
> +			return ret;
>  	}
> +
>  	mwifiex_dbg(adapter, INTR,
>  		    "info: cmd_sent=%d data_sent=%d\n",
>  		    adapter->cmd_sent, adapter->data_sent);
> -- 
> 2.11.0.483.g087da7b7c-goog
> 

-- 
Dmitry
