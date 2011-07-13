Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12656 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965019Ab1GMHmA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 03:42:00 -0400
Message-ID: <4E1D4C40.9000706@qca.qualcomm.com> (sfid-20110713_094205_052113_41F051D1)
Date: Wed, 13 Jul 2011 10:41:52 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-wireless@vger.kernel.org>, <devel@linuxdriverproject.org>,
	<gregkh@suse.de>
Subject: Re: [PATCH 06/24] ath6kl: add core.h
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>	 <20110713013355.8517.6083.stgit@localhost6.localdomain6> <1310531354.1143.27.camel@Joe-Laptop>
In-Reply-To: <1310531354.1143.27.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2011 07:29 AM, Joe Perches wrote:
> On Wed, 2011-07-13 at 04:33 +0300, Kalle Valo wrote: 
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
> [] 
>> +/* Pkt log info */
>> +struct pkt_log {
>> +	struct info {
>> +		__le16 st;
>> +		__le16 end;
>> +		__le16 cur;
>> +	} info[4096];
>> +	__le16 last_idx;
>> +} __packed;
> 
> pretty big struct.

Indeed.

>> +struct skb_hold_q {
>> +	struct sk_buff *skb;
>> +	bool is_amsdu;
>> +	u16 seq_no;
>> +};
> 
> Maybe all the structs could be inspected for alignment
> and possible packing appropriateness?
> 
> struct sk_buff *skb;
> u16 seq_no;
> bool is_amsdu;
> ?

I added a task to the todo list:

http://wireless.kernel.org/en/users/Drivers/ath6kl/todo

Kalle
