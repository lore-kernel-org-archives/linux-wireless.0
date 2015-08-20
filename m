Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:36190 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbbHTV0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 17:26:12 -0400
Received: by iodv127 with SMTP id v127so61372398iod.3
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2015 14:26:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55D64555.2090207@broadcom.com>
References: <1440101168-2252-1-git-send-email-arend@broadcom.com>
	<CACna6rxtHaj-czX6z28UL8LL5VAyxVrEgimn5fVz8NpU5DOwgw@mail.gmail.com>
	<55D64555.2090207@broadcom.com>
Date: Thu, 20 Aug 2015 23:26:11 +0200
Message-ID: <CACna6rzE=3wG0dMtFUY-i188bSba=SPzw_tAS4iJsX6z96fTbQ@mail.gmail.com> (sfid-20150820_232615_412471_DD038F6D)
Subject: Re: [PATCH V3 0/6] brcmfmac: nvram loading and code rework
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 August 2015 at 23:23, Arend van Spriel <arend@broadcom.com> wrote:
> On 08/20/2015 11:20 PM, Rafał Miłecki wrote:
>>
>> On 20 August 2015 at 22:06, Arend van Spriel <arend@broadcom.com> wrote:
>>>
>>> This series comprises of following changes:
>>> - support NVRAM loading for bcm47xx platform.
>>> - revise announced interface combinations and validate against it.
>>> - new debugfs entry for msgbuf protocol layer used with PCIe devices.
>>> - PCIe fix for handling queue overflow.
>>> - support more firmware events (for bcm4339 firmware).
>>>
>>> The series is intended for v4.3 kernel and applies to the master branch
>>> of the wireless-drivers-next repository. Removed patch from this series
>>> that reportedly has issue on OpenWrt platform.
>>
>>
>> Tested-by: Rafał Miłecki <zajec5@gmail.com>
>>
>> No regression with this version, getting platform NVRAM works.
>
>
> Thanks, Rafał

Thanks for your work! :)


> Kalle,
>
> Will you add the "Tested-by:" or should I?

If you won't, I won't mind. I know patchwork still doesn't like my name ;)


One note: this patchset should be applied after:
[PATCH] brcmfmac: check all combinations when setting wiphy's addresses
Otherwise /sys/class/ieee80211/phy0/addresses may start reporting only
2 MACs (despite BCM43602 hardware & firmware supporting 4 AP
interfaces).

-- 
Rafał
