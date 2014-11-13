Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:30350 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbaKMKrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 05:47:47 -0500
Message-ID: <54648C50.6000702@broadcom.com> (sfid-20141113_114753_165499_00CFC31D)
Date: Thu, 13 Nov 2014 11:47:44 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>
Subject: Re: brcmfmac not working on ECS LIVA
References: <CAMP44s2XAmaiK2=BJA3TCW48Uo=5qyT5WsASDsZnOiSNgK6b0A@mail.gmail.com>	<545F4611.3010207@broadcom.com>	<CAMP44s2V59VDx0s7q5Yr=KvGZNn8ptRJGHS4W8Ja=+ciKZaSzg@mail.gmail.com>	<54633939.6000400@broadcom.com> <CAMP44s1DOA31ob24=qzz83MnVFmm60EpgaPYvLbwUv-AP5FRbw@mail.gmail.com>
In-Reply-To: <CAMP44s1DOA31ob24=qzz83MnVFmm60EpgaPYvLbwUv-AP5FRbw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12-11-14 16:23, Felipe Contreras wrote:
> On Wed, Nov 12, 2014 at 4:40 AM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 11-11-14 23:32, Felipe Contreras wrote:
>>> On Sun, Nov 9, 2014 at 4:46 AM, Arend van Spriel <arend@broadcom.com> wrote:
>>>
>>>> Could you share the nvram obtained from EFI? Also please create a kernel log
>>>> with debug=0xd416.
>>>
>>> There you go:
>>> http://people.freedesktop.org/~felipec/dmesg-brcm.txt
>>>
>>
>> It is using the sdhci-acpi driver for the sdio host controller. If I am
>> not mistaken that one does runtime-pm. This has caused issues with our
>> device. This is what happens:
>>
>> 1. driver sends control message and waits for firmware response.
>>  2. runtime pm kicks in and suspends host controller.
>>   3. host controller suspend disable sdio clock.
>>    4. host controller does not detect firmware interrupt for response.
>>     5. control message times out.
>>
>> You can disable it through sysfs, but the patch below may do it.
> 
> I tried this patch, and although it seems to make a difference, it
> still doesn't work.
> 
> http://people.freedesktop.org/~felipec/dmesg-brcm-2.txt

Hi Felipe,

All the messages to the firmware seem ok. If connection would succeed I
normally see a LINK event followed by SET_SSID event. In your log I only
see the SET_SSID event with failed status, hence the connect is
unsuccessful. Do you have any control over the AP? Could you try without
WPA security to quickly confirm connection works? May help in root
causing the issue.

Regards,
Arend

