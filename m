Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37169 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbbE0TTQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 15:19:16 -0400
Received: by wifw1 with SMTP id w1so34771794wif.0
        for <linux-wireless@vger.kernel.org>; Wed, 27 May 2015 12:19:15 -0700 (PDT)
Message-ID: <55661894.9060007@gmail.com> (sfid-20150527_211922_973607_A37D091C)
Date: Wed, 27 May 2015 22:18:44 +0300
From: Nick Dimov <dimovnike@gmail.com>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	Dan Williams <dcbw@redhat.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: packet loss, disconnects and possible bug in iwlwifi
References: <55605637.1080503@gmail.com>	<CANUX_P0OzQ45pChQxc-9WVK=7_qh6M4CcE28U6pnu5RbH-qNuQ@mail.gmail.com>	<55650565.6020303@gmail.com>	<1432742132.15971.29.camel@redhat.com> <CANUX_P1FohPUd4+9znUorjZi7Js=xJiX4T=G9JA504-NdgUHZQ@mail.gmail.com>
In-Reply-To: <CANUX_P1FohPUd4+9znUorjZi7Js=xJiX4T=G9JA504-NdgUHZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
It looks the problem on 2.4Ghz is different - I get packet loss
sometimes but there are no disconnects, no wpa_supplicant entries in
syslog at all. Now it runs great and  is connected at 300mbps. I can not
reproduce the packet loss on 2.4Ghz anymore.
Does this help? How to update the regulatory database?

On 27.05.2015 21:34, Emmanuel Grumbach wrote:
> On Wed, May 27, 2015 at 6:55 PM, Dan Williams <dcbw@redhat.com> wrote:
>> On Wed, 2015-05-27 at 02:44 +0300, Nick Dimov wrote:
>>> Hello,
>>> thank you for your response. I attach the full syslog since the last
>>> boot which contains some disconnects. I enabled debug mode for
>>> wpa_supplicant with -dd option (let me know if you need anything else).
>>>
>>> I also tried connecting directly, i.e. without NetworkManager but
>>> manually with wpa_supplicant and I still get disconnects, howvever
>>> wpa_supplicant gives different logs with different drivers. Please, see
>>> the file wifi.log (you can see there the driver i used in
>>> wpa_supplicant, that log doesn't have the debug activated but let me
>>> know if you need that too)
>> So if NM isn't involved in your later runs (and it's not, looking at the
>> logs), then I'm not sure what the issue could be except something in the
>> driver.
>>
>> mai 27 02:31:54 nick-G55VW wpa_supplicant[1565]: nl80211: Event message
>> available
>> mai 27 02:31:54 nick-G55VW wpa_supplicant[1565]: nl80211: Drv Event 20
>> (NL80211_CMD_DEL_STATION) received for wlan5
>> mai 27 02:31:54 nick-G55VW wpa_supplicant[1565]: nl80211: Delete station
>> d8:50:e6:da:1d:b4
>> mai 27 02:31:54 nick-G55VW kernel: wlan5: deauthenticating from
>> d8:50:e6:da:1d:b4 by local choice (Reason: 3=DEAUTH_LEAVING)
>>
>> I don't see anything interesting around those lines, so I guess its up
>> to Emmanuel now...  the tracing he requests would be good to get.
>>
> I suspect a regulatory problem. This is why I asked what was the
> channel used on 2.4GHz. On 5.2GHz we have seen bugs happening because
> of the regulatory database being ancient on Ubuntu. 2.4GHz should rule
> these problems out, unless we are talking about channel 12 and up or
> something like that.

