Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18479 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab2B1Hlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 02:41:49 -0500
Message-ID: <4F4C8525.70205@qca.qualcomm.com> (sfid-20120228_084153_676842_BD2B1E8D)
Date: Tue, 28 Feb 2012 09:41:25 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl: Fix memory leak of rx packets in endpoint
 0
References: <1328886633-2823-1-git-send-email-vthiagar@qca.qualcomm.com> <1328886633-2823-2-git-send-email-vthiagar@qca.qualcomm.com> <4F4BBBE5.4060101@qca.qualcomm.com> <20120228042632.GA2892@vasanth-laptop>
In-Reply-To: <20120228042632.GA2892@vasanth-laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/2012 06:26 AM, Vasanthakumar Thiagarajan wrote:
> On Mon, Feb 27, 2012 at 07:22:45PM +0200, Kalle Valo wrote:
>> On 02/10/2012 05:10 PM, Vasanthakumar Thiagarajan wrote:
>>> htc_packet and htc_packet->buf_start are separately allocated
>>> for endpoint 0. This is different for other endpoints where
>>> packets are allocated as skb where htc_packet is skb->head
>>> and they are freed properly. Free htc_packet and htc_packet->buf_start
>>> separatly for endpoint 0.
>>>
>>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

[...]

>>> +			/*
>>> +			 * packets in rx_bufq of endpoint 0 have originally
>>> +			 * been queued from target->free_ctrl_rxbuf where
>>> +			 * packet and packet->buf_start are allocated
>>> +			 * separately using kmalloc(). For other endpoint
>>> +			 * rx_bufq, it is allocated as skb where packet is
>>> +			 * skb->head. Take care of this difference while freeing
>>> +			 * the memory.
>>> +			 */
>>> +			if (packet->endpoint == ENDPOINT_0) {
>>> +				kfree(packet->buf_start);
>>> +				kfree(packet);
>>> +			} else {
>>> +				dev_kfree_skb(packet->pkt_cntxt);
>>> +			}
>>
>> I didn't look at the code, but my question would it be possible to use
>> skbs also with endpoint 0? That would be more consistent aproach than
>> testing for a particular endpoint.
> 
> Yeah, using skbs for control buffer is the right thing, but for the time being
> we can have this fix in.

Ok, fair enough. Let's do it like this.

Kalle
