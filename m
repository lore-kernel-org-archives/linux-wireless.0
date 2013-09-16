Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:51234 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3IPXAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 19:00:21 -0400
Message-ID: <52378D81.3070707@gmail.com> (sfid-20130917_010028_367938_B040F587)
Date: Tue, 17 Sep 2013 01:00:17 +0200
From: Daniel Mack <zonque@gmail.com>
MIME-Version: 1.0
To: Bing Zhao <bzhao@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"s.neumann@raumfeld.com" <s.neumann@raumfeld.com>,
	"afenkart@gmail.com" <afenkart@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes.berg@intel.com" <johannes.berg@intel.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/1] mwifiex: queue main work from main process when bailing
 on races
References: <1379331546-30617-1-git-send-email-zonque@gmail.com> <1379331546-30617-2-git-send-email-zonque@gmail.com> <477F20668A386D41ADCC57781B1F70430F44C5849E@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F44C5849E@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

On 16.09.2013 23:14, Bing Zhao wrote:
>> diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
>> index ff4ed96..0700bc2 100644
>> --- a/drivers/net/wireless/mwifiex/main.c
>> +++ b/drivers/net/wireless/mwifiex/main.c
>> @@ -235,6 +235,7 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
>>  	/* Check if already processing */
>>  	if (adapter->mwifiex_processing) {
>>  		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
>> +		queue_work(adapter->workqueue, &adapter->main_work);
> 
> This is specific to SDIO interface,

Is it really? By checking adapter->mwifiex_processing, the driver seems
to expect mwifiex_main_process() to be called from multiple execution
paths, and in that case, we will always loose one execution cycle in
case we bail early. I actually wonder why this didn't hit us earlier,
but I might miss a detail.

OTOH, the worst thing that can happen if the function is executed too
often is that it exits early and does nothing.

> +               if (adapter->iface_type == MWIFIEX_SDIO)
> +                       queue_work(adapter->workqueue, &adapter->main_work);

I can of course add this, but I don't fully understand why the driver
takes care of concurrently running executing paths and then just bails
silently in case a race is detected.


Best regards,
Daniel

