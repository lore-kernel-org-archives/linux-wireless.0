Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:35516 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbbFFSZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2015 14:25:54 -0400
Received: by oihd6 with SMTP id d6so72220562oih.2
        for <linux-wireless@vger.kernel.org>; Sat, 06 Jun 2015 11:25:54 -0700 (PDT)
Message-ID: <55733B2F.9090807@lwfinger.net> (sfid-20150606_202558_867813_DE778C5C)
Date: Sat, 06 Jun 2015 13:25:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>, Severn <severn@xephris.net>,
	Taehee Yoo <ap420073@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtlwifi NULL pointer dereference
References: <5570FB00.3040108@xephris.net> <87fv65nfcn.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87fv65nfcn.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2015 08:20 AM, Kalle Valo wrote:
> Severn <severn@xephris.net> writes:
>
>> I've been hitting this NULL pointer deref with an rtl8188ee PCIE card.
>> It happens 100% of the time when I bring up a WPA2-PSK AP with hostapd
>> 2.4.
>>
>> If I revert 33511b157bbcebaef853cc1811992b664a2e5862, everything seems
>> to work properly.
>>
>> Below is my hostapd.conf and the crash log. This is mainline 4.0.4
>> with no patches.
>
> Below is the changelog for the commit. Larry & Taehee, what should we
> do?
>
> commit 33511b157bbcebaef853cc1811992b664a2e5862
> Author: Taehee Yoo <ap420073@gmail.com>
> Date:   Wed Jan 21 16:58:19 2015 +0900
>
>      rtlwifi: add support to send beacon frame.
>
>      In AP mode, beacon frame is necessary to keep connection.
>      this patch adds a sending beacon frame routine in initialization routine.
>
>      Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>      Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
>      Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Kalle,

I'm trying to find the missing setup step when the new interface is added to the 
driver. Whatever it is is causing mac80211 to issue the warning at 
net/mac80211/driver-ops.h:12. That problem appears to cascade to the NULL 
pointer dereference. Any help would be appreciated.

Reversion of the above commit may be necessary, but I would like to see if we 
can get a better "fix" as that commit is necessary for proper beaconing.

Larry

