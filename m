Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:34805 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751584AbdFGHfI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Jun 2017 03:35:08 -0400
Subject: Re: Wifi-Event for when initial 4-way completes?
To: Ben Greear <greearb@candelatech.com>
References: <854f7995-2cc0-3649-2c94-9ef3c219fb73@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Wojciech Dubowik <wojciech.dubowik@neratec.com>
Message-ID: <f1334e7f-1d86-00fd-cfba-7ce56b8a9f81@neratec.com> (sfid-20170607_093545_139116_93E70B5B)
Date: Wed, 7 Jun 2017 09:25:36 +0200
MIME-Version: 1.0
In-Reply-To: <854f7995-2cc0-3649-2c94-9ef3c219fb73@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Ben,

I have been using this part of wpa_supplicant to notify that 4-Way 
handshake is completed.

around line 868 in wpa_supplicant.c

#if defined(CONFIG_CTRL_IFACE) || !defined(CONFIG_NO_STDOUT_DEBUG)
                 wpa_msg(wpa_s, MSG_INFO, WPA_EVENT_CONNECTED "- 
Connection to "
                         MACSTR " completed [id=%d id_str=%s%s]",
                         MAC2STR(wpa_s->bssid),
                         ssid ? ssid->id : -1,
                         ssid && ssid->id_str ? ssid->id_str : "",
                         fils_hlp_sent ? " FILS_HLP_SENT" : "");
#endif /* CONFIG_CTRL_IFACE || !CONFIG_NO_STDOUT_DEBUG */

You can pack whatever notification message inside the if statement.

Br,

Wojtek


On 07/06/17 02:46, Ben Greear wrote:
> I have been tracking down a nasty EAPOL related bug in ath10k, and 
> found something that may be peripheral, or maybe
> it is significant.
>
> My logic is basically to kick supplicant, watch 'iw events', and then 
> when I see something
> like "sta62 (phy #5): connected to 00:0e:8e:f8:73:96", I consider it 
> connected and start
> dhcpd.
>
> But, it appears that the 'connected' message comes out before the 
> EAPOL 4-way completes, so
> I am starting dhclient before the encryption is really set up 
> properly.  At best, this slows
> things down and makes dhclient have to retry.
>
> Is there some existing event or state I can probe to determine when 
> the initial 4-way is complete?
>
> In case there is not, maybe that event would be worth adding?
>
> Or, should I hack on supplicant instead and grab the info out of it 
> somehow?
>
> Thanks,
> Ben
>
