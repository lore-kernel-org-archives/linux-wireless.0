Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40221 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1HXQx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 12:53:56 -0400
Received: by ewy4 with SMTP id 4so574590ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 09:53:55 -0700 (PDT)
Message-ID: <4E552C9F.1020104@lwfinger.net> (sfid-20110824_185400_444098_DB32F68D)
Date: Wed, 24 Aug 2011 11:53:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFT][PATCH] b43: use 8K buffers for 64-bit DMA to workaround
 hardware bug
References: <1314201438-12125-1-git-send-email-zajec5@gmail.com> <20110824180611.36af5a83@milhouse>
In-Reply-To: <20110824180611.36af5a83@milhouse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2011 11:06 AM, Michael Büsch wrote:
> On Wed, 24 Aug 2011 17:57:18 +0200
> Rafał Miłecki<zajec5@gmail.com>  wrote:
>
>> +	/* For unknown reasons - possibly a hardware error - the BCM4311 rev
>>   	 * 02, which uses 64-bit DMA, needs the ring buffer in very low memory,
>>   	 * which accounts for the GFP_DMA flag below.
>> -	 *
>> -	 * The flags here must match the flags in free_ringmemory below!
>>   	 */
>> +	gfp_t flags = GFP_KERNEL;
>>   	if (ring->type == B43_DMA_64BIT)
>>   		flags |= GFP_DMA;
>
>
> Did somebody actually re-evaluate this?
> I still believe that this is not a hardware error, but rather a software
> bug in the DMA allocator that probably is fixed already.
>
> Larry, I think you added this. Do you still have the device that triggered this?

Yes, I do. I'll test the BCM4311 with the GFP_KERNEL flag.

Larry
