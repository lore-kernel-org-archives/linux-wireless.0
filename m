Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36696 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbcLGHHI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 02:07:08 -0500
Received: by mail-oi0-f41.google.com with SMTP id v84so405612829oie.3
        for <linux-wireless@vger.kernel.org>; Tue, 06 Dec 2016 23:07:08 -0800 (PST)
Subject: Re: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
To: Johannes Berg <johannes@sipsolutions.net>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
References: <20161202205611.14141-1-andrew.zaborowski@intel.com>
 <1480945883.31788.3.camel@sipsolutions.net> <58457FEA.4030305@gmail.com>
 <1480949899.31788.34.camel@sipsolutions.net> <5845824B.4090304@gmail.com>
 <1480950886.31788.44.camel@sipsolutions.net> <584588A2.9090006@gmail.com>
 <1481008560.6610.3.camel@sipsolutions.net> <584730D7.2020708@gmail.com>
 <1481091301.4092.5.camel@sipsolutions.net> <5847AEF9.90409@gmail.com>
 <1481093287.4092.20.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <5847B51A.6090303@gmail.com> (sfid-20161207_080712_008802_7FE80C5B)
Date: Wed, 7 Dec 2016 01:07:06 -0600
MIME-Version: 1.0
In-Reply-To: <1481093287.4092.20.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 12/07/2016 12:48 AM, Johannes Berg wrote:
> On Wed, 2016-12-07 at 00:40 -0600, Denis Kenzior wrote:
>>
>>> No, this is the part you didn't understand. Simply authenticating
>>> doesn't actually create anything like a "link" to the AP. The only
>>
>> Okay, but it is then a bit misleading that iw link reports us being
>> 'connected' during this time for example.
>
> It doesn't!
>
> # iw wlan0 auth <ssid> <bssid> open 2462
>
> -> iw event reporting
> wlan0 (phy #0): auth <localMAC> -> <bssid> status: 0: Successful
>
> # iw wlan0 link
> Not connected.
>

Yes, you're right.  It is iw info that shows us 'connected'

< Request: Get Interface (0x05) len 8 [ack]                 35235.316448
     Interface Index: 3 (0x00000003)
 > Result: New Interface (0x07) len 108                      35235.316455
     Interface Index: 3 (0x00000003)
     Interface Name: wlp2s0
     Wiphy: 0 (0x00000000)
     Interface Type: 2 (0x00000002)
     Wireless Device: 1 (0x0000000000000001)
     Generation: 5 (0x00000005)
     Wiphy Frequency: 2417 (0x00000971)
     Wiphy Channel Type: 1 (0x00000001)
     Channel Width: 1 (0x00000001)
     Center Frequency 1: 2417 (0x00000971)
     Wiphy TX Power Level: 2200 (0x00000898)
 > Response: Get Interface (0x05) len 4                      35235.316457
     Status: Success (0)

>
>> Fair enough.  I think we can live with that since we're not using
>> CMD_AUTHENTICATE unless we need to roam using FT.
>
> That seems like a very strange decision, but it's obviously up to you
> :)
>

Care to elaborate ?

Regards,
-Denis
