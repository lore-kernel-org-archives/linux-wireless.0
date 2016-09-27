Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35117 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752956AbcI0JGZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 05:06:25 -0400
Received: by mail-wm0-f44.google.com with SMTP id l132so163920481wmf.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2016 02:06:25 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: implement more accurate skb tracking
To: Dan Williams <dcbw@redhat.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <20160926102348.8695-1-zajec5@gmail.com>
 <09084e8b-829d-9a13-ae16-a493438216ac@broadcom.com>
 <CACna6rwnLb3sEPmdx6uhYMstVn04WbP2xzznsjnwgguEXn04=w@mail.gmail.com>
 <1474901966.4519.8.camel@redhat.com>
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
Message-ID: <c7b81eec-974a-a624-fbac-6d06f5380261@broadcom.com> (sfid-20160927_110631_051047_B42D36AB)
Date: Tue, 27 Sep 2016 11:06:09 +0200
MIME-Version: 1.0
In-Reply-To: <1474901966.4519.8.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-9-2016 16:59, Dan Williams wrote:
> On Mon, 2016-09-26 at 14:13 +0200, Rafał Miłecki wrote:
>> On 26 September 2016 at 13:46, Arend Van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>>
>>> On 26-9-2016 12:23, Rafał Miłecki wrote:
>>>>
>>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>>
>>>> We need to track 802.1x packets to know if there are any pending
>>>> ones
>>>> for transmission. This is required for performing key update in
>>>> the
>>>> firmware.
>>>
>>> The problem we are trying to solve is a pretty old one. The problem
>>> is
>>> that wpa_supplicant uses two separate code paths: EAPOL messaging
>>> through data path and key configuration though nl80211.
>>
>> Can I find it described/reported somewhere?
> 
> If I understand the issue correctly, you can find all this in the
> supplicant code.  Once the supplicant has done whatever it wants to do
> with the data frames that just happen to be EAPOL it then sends the
> keys down to the driver with nl80211.

Indeed. EAPOL packets are simply data packets as far as the 802.11 stack
is concerned. The arrival of those in the driver is not predictable
hence we hold off the key configuration until those have been passed
over to firmware.

> But it sounds like, instead of sniffing EAPOL frames in the driver skb
> tracking and sniffing ETH_P_PAE, you should probably implement support
> for NL80211_CMD_CRIT_PROTOCOL_START/NL80211_CMD_CRIT_PROTOCOL_STOP and
> key off the passed-in NL80211_CRIT_PROTO_EAPOL.  At least at the
> beginning of connection setup only EAPOL packets will be allowed
> anyway.
> 
> It doesn't seem like the supplicant uses NL80211_CRIT_PROTO_EAPOL yet,
> but that should also be fixed in the supplicant itself.  You should
> probably get some comments from Jouni on how he'd like to see all this
> work.  But generally the less specific sniffing of frames in drivers,
> likely the better.

Indeed. That was the main motivation to introduce the CRIT_PROTO api. If
I recall correctly it was considered the task of the network manager to
issue the START/STOP. Recently noticed the use of CRIT_PROTO_DHCP on
some target system, which we already support in brcmfmac. From your
response I guess you consider CRIT_PROTO_EAPOL to be issued by the
supplicant.

Regards,
Arend

> Dan
> 
>>
>>>
>>>>
>>>> Unfortunately our old tracking code wasn't very accurate. It was
>>>> treating skb as pending as soon as it was passed by the netif.
>>>> Actual
>>>> handling packet to the firmware was happening later as brcmfmac
>>>> internally queues them and uses its own worker(s).
>>>
>>> That does not seem right. As soon as we get a 1x packet we need to
>>> wait
>>> with key configuration regardless whether it is still in the driver
>>> or
>>> handed over to firmware already.
>>
>> OK, thanks.
