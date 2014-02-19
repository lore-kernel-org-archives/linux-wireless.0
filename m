Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40101 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaBSW7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 17:59:08 -0500
Received: by mail-wi0-f172.google.com with SMTP id e4so5275088wiv.17
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 14:59:07 -0800 (PST)
Message-ID: <53053735.9020305@gmail.com> (sfid-20140219_235913_186029_0DACAE95)
Date: Wed, 19 Feb 2014 22:59:01 +0000
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] staging: vt6656: Remove typedef enum _CONTEXT_TYPE
References: <1392846993.20211.15.camel@canaries64-MCP7A>	 <1392848134.24844.16.camel@joe-AO722> <5305304B.5050004@gmail.com> <1392849119.24844.17.camel@joe-AO722>
In-Reply-To: <1392849119.24844.17.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19/02/14 22:31, Joe Perches wrote:
> On Wed, 2014-02-19 at 22:29 +0000, Malcolm Priestley wrote:
>> On 19/02/14 22:15, Joe Perches wrote:
>>> On Wed, 2014-02-19 at 21:56 +0000, Malcolm Priestley wrote:
>>>> Replace with enum
>>>> assign as u8 type.
>>> []
>>>> diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
>>> []
>>>> @@ -180,7 +180,7 @@ struct vnt_usb_send_context {
>>>>    	struct sk_buff *pPacket;
>>>>    	struct urb *pUrb;
>>>>    	unsigned int uBufLen;
>>>> -	CONTEXT_TYPE Type;
>>>> +	u8 type;
>>>
>>> This doesn't really save any space in the struct.
>>> You might move it immediately before or after bBoolInUse.
>>>
>>>>    	struct ethhdr sEthHeader;
>>>>    	void *Next;
>>>>    	bool bBoolInUse;
>>>
>>>
>> No, but there are dead members in the structure that need removing.
>>
>> sEthHeader and Next are dead
>
> Then it'll all work out well in the end...
>
Oh sorry sEthHeader isn't dead, but will go dead in the future under 
mac80211.

I'll do a patch to reorder the structure.

