Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33650 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993Ab3IQTQT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 15:16:19 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Mack <zonque@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "s.neumann@raumfeld.com" <s.neumann@raumfeld.com>,
	"afenkart@gmail.com" <afenkart@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes.berg@intel.com" <johannes.berg@intel.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Tue, 17 Sep 2013 12:15:36 -0700
Subject: RE: [PATCH 3.12] mwifiex: queue main work from main process when
 bailing on races
Message-ID: <477F20668A386D41ADCC57781B1F70430F44C5880A@SC-VEXCH1.marvell.com> (sfid-20130917_211636_969080_C231AA87)
References: <1379442330-18249-1-git-send-email-zonque@gmail.com>
In-Reply-To: <1379442330-18249-1-git-send-email-zonque@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> Queue main_work in case mwifiex_main_process() bails due to an already
> processed transaction. This is particularly necessary because
> mwifiex_main_process() is called from both the SDIO interrupt handler and
> the workqueue. In case an interrupt occurs while the main process is
> currently executed from the workqueue, the interrupt is lost, resulting in a
> command timeout and consequently a card reset.
> 
> I'm marking this for stable kernel in version 3.7+, because on our platform,
> the issue appears since 601216e12c ("mwifiex: process RX packets in SDIO
> IRQ thread directly") went in.
> 
> Signed-off-by: Daniel Mack <zonque@gmail.com>
> Reported-by: Sven Neumann <s.neumann@raumfeld.com>
> Reported-by: Andreas Fenkart <afenkart@gmail.com>
> Cc: Bing Zhao <bzhao@marvell.com>
> Cc: <stable@vger.kernel.org> [v3.7+]

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/mwifiex/main.c
> b/drivers/net/wireless/mwifiex/main.c
> index ff4ed96..0700bc2 100644
> --- a/drivers/net/wireless/mwifiex/main.c
> +++ b/drivers/net/wireless/mwifiex/main.c
> @@ -235,6 +235,7 @@ int mwifiex_main_process(struct mwifiex_adapter
> *adapter)
>  	/* Check if already processing */
>  	if (adapter->mwifiex_processing) {
>  		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
> +		queue_work(adapter->workqueue, &adapter->main_work);
>  		goto exit_main_proc;
>  	} else {
>  		adapter->mwifiex_processing = true;
> --
> 1.8.3.1

