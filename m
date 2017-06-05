Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54312 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751335AbdFELtz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 07:49:55 -0400
From: Xinming Hu <huxm@marvell.com>
To: Brian Norris <briannorris@chromium.org>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Cathy Luo <cluo@marvell.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/14] mwifiex: pcie: properly synchronize, disable
 interrupts in driver callbacks
Date: Mon, 5 Jun 2017 11:49:50 +0000
Message-ID: <1496663390500.11161@marvell.com> (sfid-20170605_135021_977783_15522C9A)
References: <20170525001119.64791-1-briannorris@chromium.org>
 <20170531171058.GA54739@google.com>
In-Reply-To: <20170531171058.GA54739@google.com>
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org
> [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Brian Norris
> Sent: 2017年6月1日 1:11
> To: Ganapathi Bhat; Nishant Sarmukadam
> Cc: linux-kernel@vger.kernel.org; Dmitry Torokhov; Amitkumar Karwar; Kalle
> Valo; linux-wireless@vger.kernel.org
> Subject: Re: [PATCH 01/14] mwifiex: pcie: properly synchronize, disable
> interrupts in driver callbacks
> 
> By the way, this had a few review comments elsewhere, which I'll summarize
> here, since I plan to resubmit a new version sometime.
> 
> On Wed, May 24, 2017 at 05:11:06PM -0700, Brian Norris wrote:
> > It seems that the implicit assumption of the mwifiex
> > {enable,disable}_int() callbacks is that after ->disable_int(), all
> > interrupt handling should be complete (synchronized) and not fire
> > again until after ->enable_int(). Also, interrupts should not be
> > serviced until after the first ->enable_int().
> >
> > However, the PCIe driver does none of this. First, the existing
> > interrupt mask programming appears to only have an effect for legacy
> > interrupts. It doesn't actually prevent MSI/MSI-X interrupts. Second,
> > even when it might mask interrupts, we're doing nothing to ensure that
> > pending IRQs have finished processing; they could be already in-flight
> > when a CPU masks them.
> >
> > Another quirk of this driver's design is the use of a racy
> > "surprise_removed" check in mwifiex_pcie_interrupt(). This appears to
> > act like a racy poor-man's version of masking our interrupts -- it
> > allows us to short-circuit the ISR if it fires when we're not prepared
> > to handle more work.
> >
> > We can resolve this all by:
> > (a) disabling our IRQs after requesting them
> > (b) call {enable,disable}_irq() in the {enable,disable}_int()
> > callbacks
> > (c) remove the racy '->surprise_removed' hack from
> >     mwifiex_pcie_interrupt()
> > (d) document the effect (or lack thereof) of PCIE_HOST_INT_MASK, to
> >     clarify and possibly prevent future misuse
> >
> > Along the way, I decided to use underscores to prefix the
> > driver-private forms of "disabling interrupts" (instead of the awkward
> > "_noerr" suffix used already), partly to discourage their use.
> >
> > Signed-off-by: Brian Norris <briannorris@chromium.org>
> > ---
> >  drivers/net/wireless/marvell/mwifiex/pcie.c | 70
> > ++++++++++++++++++++---------
> >  1 file changed, 49 insertions(+), 21 deletions(-)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > index 394224d6c219..ea75315bf19d 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > @@ -505,12 +505,10 @@ static int
> > mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)  }
> >
> >  /*
> > - * This function disables the host interrupt.
> > - *
> > - * The host interrupt mask is read, the disable bit is reset and
> > - * written back to the card host interrupt mask register.
> > + * This function masks the host interrupt. Effective only for legacy
> > + PCI
> > + * interrupts.
> >   */
> > -static int mwifiex_pcie_disable_host_int(struct mwifiex_adapter
> > *adapter)
> > +static int __mwifiex_pcie_disable_host_int(struct mwifiex_adapter
> > +*adapter)
> >  {
> >  	if (mwifiex_pcie_ok_to_access_hw(adapter)) {
> >  		if (mwifiex_write_reg(adapter, PCIE_HOST_INT_MASK, @@ -525,18
> > +523,30 @@ static int mwifiex_pcie_disable_host_int(struct mwifiex_adapter
> *adapter)
> >  	return 0;
> >  }
> >
> > -static void mwifiex_pcie_disable_host_int_noerr(struct
> > mwifiex_adapter *adapter)
> > +/*
> > + * Disable interrupts, synchronizing with any outstanding interrupts.
> > + */
> > +static void mwifiex_pcie_disable_host_int(struct mwifiex_adapter
> > +*adapter)
> >  {
> > -	WARN_ON(mwifiex_pcie_disable_host_int(adapter));
> > +	struct pcie_service_card *card = adapter->card;
> > +	int i;
> > +
> > +	WARN_ON(__mwifiex_pcie_disable_host_int(adapter));
> > +
> > +	if (card->msix_enable) {
> > +		for (i = 0; i < MWIFIEX_NUM_MSIX_VECTORS; i++) {
> > +			disable_irq(card->msix_entries[i].vector);
> > +		}
> > +	} else {
> > +		disable_irq(card->dev->irq);
> 
> This approach is not safe for the non-MSI-X case, since we actually requested
> this IRQ with IRQF_SHARED. That's likely mostly for the legacy PCI interrupt
> case (where we *have* to support shared interrupts) and could probably be
> modified, but at any rate, this is unsafe as written.
> 
> Also, I've fielded objections to using the host-level IRQ masking for disabling
> MSI interrupts here. I'm still not completely sure *why* the objection, but I'm
> investigating whether there's any device-level mechanism for disabling MSI
> interrupts on the Wif card. (Marvell folks, feel free to speak up here.)
> 

per our investigate:
the msi interrupt could be latch  in device function temporary(pci_msi_mask_irq), but it is not able to disable interrupt generating from device, these pending interrupts will arrive after pci_msi_unmask_irq.. 

this is expected , as implied by the spec “While a vector is masked, the function is prohibited from sending the associated message, and the function must set the associated Pending bit whenever the function would otherwise send the message. When software unmasks a vector whose associated Pending bit is set, the function must schedule sending the associated message, and clear the Pending bit as soon as the message has been sent.”

Apart from these two API, the only way we can find is pci_disable_msi/msix, obviously not suitable..(quite strange, there is no lightweight host API for disable MSI interrupt,, maybe something related with MSI spec..)

And from device side, in current design, there is no similar “Host Interrupt Status Mask” registers/logics to prevent PCIe MSI logic to latch the interrupt request it received.



Regards,
Simon

> > +	}
> >  }
> >
> >  /*
> > - * This function enables the host interrupt.
> > - *
> > - * The host interrupt enable mask is written to the card
> > - * host interrupt mask register.
> > + * This function unmasks the host interrupt. Effective only for
> > + legacy PCI
> > + * interrupts.
> >   */
> > -static int mwifiex_pcie_enable_host_int(struct mwifiex_adapter
> > *adapter)
> > +static int __mwifiex_pcie_enable_host_int(struct mwifiex_adapter
> > +*adapter)
> >  {
> >  	if (mwifiex_pcie_ok_to_access_hw(adapter)) {
> >  		/* Simply write the mask to the register */ @@ -551,6 +561,26 @@
> > static int mwifiex_pcie_enable_host_int(struct mwifiex_adapter *adapter)
> >  	return 0;
> >  }
> >
> > +static int mwifiex_pcie_enable_host_int(struct mwifiex_adapter
> > +*adapter) {
> > +	struct pcie_service_card *card = adapter->card;
> > +	int i, ret;
> > +
> > +	ret = __mwifiex_pcie_enable_host_int(adapter);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (card->msix_enable) {
> > +		for (i = 0; i < MWIFIEX_NUM_MSIX_VECTORS; i++) {
> > +			enable_irq(card->msix_entries[i].vector);
> > +		}
> > +	} else {
> > +		enable_irq(card->dev->irq);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  /*
> >   * This function initializes TX buffer ring descriptors
> >   */
> > @@ -1738,7 +1768,7 @@ static int
> mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
> >  			while (reg->sleep_cookie && (count++ < 10) &&
> >  			       mwifiex_pcie_ok_to_access_hw(adapter))
> >  				usleep_range(50, 60);
> > -			mwifiex_pcie_enable_host_int(adapter);
> > +			__mwifiex_pcie_enable_host_int(adapter);
> >  			mwifiex_process_sleep_confirm_resp(adapter, skb->data,
> >  							   skb->len);
> >  		} else {
> > @@ -2081,7 +2111,7 @@ static int mwifiex_prog_fw_w_helper(struct
> mwifiex_adapter *adapter,
> >  		    "info: Downloading FW image (%d bytes)\n",
> >  		    firmware_len);
> >
> > -	if (mwifiex_pcie_disable_host_int(adapter)) {
> > +	if (__mwifiex_pcie_disable_host_int(adapter)) {
> >  		mwifiex_dbg(adapter, ERROR,
> >  			    "%s: Disabling interrupts failed.\n", __func__);
> >  		return -1;
> > @@ -2335,8 +2365,7 @@ static void mwifiex_interrupt_status(struct
> mwifiex_adapter *adapter,
> >  		if ((pcie_ireg == 0xFFFFFFFF) || !pcie_ireg)
> >  			return;
> >
> > -
> > -		mwifiex_pcie_disable_host_int(adapter);
> > +		__mwifiex_pcie_disable_host_int(adapter);
> >
> >  		/* Clear the pending interrupts */
> >  		if (mwifiex_write_reg(adapter, PCIE_HOST_INT_STATUS, @@ -2387,9
> > +2416,6 @@ static irqreturn_t mwifiex_pcie_interrupt(int irq, void *context)
> >  	}
> >  	adapter = card->adapter;
> >
> > -	if (adapter->surprise_removed)
> > -		goto exit;
> > -
> >  	if (card->msix_enable)
> >  		mwifiex_interrupt_status(adapter, ctx->msg_id);
> >  	else
> > @@ -2494,7 +2520,7 @@ static int mwifiex_process_pcie_int(struct
> mwifiex_adapter *adapter)
> >  		    "info: cmd_sent=%d data_sent=%d\n",
> >  		    adapter->cmd_sent, adapter->data_sent);
> >  	if (!card->msi_enable && adapter->ps_state != PS_STATE_SLEEP)
> > -		mwifiex_pcie_enable_host_int(adapter);
> > +		__mwifiex_pcie_enable_host_int(adapter);
> >
> >  	return 0;
> >  }
> > @@ -3055,6 +3081,7 @@ static int mwifiex_pcie_request_irq(struct
> mwifiex_adapter *adapter)
> >  						  &card->msix_ctx[i]);
> >  				if (ret)
> >  					break;
> > +				disable_irq(card->msix_entries[i].vector);
> 
> Also, if we're really dealing with spurious interrupts at init time, then this
> leaves a window of time in between request_irq() and this
> disable_irq() in which we could still receive a bad IRQ. So this should be
> reworked to do one of:
> (a) move the request_irq() later, until we're really able to handle interrupts
> (b) set the IRQ_NOAUTOEN flag (for the non-shared case), to avoid enabling
> IRQs initially
> (c) use some sort of (yet-unknown) device-level mask for MSI interrupts.
> 
> I'm looking to address these problems in a v2. Many of the other patches are
> likely independent. I'll plan to resubmit them in the next series (if they aren't
> applied before then), to avoid conflicts with those that aren't independent,
> and because I intentionally put bugfixes (like this
> patch) first in the series.
> 
> Brian
> 
> >  			}
> >
> >  			if (ret) {
> > @@ -3087,6 +3114,7 @@ static int mwifiex_pcie_request_irq(struct
> mwifiex_adapter *adapter)
> >  		pr_err("request_irq failed: ret=%d\n", ret);
> >  		return -1;
> >  	}
> > +	disable_irq(pdev->irq);
> >
> >  	return 0;
> >  }
> > @@ -3244,7 +3272,7 @@ static struct mwifiex_if_ops pcie_ops = {
> >  	.register_dev =			mwifiex_register_dev,
> >  	.unregister_dev =		mwifiex_unregister_dev,
> >  	.enable_int =			mwifiex_pcie_enable_host_int,
> > -	.disable_int =			mwifiex_pcie_disable_host_int_noerr,
> > +	.disable_int =			mwifiex_pcie_disable_host_int,
> >  	.process_int_status =		mwifiex_process_int_status,
> >  	.host_to_card =			mwifiex_pcie_host_to_card,
> >  	.wakeup =			mwifiex_pm_wakeup_card,
> > --
> > 2.13.0.219.gdb65acc882-goog
> >
