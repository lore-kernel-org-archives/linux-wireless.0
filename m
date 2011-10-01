Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48491 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab1JAStH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 14:49:07 -0400
Received: by yxl31 with SMTP id 31so2472079yxl.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 Oct 2011 11:49:05 -0700 (PDT)
Message-ID: <4E87609E.5030002@lwfinger.net> (sfid-20111001_204912_147289_72AB2B02)
Date: Sat, 01 Oct 2011 13:49:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ian Jeffray <ian@emobix.co.uk>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: r8712u driver - on ARM
References: <4E81ED65.7060703@emobix.co.uk> <201110011822.00637.chunkeey@googlemail.com> <4E875365.50206@lwfinger.net> <201110012001.05111.chunkeey@googlemail.com> <4E8757A8.1010302@emobix.co.uk>
In-Reply-To: <4E8757A8.1010302@emobix.co.uk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/01/2011 01:10 PM, Ian Jeffray wrote:
> On 01/10/2011 19:01, Christian Lamparter wrote:
>> On Saturday 01 October 2011 19:52:37 Larry Finger wrote:
>>> On 10/01/2011 11:22 AM, Christian Lamparter wrote:
>>>> On Saturday 01 October 2011 18:01:08 Larry Finger wrote:
>>>>> Ian,
>>>>>
>>>>> Most of the skb assignments in r8712u are aligned OK and most aligned on
>>>>> 512-byte boundaries, but there was one that had the minimal offset of 14
>>>>> bytes.
>>>>> The attached patch should fix it. Does it help?
>>>> Interesting, this "patch" goes in a completely different direction.
>>>> Can you tell me where the driver aligns the frames which will be
>>>> xmitted by the device [i.e.: which

is passed to the usb subsystem
>>>> by usb_submit_urb]? Because that's what actually matters.
>>>
>>> In this driver, all references are to _usb_submit_urb(), which is defined to be
>>> usb_submit_urb() in one of the header files. That made it easy to insert a test
>>> for misalignment of the DMA buffer as follows:
>
> <snip>
>
>>> +static inline int _usb_submit_urb(struct urb *urb, gfp_t mem_flags)
>>> +{
>>> + if (urb->transfer_dma& 3) {
>
> <snip>
>
>> I think you need to check transfer_buffer and not transfer_dma.
>
> I tried checking both transfer_buffer and transfer_dma and all
> were always word aligned. (At least on Blackfin)

The same with x86_64.

Larry
