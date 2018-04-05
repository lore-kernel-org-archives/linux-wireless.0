Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:40061 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752000AbeDEIHH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 04:07:07 -0400
Received: by mail-wm0-f46.google.com with SMTP id x4so4283235wmh.5
        for <linux-wireless@vger.kernel.org>; Thu, 05 Apr 2018 01:07:06 -0700 (PDT)
Subject: Re: Wi-Fi Disconnection on Suspend for no wowlan triggers
To: Johannes Berg <johannes@sipsolutions.net>,
        Steve deRosier <derosier@gmail.com>,
        Sunil Dutt Undekari <usdutt@qti.qualcomm.com>
References: <0663e93cc5ca45e6b7191760414b1189@aphydexm01f.ap.qualcomm.com>
 <CALLGbRJgAtOdZ1puzfgpWxc_ZrDVmWXtmFrBu=-gA0C++WrLoA@mail.gmail.com>
 <5AC5D33F.4090100@broadcom.com> <1522915172.7140.1.camel@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Amarnath Hullur Subramanyam <amarnath@qti.qualcomm.com>,
        Rajesh Chauhan <rajeshc@qti.qualcomm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AC5D928.6020505@broadcom.com> (sfid-20180405_100713_025080_0C2867E4)
Date: Thu, 5 Apr 2018 10:07:04 +0200
MIME-Version: 1.0
In-Reply-To: <1522915172.7140.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/5/2018 9:59 AM, Johannes Berg wrote:
> On Thu, 2018-04-05 at 09:41 +0200, Arend van Spriel wrote:
>>
>> So for a full-mac device or a mac80211 device with certain offloads
>> (that we may already have, eg. 4way-hs offloads) you could keep up the
>> connection for a while, but if it is receiving data it probably wants to
>> wake-up the host at some point. So if such a device has means to do a
>> host wake-up you could keep the connection upon suspend. You could
>> consider such behavior a wowlan trigger as well and extend that.
>
> There's the "any" trigger that might be appropriate for that, or a
> "disconnect" trigger.
>
> But I'm basically thinking the same as Steve - if you're never going to
> wake up the host, there's not really much point in keeping the
> connection, and if you only suspend briefly like e.g. on Android then
> you probably *do* want to wake up the host for pretty much everything
> that's going on (hence the "any" trigger).

Agree, which is why I suggested to look at wowlan triggers. If we 
already have an appropriate "any" trigger even better ;-)

Regards,
Arend
