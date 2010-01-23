Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:54619 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab0AWTbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 14:31:48 -0500
Received: by pwi21 with SMTP id 21so1474982pwi.21
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 11:31:47 -0800 (PST)
Message-ID: <4B5B4E9F.8040708@lwfinger.net>
Date: Sat, 23 Jan 2010 13:31:43 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Johannes Berg <johannes@sipsolutions.net>, kecsa@kutfo.hit.bme.hu,
	linux-wireless@vger.kernel.org
Subject: Re: hwtkip hangs on b43
References: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu> <201001231919.32466.mb@bu3sch.de> <1264272828.23766.6.camel@johannes.local> <201001232000.07229.mb@bu3sch.de>
In-Reply-To: <201001232000.07229.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2010 01:00 PM, Michael Buesch wrote:
> On Saturday 23 January 2010 19:53:48 Johannes Berg wrote:
>> Actually you can't, because you can't acquire the mutex here since we're
>> in an atomic section. So relying on it being already locked is probably
>> safer. However, you can't actually sleep anyway...
>
> I'm OK with removing the lock from the callback, if it is guaranteed that
> the callback is only called on behalf of a RX call.
>
> We can just remove the lock and add a comment explaining why it is not locked...

That works for me.

Larry
