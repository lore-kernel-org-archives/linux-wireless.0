Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33076 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbbGZPk7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2015 11:40:59 -0400
Received: by igbpg9 with SMTP id pg9so65551648igb.0
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2015 08:40:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55AD2C8F.9010509@broadcom.com>
References: <1436553071-32423-1-git-send-email-arend@broadcom.com>
	<CACna6rwJwjiNKnfjV8cH9_fvE38SWLf5ng8ap15OktUZQhOedg@mail.gmail.com>
	<55AD2C8F.9010509@broadcom.com>
Date: Sun, 26 Jul 2015 17:40:58 +0200
Message-ID: <CACna6rzdE1GubDquszC3jqJjf_UbfPVNrt=oNKSrqj=t9HPBHg@mail.gmail.com> (sfid-20150726_174133_385317_9A0310AE)
Subject: Re: [PATCH 0/7] brcmfmac: nvram loading and code rework
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 July 2015 at 19:14, Arend van Spriel <arend@broadcom.com> wrote:
> On 07/19/2015 05:05 PM, Rafał Miłecki wrote:
>>
>> On 10 July 2015 at 20:31, Arend van Spriel <arend@broadcom.com> wrote:
>>>
>>> This series comprises of following changes:
>>> - support NVRAM loading for bcm47xx platform.
>>> - revise announced interface combinations and validate against it.
>>> - new debugfs entry for msgbuf protocol layer used with PCIe devices.
>>> - couple of PCIe fixes.
>>> - rework dealing with interface instances.
>>
>>
>> I'm not sure which patch has caused this (I applied all of them except
>> for the 1st one) but now brcmfmac fails totally:
>>>
>>> Unable to handle kernel NULL pointer dereference at virtual address
>>> 00000014
>>
>>
>> I'm afraid I won't be able to spend any more time of this soon, so can
>> you try to reproduce this problem, please?
>
>
> So what is your scenario for this issue. Multiple AP interfaces?

Sorry for missing this question. Yes. This is my standard OpenWrt testing:

uci set wireless.radio0.disabled=0
uci set wireless.@wifi-iface[-1].ssid="OpenWrtA"
uci set wireless.@wifi-iface[-1].encryption="psk2"
uci set wireless.@wifi-iface[-1].key="password123"
uci add wireless wifi-iface
uci set wireless.@wifi-iface[-1].device="radio0"
uci set wireless.@wifi-iface[-1].network="lan"
uci set wireless.@wifi-iface[-1].mode="ap"
uci set wireless.@wifi-iface[-1].ssid="OpenWrtB"
uci set wireless.@wifi-iface[-1].encryption="psk2"
uci set wireless.@wifi-iface[-1].key="password123"
uci add wireless wifi-iface
uci set wireless.@wifi-iface[-1].device="radio0"
uci set wireless.@wifi-iface[-1].network="lan"
uci set wireless.@wifi-iface[-1].mode="ap"
uci set wireless.@wifi-iface[-1].ssid="OpenWrtC"
uci set wireless.@wifi-iface[-1].encryption="psk2"
uci set wireless.@wifi-iface[-1].key="password123"
uci commit wireless
/etc/init.d/network reload

-- 
Rafał
