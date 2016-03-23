Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:33909 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbcCWKpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2016 06:45:07 -0400
Received: by mail-pf0-f178.google.com with SMTP id x3so21844625pfb.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2016 03:45:06 -0700 (PDT)
Subject: Re: Problem with brcmfmac removing extra interface
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <CACna6rzA1JcTjBsozR5nhCH9U9bKwceTNwLzeQ-Ds97NECVaeQ@mail.gmail.com>
 <CACna6rwgOuUtgjduwgQoZPFewZ3Wn2vgXapCvqw1ygbyt3Jqaw@mail.gmail.com>
 <56F1A9E9.5090803@broadcom.com>
 <CACna6ryFGQT56QGxsMF=a5Qi+eDp+3mByoxTQidWrxR6qRpBmA@mail.gmail.com>
Cc: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <56F273AB.2060001@broadcom.com> (sfid-20160323_114512_113614_8BFC6692)
Date: Wed, 23 Mar 2016 11:44:59 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6ryFGQT56QGxsMF=a5Qi+eDp+3mByoxTQidWrxR6qRpBmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23-3-2016 9:47, Rafał Miłecki wrote:
> On 22 March 2016 at 21:24, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 22-3-2016 7:36, Rafał Miłecki wrote:
>>> On 3 March 2016 at 23:37, Rafał Miłecki <zajec5@gmail.com> wrote:
>>>> brcmfmac in general is not capable of removing interfaces. If you take
>>>> a look at brcmf_cfg80211_del_iface implementation, you'll see it
>>>> returns -EOPNOTSUPP (except for p2p interfaces).
>>>>
>>>> However there is problem in handling NL80211_CMD_STOP_AP (with the
>>>> brcmf_cfg80211_stop_ap callback). Current implementation calls
>>>> brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1)
>>>> if mbss support is enabled/used.
>>>>
>>>> Above call results in firmware generating BRCMF_E_LINK event. This
>>>> event is handled with the following forward-traced functions chain:
>>>> 1) brcmf_notify_connect_status
>>>> 2) brcmf_notify_connect_status_ap
>>>> 3) brcmf_remove_interface
>>>> 4) brcmf_del_if
>>>> 5) brcmf_net_detach
>>>> 6) unregister_netdev
>>>>
>>>> So the result of NL80211_CMD_STOP_AP is interface being removed. The
>>>> problem with this behavior is that interface can't be recreated after
>>>> that:
>>>> # iw phy phy1 interface add wlan1-1 type __ap
>>>> [ 3602.929199] brcmfmac: brcmf_ap_add_vif: timeout occurred
>>>> command failed: I/O error (-5)
>>>>
>>>> I hit this problem when trying to restart hostapd using BCM43602 and 2 BSSes.
>>>>
>>>> Could you analyze this problem and see if you see some way of solving
>>>> this problem, please?
>>>
>>> Hi, any ideas / help regarding this issue?
>>
>> Restarting hostapd obviously is a valid scenario. My guess is we would
>> need to avoid interface removal in brcmf_notify_connect_status_ap. But
>> first I would like to know in which state the firmware is upon
>> brcmf_ap_add_vif. Can you provide a full log with FWCON debug level enabled?
> 
> Sure, hope it helps!

Ah. Actually would like to see some driver logging as well so
'debug=0x101410'.

> 3) killall hostapd
> [  234.424528] device wlan1-1 left promiscuous mode
> [  234.429453] br-lan: port 3(wlan1-1) entered disabled state
> [  234.842185] brcmfmac: CONSOLE: 026816.727 wl0: link down (wl0)
> [  234.842224] brcmfmac: CONSOLE: 026816.727 wl0: link down (wl0.2)

This part at least is interesting and I would like to know how brcmfmac
deals with this order of events.

Regards,
Arend
