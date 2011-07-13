Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33547 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964995Ab1GMIVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:21:38 -0400
Message-ID: <4E1D558E.3090309@qca.qualcomm.com> (sfid-20110713_102143_384368_C7FC4142)
Date: Wed, 13 Jul 2011 11:21:34 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-wireless@vger.kernel.org>, <devel@linuxdriverproject.org>,
	<gregkh@suse.de>
Subject: Re: [PATCH 21/24] ath6kl: add txrx.c
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>	 <20110713013630.8517.77720.stgit@localhost6.localdomain6> <1310531463.1143.31.camel@Joe-Laptop>
In-Reply-To: <1310531463.1143.31.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2011 07:31 AM, Joe Perches wrote:
> On Wed, 2011-07-13 at 04:36 +0300, Kalle Valo wrote:
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>>  drivers/net/wireless/ath/ath6kl/txrx.c | 1471 ++++++++++++++++++++++++++++++++
> []
>> +int ath6kl_control_tx(void *devt, struct sk_buff *skb,
>> +		      enum htc_endpoint_id eid)
>> +{
> []
>> +	ath6kl_dbg(ATH6KL_DBG_WLAN_TX,
>> +		   "%s: skb=0x%lx, len=0x%x eid =%d\n", __func__,
>> +		   (unsigned long)skb, skb->len, eid);
> 
> 
> This style of casting a pointer to an unsigned long is used
> unnecessarily quite often.
> 
> I think it's more intelligible to use %p without the case.
> Also, hex length is often not as readable as decimal.
> 
> 	ath6kl_dbg(ATH6KL_DBG_WLAN_TX, "%s: skb=%p, len=%u eid=%d\n",
> 		   __func__, skb, skb->len, eid);

I agree. We already had a task in the todo list about this.

Kalle
