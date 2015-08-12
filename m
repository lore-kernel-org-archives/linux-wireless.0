Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:2734 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965077AbbHLI6x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2015 04:58:53 -0400
Message-ID: <55CB0ACA.3000109@broadcom.com> (sfid-20150812_105919_306789_875CA8B8)
Date: Wed, 12 Aug 2015 10:58:50 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] brcmfmac: nvram loading and code rework
References: <1436553071-32423-1-git-send-email-arend@broadcom.com>	<CACna6rwJwjiNKnfjV8cH9_fvE38SWLf5ng8ap15OktUZQhOedg@mail.gmail.com>	<55AD2C8F.9010509@broadcom.com> <CACna6rzdE1GubDquszC3jqJjf_UbfPVNrt=oNKSrqj=t9HPBHg@mail.gmail.com>
In-Reply-To: <CACna6rzdE1GubDquszC3jqJjf_UbfPVNrt=oNKSrqj=t9HPBHg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/26/2015 05:40 PM, Rafał Miłecki wrote:
> On 20 July 2015 at 19:14, Arend van Spriel <arend@broadcom.com> wrote:
>> On 07/19/2015 05:05 PM, Rafał Miłecki wrote:
>>>
>>> On 10 July 2015 at 20:31, Arend van Spriel <arend@broadcom.com> wrote:
>>>>
>>>> This series comprises of following changes:
>>>> - support NVRAM loading for bcm47xx platform.
>>>> - revise announced interface combinations and validate against it.
>>>> - new debugfs entry for msgbuf protocol layer used with PCIe devices.
>>>> - couple of PCIe fixes.
>>>> - rework dealing with interface instances.
>>>
>>>
>>> I'm not sure which patch has caused this (I applied all of them except
>>> for the 1st one) but now brcmfmac fails totally:
>>>>
>>>> Unable to handle kernel NULL pointer dereference at virtual address
>>>> 00000014
>>>
>>>
>>> I'm afraid I won't be able to spend any more time of this soon, so can
>>> you try to reproduce this problem, please?

You did a warm reboot of the device, right? There seems to be an issue 
because on OpenWrt the brcmfmac is not unloaded upon warm reboot, which 
makes the device unaccessible. Because on OpenWrt the firmware request 
is synchronous (OpenWrt patch on top of upstream brcmfmac) it results in 
probe failing on invalid access making the issue OpenWrt specific. Hante 
created a fix for the warm reboot issue.

Regards,
Arend

>> So what is your scenario for this issue. Multiple AP interfaces?
>
> Sorry for missing this question. Yes. This is my standard OpenWrt testing:
>
> uci set wireless.radio0.disabled=0
> uci set wireless.@wifi-iface[-1].ssid="OpenWrtA"
> uci set wireless.@wifi-iface[-1].encryption="psk2"
> uci set wireless.@wifi-iface[-1].key="password123"
> uci add wireless wifi-iface
> uci set wireless.@wifi-iface[-1].device="radio0"
> uci set wireless.@wifi-iface[-1].network="lan"
> uci set wireless.@wifi-iface[-1].mode="ap"
> uci set wireless.@wifi-iface[-1].ssid="OpenWrtB"
> uci set wireless.@wifi-iface[-1].encryption="psk2"
> uci set wireless.@wifi-iface[-1].key="password123"
> uci add wireless wifi-iface
> uci set wireless.@wifi-iface[-1].device="radio0"
> uci set wireless.@wifi-iface[-1].network="lan"
> uci set wireless.@wifi-iface[-1].mode="ap"
> uci set wireless.@wifi-iface[-1].ssid="OpenWrtC"
> uci set wireless.@wifi-iface[-1].encryption="psk2"
> uci set wireless.@wifi-iface[-1].key="password123"
> uci commit wireless
> /etc/init.d/network reload
>

