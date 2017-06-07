Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40694 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbdFGQKi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Jun 2017 12:10:38 -0400
Subject: Re: Wifi-Event for when initial 4-way completes?
To: Wojciech Dubowik <wojciech.dubowik@neratec.com>
References: <854f7995-2cc0-3649-2c94-9ef3c219fb73@candelatech.com>
 <f1334e7f-1d86-00fd-cfba-7ce56b8a9f81@neratec.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <8b8f6fa1-8687-b0f9-03ab-20e8f9ab2c1c@candelatech.com> (sfid-20170607_181148_491996_18DED3B0)
Date: Wed, 7 Jun 2017 09:10:37 -0700
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

Thanks for the hint.  How do you receive this?  By leaving 'wpa_cli' running?

I am having my supplicant manage 64+ station vdevs...is there a way to make it
get events from all of them at once so that I don't need 64+ monitor processes?

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
