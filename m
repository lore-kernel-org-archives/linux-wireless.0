Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35733 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379AbcEXTtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2016 15:49:41 -0400
Received: by mail-pa0-f49.google.com with SMTP id tb2so9649037pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2016 12:49:41 -0700 (PDT)
Subject: Re: Problem with brcmfmac removing extra interface
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <CACna6rzA1JcTjBsozR5nhCH9U9bKwceTNwLzeQ-Ds97NECVaeQ@mail.gmail.com>
 <CACna6rwgOuUtgjduwgQoZPFewZ3Wn2vgXapCvqw1ygbyt3Jqaw@mail.gmail.com>
 <56F1A9E9.5090803@broadcom.com>
 <CACna6ryFGQT56QGxsMF=a5Qi+eDp+3mByoxTQidWrxR6qRpBmA@mail.gmail.com>
 <56F273AB.2060001@broadcom.com>
 <CACna6rwrNWzU415zK43fiwBc+BbfosdiSrJk11=pCs7uZDYV=w@mail.gmail.com>
Cc: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <590f02bf-63a1-9510-dddb-d903fe03284e@broadcom.com> (sfid-20160524_214945_527278_87BA60E3)
Date: Tue, 24 May 2016 21:49:36 +0200
MIME-Version: 1.0
In-Reply-To: <CACna6rwrNWzU415zK43fiwBc+BbfosdiSrJk11=pCs7uZDYV=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23-3-2016 20:13, Rafał Miłecki wrote:
> On 23 March 2016 at 11:44, Arend Van Spriel 
> <arend.vanspriel@broadcom.com> wrote:
>> On 23-3-2016 9:47, Rafał Miłecki wrote:
>>> On 22 March 2016 at 21:24, Arend van Spriel 
>>> <arend.vanspriel@broadcom.com> wrote:
>>>> On 22-3-2016 7:36, Rafał Miłecki wrote:
>>>>> Hi, any ideas / help regarding this issue?
>>>> 
>>>> Restarting hostapd obviously is a valid scenario. My guess is
>>>> we would need to avoid interface removal in
>>>> brcmf_notify_connect_status_ap. But first I would like to know
>>>> in which state the firmware is upon brcmf_ap_add_vif. Can you
>>>> provide a full log with FWCON debug level enabled?
>>> 
>>> Sure, hope it helps!
>> 
>> Ah. Actually would like to see some driver logging as well so 
>> 'debug=0x101410'.
> 
> Sure, there you go.

A bit overdue, but here we go. Upon killing hostapd it results in
brcmf_cfg80211_stop_ap() for 'OpenWrt5x' bss and we give a DOWN command
for the interface to firmware. However, we get a link down for the
primary interface *and* second interface.

[  172.799334] brcmfmac: brcmf_fil_cmd_int_set ifidx=1, cmd=3, value=1
[  172.802111] brcmfmac: CONSOLE: 026767.523 wl0: link down (wl0)
[  172.802147] brcmfmac: CONSOLE: 026767.523 wl0: link down (wl0.2)
[  172.802166] brcmfmac: brcmf_fweh_event_worker event LINK (16) ifidx 0
bsscfg 0 addr 90:8d:78:66:3a:56
[  172.802173] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0
status 0 reason 4
[  172.802178] brcmutil: event payload, len=0
[  172.802202] brcmfmac: brcmf_fweh_event_worker event LINK (16) ifidx 1
bsscfg 2 addr 92:8d:78:66:3a:57
[  172.802208] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0
status 0 reason 4
[  172.802212] brcmutil: event payload, len=0

Looking into the firmware code it turns out that the DOWN command brings
down the entire stack iso single interface. This seems specific for some
firmware branches so we have to find a better solution. Hante and I are
looking into it.

Regards,
Arend
