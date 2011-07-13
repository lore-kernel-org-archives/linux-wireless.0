Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9016 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965002Ab1GMHqt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 03:46:49 -0400
Message-ID: <4E1D4D63.8000909@qca.qualcomm.com> (sfid-20110713_094653_179500_5D6A93E0)
Date: Wed, 13 Jul 2011 10:46:43 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-wireless@vger.kernel.org>, <devel@linuxdriverproject.org>,
	<gregkh@suse.de>
Subject: Re: [PATCH 11/24] ath6kl: add htc.c
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>	 <20110713013444.8517.89603.stgit@localhost6.localdomain6> <1310531449.1143.29.camel@Joe-Laptop>
In-Reply-To: <1310531449.1143.29.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2011 07:30 AM, Joe Perches wrote:
> On Wed, 2011-07-13 at 04:34 +0300, Kalle Valo wrote: 
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
> [] 
>> +static void htc_tx_comp_update(struct htc_target *target,
>> +			       struct htc_endpoint *endpoint,
>> +			       struct htc_packet *packet)
>> +{
> [] 
>> 	ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "ctxt:0x%lx dist:0x%lx\n",
>> +		(unsigned long) target->cred_dist_cntxt,
>> +		(unsigned long *) &target->cred_dist_list);
> 
> compiler warning?

I haven't seen any. But all these unsigned long casts will be removed
anyway.

Kalle
