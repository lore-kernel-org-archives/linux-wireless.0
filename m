Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58030 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751976AbeCMOp2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 10:45:28 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Tamizh chelvam <tamizhr@codeaurora.org>, johannes@sipsolutions.net,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Bluetooth mailing list
        <linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH 1/2] cfg80211: Add support to enable or disable btcoex
References: <1519927170-11920-1-git-send-email-tamizhr@codeaurora.org>
        <5A9856CE.8000005@broadcom.com> <87po4ndpos.fsf@purkki.adurom.net>
        <5A991D2B.60303@broadcom.com>
Date: Tue, 13 Mar 2018 16:45:22 +0200
In-Reply-To: <5A991D2B.60303@broadcom.com> (Arend van Spriel's message of
        "Fri, 2 Mar 2018 10:45:15 +0100")
Message-ID: <87k1ug9gql.fsf@kamboji.qca.qualcomm.com> (sfid-20180313_154532_835490_CE976F32)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> + Marcel
>
> On 3/2/2018 6:14 AM, Kalle Valo wrote:
>> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>>
>>> On 3/1/2018 6:59 PM, Tamizh chelvam wrote:
>>>> From: Tamizh chelvam <tamizhr@codeaurora.org>
>>>>
>>>> This patch introduces NL80211_CMD_SET_BTCOEX command and
>>>> NL80211_ATTR_BTCOEX_OP attribute to enable or disable btcoex.
>>>
>>> What kind of btcoex are we talking about here? Is it signalling
>>> between wlan and bt to get access to the shared RF.
>>
>> Yes, at least that's how I understand this.
>>
>>> Why would it require user-space interaction? Are there no options for
>>> wlan to detect bt is in use, ie. bt hci is setup, and vice versa. Can
>>> it be indicated in platform data or device tree. Trying to understand
>>> the use-case here.
>>
>> One use case is being able to disable btcoex in case of problems or to
>> test if it's btcoex related. I think during the last five years the need
>> for this interface has come every once in a while.
>
> Well, you would want to disable btcoex *and* bt to verify wlan is
> working properly on its own. And similarly disable btcoex *and* wlan
> to verify bt works properly.

Sure. But my main motiviation with this is to replace the module
parameters we already have:

drivers/net/wireless/ath/ath9k/htc_drv_init.c:module_param_named(btcoex_enable, ath9k_htc_btcoex_enable, int, 0444);
drivers/net/wireless/ath/ath9k/htc_drv_init.c:MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");

drivers/net/wireless/ath/ath9k/init.c:module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
drivers/net/wireless/ath/ath9k/init.c:MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");

drivers/net/wireless/broadcom/b43/main.c:module_param_named(btcoex, modparam_btcoex, int, 0444);
drivers/net/wireless/broadcom/b43/main.c:MODULE_PARM_DESC(btcoex, "Enable Bluetooth coexistence (default on)");

But looking closely in ath9k cases it doesn't actually sound doable as
IIRC the ath9k module parameters are off by default. In b43 it's enabled
by default, though.

> Now I do recall a thread between you and Marcel. Looked it up and it
> was this thread [1], but did not see a follow-up on it. I suspect it
> involves more than just an enable/disable state. That may be fine for
> devices in which BT and WLAN are integrated and coordination of RF use
> is done on the device. The "btcoex subsystem" thread seems to aim for
> more like providing the coordination logic so independent BT device
> and WLAN device can still use the same RF. So before adopting the api
> in nl80211 it would be good to revive that thread.

I think that "btcoex subsystem" is a holy grail which will be never
implemented :) But who knows, miracles can happen...

-- 
Kalle Valo
