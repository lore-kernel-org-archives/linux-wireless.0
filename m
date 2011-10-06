Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21106 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935288Ab1JFL2B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 07:28:01 -0400
Message-ID: <4E8D90BB.5040506@qca.qualcomm.com> (sfid-20111006_132806_414847_88E682CD)
Date: Thu, 6 Oct 2011 14:27:55 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: ath6kl: pass only unicast frames for aggregation
References: <20111005055958.GA32513@elgon.mountain> <4E8C2CF1.7000206@qca.qualcomm.com> <20111005115738.GA7368@jouni.qca.qualcomm.com>
In-Reply-To: <20111005115738.GA7368@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/05/2011 02:57 PM, Jouni Malinen wrote:
> On Wed, Oct 05, 2011 at 01:09:53PM +0300, Kalle Valo wrote:
>> Good catch, thanks! I should run smatch more, it's a really nice tool.
> 
> This could have actually been found even before
> 5694f962964c5162f6b49ddb5d517180bd7d1d98 with more thorough static
> analysis since an A-MSDU sent to ath6kl AP would have hit the NULL
> pointer dereference in aggr_slice_amsdu().. Anyway, this new commit does
> indeed seem to make this much more likely to hit the issue (any data
> frame between two associated STAs).

Good point, I'll mention in the patch how severe this actually is.

>> I think a fix like this would be appropriate. Jouni, what do you think?
> 
>> --- a/drivers/net/wireless/ath/ath6kl/txrx.c
>> +++ b/drivers/net/wireless/ath/ath6kl/txrx.c
>> @@ -1247,6 +1247,10 @@ void ath6kl_rx(struct htc_target *target, struct
>> htc_packet *packet)
>>                 }
>>                 if (skb1)
>>                         ath6kl_data_tx(skb1, ar->net_dev);
>> +
>> +               if (skb == NULL)
>> +                       /* nothing to deliver up the stack */
>> +                       return;
>>         }
>>
>>         datap = (struct ethhdr *) skb->data;
> 
> 
> This looks like the correct behavior here. However, I would recommend
> using braces around any multi-line conditional statement even if it
> really is a comment and a single statement that would not, in theory,
> require this in C language. Leaving those out here seems to be just
> asking for problems should someone add something before the "return;"
> line and not notice to add braces at that point. The same comment would
> actually apply for the commit 5694f962964c5162f6b49ddb5d517180bd7d1d98,
> too. If you want to avoid the extra line an braces, moving the comment
> to the end of the return line would work for me.

I have used to not using braces even there's a comment like here. But
you have a point and I'll change my style.

Thanks for checking this.

Kalle
