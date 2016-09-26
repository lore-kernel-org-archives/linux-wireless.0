Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35282 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034113AbcIZMVR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 08:21:17 -0400
Received: by mail-pf0-f175.google.com with SMTP id s13so31052846pfd.2
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2016 05:21:17 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: implement more accurate skb tracking
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <20160926102348.8695-1-zajec5@gmail.com>
 <09084e8b-829d-9a13-ae16-a493438216ac@broadcom.com>
 <CACna6rwnLb3sEPmdx6uhYMstVn04WbP2xzznsjnwgguEXn04=w@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <dd7ae3d7-fa6d-c27c-a19f-712d01c423d7@broadcom.com> (sfid-20160926_142138_565173_4D1907FA)
Date: Mon, 26 Sep 2016 14:20:59 +0200
MIME-Version: 1.0
In-Reply-To: <CACna6rwnLb3sEPmdx6uhYMstVn04WbP2xzznsjnwgguEXn04=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 26-9-2016 14:13, Rafał Miłecki wrote:
> On 26 September 2016 at 13:46, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 26-9-2016 12:23, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> We need to track 802.1x packets to know if there are any pending ones
>>> for transmission. This is required for performing key update in the
>>> firmware.
>>
>> The problem we are trying to solve is a pretty old one. The problem is
>> that wpa_supplicant uses two separate code paths: EAPOL messaging
>> through data path and key configuration though nl80211.
> 
> Can I find it described/reported somewhere?

Not sure. It is something that I recall from working at Intersil so back
in the prism days.

Regards,
Arend

>>> Unfortunately our old tracking code wasn't very accurate. It was
>>> treating skb as pending as soon as it was passed by the netif. Actual
>>> handling packet to the firmware was happening later as brcmfmac
>>> internally queues them and uses its own worker(s).
>>
>> That does not seem right. As soon as we get a 1x packet we need to wait
>> with key configuration regardless whether it is still in the driver or
>> handed over to firmware already.
> 
> OK, thanks.
> 
