Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:40763 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab3IYOXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 10:23:37 -0400
Message-ID: <5242F1D7.4040404@gmail.com> (sfid-20130925_162342_350983_CC96AAF4)
Date: Wed, 25 Sep 2013 16:23:19 +0200
From: Daniel Mack <zonque@gmail.com>
MIME-Version: 1.0
To: Bing Zhao <bzhao@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"s.neumann@raumfeld.com" <s.neumann@raumfeld.com>,
	"afenkart@gmail.com" <afenkart@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes.berg@intel.com" <johannes.berg@intel.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 3.12] mwifiex: queue main work from main process when
 bailing on races
References: <1379442330-18249-1-git-send-email-zonque@gmail.com> <477F20668A386D41ADCC57781B1F70430F44C5880A@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F44C5880A@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17.09.2013 21:15, Bing Zhao wrote:
>> Queue main_work in case mwifiex_main_process() bails due to an already
>> processed transaction. This is particularly necessary because
>> mwifiex_main_process() is called from both the SDIO interrupt handler and
>> the workqueue. In case an interrupt occurs while the main process is
>> currently executed from the workqueue, the interrupt is lost, resulting in a
>> command timeout and consequently a card reset.
>>
>> I'm marking this for stable kernel in version 3.7+, because on our platform,
>> the issue appears since 601216e12c ("mwifiex: process RX packets in SDIO
>> IRQ thread directly") went in.
>>
>> Signed-off-by: Daniel Mack <zonque@gmail.com>
>> Reported-by: Sven Neumann <s.neumann@raumfeld.com>
>> Reported-by: Andreas Fenkart <afenkart@gmail.com>
>> Cc: Bing Zhao <bzhao@marvell.com>
>> Cc: <stable@vger.kernel.org> [v3.7+]
> 
> Acked-by: Bing Zhao <bzhao@marvell.com>

John, could you pick this one?


Many thanks,
Daniel


> 
> Thanks,
> Bing
> 
>> ---
>>  drivers/net/wireless/mwifiex/main.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/wireless/mwifiex/main.c
>> b/drivers/net/wireless/mwifiex/main.c
>> index ff4ed96..0700bc2 100644
>> --- a/drivers/net/wireless/mwifiex/main.c
>> +++ b/drivers/net/wireless/mwifiex/main.c
>> @@ -235,6 +235,7 @@ int mwifiex_main_process(struct mwifiex_adapter
>> *adapter)
>>  	/* Check if already processing */
>>  	if (adapter->mwifiex_processing) {
>>  		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
>> +		queue_work(adapter->workqueue, &adapter->main_work);
>>  		goto exit_main_proc;
>>  	} else {
>>  		adapter->mwifiex_processing = true;
>> --
>> 1.8.3.1
> 

