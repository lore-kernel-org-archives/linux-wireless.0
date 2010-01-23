Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f186.google.com ([209.85.223.186]:65032 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab0AWSeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 13:34:22 -0500
Received: by iwn16 with SMTP id 16so1026583iwn.33
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 10:34:21 -0800 (PST)
Message-ID: <4B5B412B.7080502@lwfinger.net>
Date: Sat, 23 Jan 2010 12:34:19 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Johannes Berg <johannes@sipsolutions.net>, kecsa@kutfo.hit.bme.hu,
	linux-wireless@vger.kernel.org
Subject: Re: hwtkip hangs on b43
References: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu> <4B5B2FCF.2000005@lwfinger.net> <1264268862.23766.0.camel@johannes.local> <201001231919.32466.mb@bu3sch.de>
In-Reply-To: <201001231919.32466.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2010 12:19 PM, Michael Buesch wrote:
> On Saturday 23 January 2010 18:47:42 Johannes Berg wrote:
>>
>> I think this might be because update_tkip_key is called from within the
>> RX path, so it's probably not even safe to use mutexes to start with?
>
> Well, if mac80211 does a callback into the driver on behalf of a driver call,
> that is broken design. It would break for all locks, not just mutexes.
> We should probably switch back to ieee80211_rx_irqsafe to workaround these
> circular locking problems.

Michael, I'll let you fix this. I do confirm that the mutex is locked when the 
update_tkip_key callback is invoked.

Was this problem introduced with the switch to interrupt threads? If so, then 
the fix needs to be applied to 2.6.32 and 2.6.33.

Larry
