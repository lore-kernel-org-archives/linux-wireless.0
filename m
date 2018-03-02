Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:35489 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424864AbeCBJpS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 04:45:18 -0500
Received: by mail-qk0-f181.google.com with SMTP id s188so11198717qkb.2
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2018 01:45:18 -0800 (PST)
Subject: Re: [PATCH 1/2] cfg80211: Add support to enable or disable btcoex
To: Kalle Valo <kvalo@codeaurora.org>
References: <1519927170-11920-1-git-send-email-tamizhr@codeaurora.org>
 <5A9856CE.8000005@broadcom.com> <87po4ndpos.fsf@purkki.adurom.net>
Cc: Tamizh chelvam <tamizhr@codeaurora.org>, johannes@sipsolutions.net,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Bluetooth mailing list
        <linux-bluetooth@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A991D2B.60303@broadcom.com> (sfid-20180302_104558_925848_6057FEE2)
Date: Fri, 2 Mar 2018 10:45:15 +0100
MIME-Version: 1.0
In-Reply-To: <87po4ndpos.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Marcel

On 3/2/2018 6:14 AM, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>
>> On 3/1/2018 6:59 PM, Tamizh chelvam wrote:
>>> From: Tamizh chelvam <tamizhr@codeaurora.org>
>>>
>>> This patch introduces NL80211_CMD_SET_BTCOEX command and
>>> NL80211_ATTR_BTCOEX_OP attribute to enable or disable btcoex.
>>
>> What kind of btcoex are we talking about here? Is it signalling
>> between wlan and bt to get access to the shared RF.
>
> Yes, at least that's how I understand this.
>
>> Why would it require user-space interaction? Are there no options for
>> wlan to detect bt is in use, ie. bt hci is setup, and vice versa. Can
>> it be indicated in platform data or device tree. Trying to understand
>> the use-case here.
>
> One use case is being able to disable btcoex in case of problems or to
> test if it's btcoex related. I think during the last five years the need
> for this interface has come every once in a while.

Well, you would want to disable btcoex *and* bt to verify wlan is 
working properly on its own. And similarly disable btcoex *and* wlan to 
verify bt works properly.

Now I do recall a thread between you and Marcel. Looked it up and it was 
this thread [1], but did not see a follow-up on it. I suspect it 
involves more than just an enable/disable state. That may be fine for 
devices in which BT and WLAN are integrated and coordination of RF use 
is done on the device. The "btcoex subsystem" thread seems to aim for 
more like providing the coordination logic so independent BT device and 
WLAN device can still use the same RF. So before adopting the api in 
nl80211 it would be good to revive that thread.

Regards,
Arend

[1] https://www.spinics.net/lists/linux-wireless/msg133333.html
