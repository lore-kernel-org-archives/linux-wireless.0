Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:35662 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946021AbeCBKiG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 05:38:06 -0500
Received: by mail-qt0-f174.google.com with SMTP id z14so11305088qti.2
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2018 02:38:05 -0800 (PST)
Subject: Re: [PATCH 1/2] cfg80211: Add support to enable or disable btcoex
To: Marcel Holtmann <marcel@holtmann.org>
References: <1519927170-11920-1-git-send-email-tamizhr@codeaurora.org>
 <5A9856CE.8000005@broadcom.com> <87po4ndpos.fsf@purkki.adurom.net>
 <5A991D2B.60303@broadcom.com>
 <2FF7A02D-0DBA-4F05-85A3-70D0EDD677F5@holtmann.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Tamizh chelvam <tamizhr@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Bluetooth mailing list
        <linux-bluetooth@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A99298A.6070407@broadcom.com> (sfid-20180302_113822_782564_5B976539)
Date: Fri, 2 Mar 2018 11:38:02 +0100
MIME-Version: 1.0
In-Reply-To: <2FF7A02D-0DBA-4F05-85A3-70D0EDD677F5@holtmann.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/2/2018 10:59 AM, Marcel Holtmann wrote:
> Hi Arend,
>
>>>>> This patch introduces NL80211_CMD_SET_BTCOEX command and
>>>>> NL80211_ATTR_BTCOEX_OP attribute to enable or disable btcoex.
>>>>
>>>> What kind of btcoex are we talking about here? Is it signalling
>>>> between wlan and bt to get access to the shared RF.
>>>
>>> Yes, at least that's how I understand this.
>>>
>>>> Why would it require user-space interaction? Are there no options for
>>>> wlan to detect bt is in use, ie. bt hci is setup, and vice versa. Can
>>>> it be indicated in platform data or device tree. Trying to understand
>>>> the use-case here.
>>>
>>> One use case is being able to disable btcoex in case of problems or to
>>> test if it's btcoex related. I think during the last five years the need
>>> for this interface has come every once in a while.
>>
>> Well, you would want to disable btcoex *and* bt to verify wlan is working properly on its own. And similarly disable btcoex *and* wlan to verify bt works properly.
>>
>> Now I do recall a thread between you and Marcel. Looked it up and it was this thread [1], but did not see a follow-up on it. I suspect it involves more than just an enable/disable state. That may be fine for devices in which BT and WLAN are integrated and coordination of RF use is done on the device. The "btcoex subsystem" thread seems to aim for more like providing the coordination logic so independent BT device and WLAN device can still use the same RF. So before adopting the api in nl80211 it would be good to revive that thread.
>
> actually we can solve any number of WiFi devices vs any number of Bluetooth devices on the same host. It goes mainly in the direction of WiFi having a notifier about its currently used channels and Bluetooth subsystem can subscribe to these and issue AFH channel map classification updates as needed.

I see. From this I would say the notifier functionality would sit nicely 
in cfg80211.

> The other way around for the Bluetooth audio cases and a shared antenna, you need a tighter integration. If the antenna is not shared, then it makes no difference anyway since you are not sharing the transceiver. Normally these are just handled by the firmware internally and right priorities for RF scheduling are done. The Bluetooth controller normally then does a bit too much, but nobody wants to implement that in the host cleanly, and so they all hack it into the controller. I think that Realtek has some older chips where it would be really needed in the host. And Intel controllers can also let the host do it, but by default it is magically done by the controller.

Not entirely sure what you mean by "does a bit too much", but this is 
what I considered as being btcoex. Indeed most do the whole coordination 
in the device and not on the host. Pretty sure about Broadcom ;-)

Regards,
Arend
