Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36645 "EHLO
        mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750940AbcJDWUx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 18:20:53 -0400
Received: by mail-pa0-f54.google.com with SMTP id ry6so1446063pac.3
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2016 15:20:52 -0700 (PDT)
Date: Tue, 4 Oct 2016 15:20:50 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH 1/8] mwifiex: prevent register accesses after host is
 sleeping
Message-ID: <20161004222047.GA4646@localhost> (sfid-20161005_002057_947162_EA51759D)
References: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Sep 28, 2016 at 06:18:21PM +0530, Amitkumar Karwar wrote:
> Following is mwifiex driver-firmware host sleep handshake.
> It involves three threads. suspend handler, interrupt handler, interrupt
> processing in main work queue.
> 
> 1) Enter suspend handler
> 2) Download HS_CFG command
> 3) Response from firmware for HS_CFG
> 4) Suspend thread waits until handshake completes(i.e hs_activate becomes
>    true)
> 5) SLEEP from firmware
> 6) SLEEP confirm downloaded to firmware.
> 7) SLEEP confirm response from firmware
> 8) Driver processes SLEEP confirm response and set hs_activate to wake up
> suspend thread
> 9) Exit suspend handler
> 10) Read sleep cookie in loop and wait until it indicates firmware is
> sleep.
> 11) After processing SLEEP confirm response, we are at the end of interrupt
> processing routine. Recheck if there are interrupts received while we were
> processing them.
> 
> During suspend-resume stress test, it's been observed that we may end up
> acessing PCIe hardware(in 10 and 11) when PCIe bus is closed which leads
> to a kernel crash.
> 
> This patch solves the problem with below changes.
> a) action 10 above can be done before 8
> b) Skip 11 if hs_activated is true. SLEEP confirm response
> is the last interrupt from firmware. No need to recheck for
> pending interrupts.
> c) Add flush_workqueue() in suspend handler.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Reviewed-by: Brian Norris <briannorris@chromium.org>
Tested-by: Brian Norris <briannorris@chromium.org>

> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 3c3c4f1..2833d47 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -118,6 +118,7 @@ static int mwifiex_pcie_suspend(struct device *dev)
>  	adapter = card->adapter;
>  
>  	hs_actived = mwifiex_enable_hs(adapter);
> +	flush_workqueue(adapter->workqueue);
>  
>  	/* Indicate device suspended */
>  	adapter->is_suspended = true;
> @@ -1669,9 +1670,6 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
>  
>  	if (!adapter->curr_cmd) {
>  		if (adapter->ps_state == PS_STATE_SLEEP_CFM) {
> -			mwifiex_process_sleep_confirm_resp(adapter, skb->data,
> -							   skb->len);
> -			mwifiex_pcie_enable_host_int(adapter);
>  			if (mwifiex_write_reg(adapter,
>  					      PCIE_CPU_INT_EVENT,
>  					      CPU_INTR_SLEEP_CFM_DONE)) {
> @@ -1684,6 +1682,9 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
>  			while (reg->sleep_cookie && (count++ < 10) &&
>  			       mwifiex_pcie_ok_to_access_hw(adapter))
>  				usleep_range(50, 60);
> +			mwifiex_pcie_enable_host_int(adapter);
> +			mwifiex_process_sleep_confirm_resp(adapter, skb->data,
> +							   skb->len);
>  		} else {
>  			mwifiex_dbg(adapter, ERROR,
>  				    "There is no command but got cmdrsp\n");
> @@ -2322,6 +2323,8 @@ static int mwifiex_process_pcie_int(struct mwifiex_adapter *adapter)
>  			ret = mwifiex_pcie_process_cmd_complete(adapter);
>  			if (ret)
>  				return ret;
> +			if (adapter->hs_activated)
> +				return ret;
>  		}
>  
>  		if (card->msi_enable) {
> 
