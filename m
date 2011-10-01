Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51354 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150Ab1JASKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 14:10:16 -0400
Message-ID: <4E8757A8.1010302@emobix.co.uk> (sfid-20111001_201019_927271_D86CE9BF)
Date: Sat, 01 Oct 2011 19:10:48 +0100
From: Ian Jeffray <ian@emobix.co.uk>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: r8712u driver - on ARM
References: <4E81ED65.7060703@emobix.co.uk> <201110011822.00637.chunkeey@googlemail.com> <4E875365.50206@lwfinger.net> <201110012001.05111.chunkeey@googlemail.com>
In-Reply-To: <201110012001.05111.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/10/2011 19:01, Christian Lamparter wrote:
> On Saturday 01 October 2011 19:52:37 Larry Finger wrote:
>> On 10/01/2011 11:22 AM, Christian Lamparter wrote:
>>> On Saturday 01 October 2011 18:01:08 Larry Finger wrote:
>>>> Ian,
>>>>
>>>> Most of the skb assignments in r8712u are aligned OK and most aligned on
>>>> 512-byte boundaries, but there was one that had the minimal offset of 14 bytes.
>>>> The attached patch should fix it. Does it help?
>>> Interesting, this "patch" goes in a completely different direction.
>>> Can you tell me where the driver aligns the frames which will be
>>> xmitted by the device [i.e.: which is passed to the usb subsystem
>>> by usb_submit_urb]? Because that's what actually matters.
>>
>> In this driver, all references are to _usb_submit_urb(), which is defined to be
>> usb_submit_urb() in one of the header files. That made it easy to insert a test
>> for misalignment of the DMA buffer as follows:

<snip>

>> +static inline int _usb_submit_urb(struct urb *urb, gfp_t mem_flags)
>> +{
>> +       if (urb->transfer_dma&  3) {

<snip>

> I think you need to check transfer_buffer and not transfer_dma.

I tried checking both transfer_buffer and transfer_dma and all
were always word aligned.  (At least on Blackfin)

Ian.

-- 
Ian Jeffray    ian@emobix.co.uk    Tel: +44 (0) 141 221 8449
emobix Limited, Suite 5/5, 29 St Vincent Place, Glasgow, G1 2DT
Registered in Scotland; Company No. 371276 - VAT No. 983 4833 78
