Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55902 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbdFHPVI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Jun 2017 11:21:08 -0400
Subject: Re: Wifi-Event for when initial 4-way completes?
To: Wojciech Dubowik <wojciech.dubowik@neratec.com>
References: <854f7995-2cc0-3649-2c94-9ef3c219fb73@candelatech.com>
 <f1334e7f-1d86-00fd-cfba-7ce56b8a9f81@neratec.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <bbf39c69-66a5-1e23-77df-1945d0036719@candelatech.com> (sfid-20170608_172143_158098_D60DEC58)
Date: Thu, 8 Jun 2017 08:21:07 -0700
MIME-Version: 1.0
In-Reply-To: <f1334e7f-1d86-00fd-cfba-7ce56b8a9f81@neratec.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2017 12:25 AM, Wojciech Dubowik wrote:
> Hello Ben,
>
> I have been using this part of wpa_supplicant to notify that 4-Way handshake is completed.
>
> around line 868 in wpa_supplicant.c
>
> #if defined(CONFIG_CTRL_IFACE) || !defined(CONFIG_NO_STDOUT_DEBUG)
>                 wpa_msg(wpa_s, MSG_INFO, WPA_EVENT_CONNECTED "- Connection to "
>                         MACSTR " completed [id=%d id_str=%s%s]",
>                         MAC2STR(wpa_s->bssid),
>                         ssid ? ssid->id : -1,
>                         ssid && ssid->id_str ? ssid->id_str : "",
>                         fils_hlp_sent ? " FILS_HLP_SENT" : "");
> #endif /* CONFIG_CTRL_IFACE || !CONFIG_NO_STDOUT_DEBUG */
>
> You can pack whatever notification message inside the if statement.

I'm not sure that actually is correct?  For instance, I see this in a case where
WPA-2 was not succesfully negotiated (note the reason-2 disconnect)

IFNAME=sta9 <3>SME: Trying to authenticate with 00:0e:8e:f8:73:96 (SSID='ota-9k-2 space' freq=5180 MHz)
IFNAME=sta9 <3>Trying to associate with 00:0e:8e:f8:73:96 (SSID='ota-9k-2 space' freq=5180 MHz)
IFNAME=sta9 <3>Associated with 00:0e:8e:f8:73:96
IFNAME=sta9 <3>CTRL-EVENT-SUBNET-STATUS-UPDATE status=0
IFNAME=sta9 <3>WPA: Key negotiation completed with 00:0e:8e:f8:73:96 [PTK=CCMP GTK=CCMP]
IFNAME=sta9 <3>CTRL-EVENT-CONNECTED - Connection to 00:0e:8e:f8:73:96 completed [id=0 id_str=]
IFNAME=sta9 <3>WPA: Key negotiation completed with 00:0e:8e:f8:73:96 [PTK=CCMP GTK=CCMP]
IFNAME=sta9 <3>WPA: Key negotiation completed with 00:0e:8e:f8:73:96 [PTK=CCMP GTK=CCMP]
IFNAME=sta9 <3>WPA: Key negotiation completed with 00:0e:8e:f8:73:96 [PTK=CCMP GTK=CCMP]
IFNAME=sta9 <3>CTRL-EVENT-DISCONNECTED bssid=00:0e:8e:f8:73:96 reason=2


Looks like I might need to add another message about EAPOL 4-way completing?

Thanks,
Ben


>
> Br,
>
> Wojtek
>
>
> On 07/06/17 02:46, Ben Greear wrote:
>> I have been tracking down a nasty EAPOL related bug in ath10k, and found something that may be peripheral, or maybe
>> it is significant.
>>
>> My logic is basically to kick supplicant, watch 'iw events', and then when I see something
>> like "sta62 (phy #5): connected to 00:0e:8e:f8:73:96", I consider it connected and start
>> dhcpd.
>>
>> But, it appears that the 'connected' message comes out before the EAPOL 4-way completes, so
>> I am starting dhclient before the encryption is really set up properly.  At best, this slows
>> things down and makes dhclient have to retry.
>>
>> Is there some existing event or state I can probe to determine when the initial 4-way is complete?
>>
>> In case there is not, maybe that event would be worth adding?
>>
>> Or, should I hack on supplicant instead and grab the info out of it somehow?
>>
>> Thanks,
>> Ben
>>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
