Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:44652 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0AXF6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 00:58:11 -0500
Received: by pxi12 with SMTP id 12so1937604pxi.33
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 21:58:10 -0800 (PST)
Message-ID: <4B5BE16E.7080901@lwfinger.net>
Date: Sat, 23 Jan 2010 23:58:06 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Johannes Berg <johannes@sipsolutions.net>, kecsa@kutfo.hit.bme.hu,
	linux-wireless@vger.kernel.org
Subject: Re: hwtkip hangs on b43
References: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu> <201001232000.07229.mb@bu3sch.de> <4B5B4E9F.8040708@lwfinger.net> <201001232038.55204.mb@bu3sch.de>
In-Reply-To: <201001232038.55204.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2010 01:38 PM, Michael Buesch wrote:
> On Saturday 23 January 2010 20:31:43 Larry Finger wrote:
>> On 01/23/2010 01:00 PM, Michael Buesch wrote:
>>> On Saturday 23 January 2010 19:53:48 Johannes Berg wrote:
>>>> Actually you can't, because you can't acquire the mutex here since we're
>>>> in an atomic section. So relying on it being already locked is probably
>>>> safer. However, you can't actually sleep anyway...
>>>
>>> I'm OK with removing the lock from the callback, if it is guaranteed that
>>> the callback is only called on behalf of a RX call.
>>>
>>> We can just remove the lock and add a comment explaining why it is not locked...
>>
>> That works for me.
>>
>
>
> untested
>
> ---

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
---

