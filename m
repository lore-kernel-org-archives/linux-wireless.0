Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20643 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002Ab3IPVPA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 17:15:00 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Mack <zonque@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "s.neumann@raumfeld.com" <s.neumann@raumfeld.com>,
	"afenkart@gmail.com" <afenkart@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes.berg@intel.com" <johannes.berg@intel.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Mon, 16 Sep 2013 14:14:08 -0700
Subject: RE: [PATCH 1/1] mwifiex: queue main work from main process when
 bailing on races
Message-ID: <477F20668A386D41ADCC57781B1F70430F44C5849E@SC-VEXCH1.marvell.com> (sfid-20130916_231508_085090_97FABE06)
References: <1379331546-30617-1-git-send-email-zonque@gmail.com>
 <1379331546-30617-2-git-send-email-zonque@gmail.com>
In-Reply-To: <1379331546-30617-2-git-send-email-zonque@gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

Thanks for the patch.

> Queue main_work in case mwifiex_main_process() bails due to an already
> processed transaction. This is particularly necessary because
> mwifiex_main_process() is called from both the SDIO interrupt handler
> and the workqueue. In case an interrupt occurs while the main process
> is currently executed from the workqueue, the interrupt is lost,
> resulting in a command timeout and consequently a card reset.
> 
> I'm marking this for stable kernel in version 3.7+, because on our
> platform, the issue appears since 601216e12c ("mwifiex: process RX
> packets in SDIO IRQ thread directly") went in.
> 
> Signed-off-by: Daniel Mack <zonque@gmail.com>
> Reported-by: Sven Neumann <s.neumann@raumfeld.com>
> Reported-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
> Cc: Bing Zhao <bzhao@marvell.com>
> Cc: <stable@vger.kernel.org> [v3.7+]
> ---
>  drivers/net/wireless/mwifiex/main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
> index ff4ed96..0700bc2 100644
> --- a/drivers/net/wireless/mwifiex/main.c
> +++ b/drivers/net/wireless/mwifiex/main.c
> @@ -235,6 +235,7 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
>  	/* Check if already processing */
>  	if (adapter->mwifiex_processing) {
>  		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
> +		queue_work(adapter->workqueue, &adapter->main_work);

This is specific to SDIO interface, so we'd add a check here.

+               if (adapter->iface_type == MWIFIEX_SDIO)
+                       queue_work(adapter->workqueue, &adapter->main_work);

Thanks,
Bing

>  		goto exit_main_proc;
>  	} else {
>  		adapter->mwifiex_processing = true;
> --
> 1.8.3.1

