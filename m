Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47017 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbZK2NyY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2009 08:54:24 -0500
Received: from public by plane.gmane.org with local (Exim 4.63)
	(envelope-from <public@plane.gmane.org>)
	id 1NEjQ4-0005ng-Uw
	for linux-wireless@vger.kernel.org; Sun, 29 Nov 2009 14:02:28 +0100
From: Andreas Schwab <schwab@linux-m68k.org>
To: Gertjan van Wingerde
	<public-gwingerde-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>
Cc: rt2x00 Users List
	<public-users-poMEt7QlJxcwIE2E9O76wjtx2kNaKg5H@plane.gmane.org>,
	Benoit PAPILLAULT
	<public-benoit.papillault-GANU6spQydw@plane.gmane.org>,
	Ivo van Doorn
	<public-ivdoorn-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org
Subject: Re: [rt2x00-users] [PATCH] rt2x00: Further L2 padding fixes.
References: <1259433154-2587-1-git-send-email-gwingerde@gmail.com>
	<200911282226.58091.IvDoorn@gmail.com> <4B1199A7.7090903@gmail.com>
	<4B11B860.4080607@free.fr> <4B125EA0.3020200@gmail.com>
Date: Sun, 29 Nov 2009 14:02:23 +0100
In-Reply-To: <4B125EA0.3020200@gmail.com> (Gertjan van Wingerde's message of
	"Sun, 29 Nov 2009 12:44:32 +0100")
Message-ID: <m2y6lpscv4.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Gertjan van Wingerde <gwingerde-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
writes:

> On 11/29/09 00:55, Benoit PAPILLAULT wrote:
>> Gertjan van Wingerde a écrit :
>>> On 11/28/09 22:26, Ivo van Doorn wrote:
>>>>> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
>>>>> index b8f0954..562a344 100644
>>>>> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
>>>>> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
>>>>> @@ -181,7 +181,7 @@ void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
>>>>>  	unsigned int frame_length = skb->len;
>>>>>  	unsigned int header_align = ALIGN_SIZE(skb, 0);
>>>>>  	unsigned int payload_align = ALIGN_SIZE(skb, header_length);
>>>>> -	unsigned int l2pad = 4 - (payload_align - header_align);
>>>>> +	unsigned int l2pad = 4 - (header_length & 3);
>> 
>> Humm... is header_length = 24, then your formula gives l2pad = 4. If so,
>> this is wrong. Do I miss something?
>
> No, you are right. The formula needs another & 3 on the overall result to account for that situation.
> So, it should be:
>
> 	unsigned int l2pad = (4 - (header_length & 3)) & 3;

aka
	unsigned int l2pad = -header_length & 3;

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

