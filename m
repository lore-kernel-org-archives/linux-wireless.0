Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:62832 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965580AbaKNTa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 14:30:27 -0500
Message-ID: <54665850.9070007@broadcom.com> (sfid-20141114_203031_089665_76B94698)
Date: Fri, 14 Nov 2014 20:30:24 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>
Subject: Re: brcmfmac not working on ECS LIVA
References: <CAMP44s2XAmaiK2=BJA3TCW48Uo=5qyT5WsASDsZnOiSNgK6b0A@mail.gmail.com>	<545F4611.3010207@broadcom.com>	<CAMP44s2V59VDx0s7q5Yr=KvGZNn8ptRJGHS4W8Ja=+ciKZaSzg@mail.gmail.com>	<54633939.6000400@broadcom.com>	<CAMP44s1DOA31ob24=qzz83MnVFmm60EpgaPYvLbwUv-AP5FRbw@mail.gmail.com>	<54648C50.6000702@broadcom.com> <CAMP44s0j+i3zADu=Y3fUWqNEgDFeESs2_aFYmxQt9kZRcXkCjA@mail.gmail.com>
In-Reply-To: <CAMP44s0j+i3zADu=Y3fUWqNEgDFeESs2_aFYmxQt9kZRcXkCjA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/14/14 18:03, Felipe Contreras wrote:
> On Thu, Nov 13, 2014 at 4:47 AM, Arend van Spriel<arend@broadcom.com>  wrote:
>> On 12-11-14 16:23, Felipe Contreras wrote:
>>> On Wed, Nov 12, 2014 at 4:40 AM, Arend van Spriel<arend@broadcom.com>  wrote:
>
>>> I tried this patch, and although it seems to make a difference, it
>>> still doesn't work.
>>>
>>> http://people.freedesktop.org/~felipec/dmesg-brcm-2.txt
>>
>> Hi Felipe,
>>
>> All the messages to the firmware seem ok. If connection would succeed I
>> normally see a LINK event followed by SET_SSID event. In your log I only
>> see the SET_SSID event with failed status, hence the connect is
>> unsuccessful. Do you have any control over the AP? Could you try without
>> WPA security to quickly confirm connection works? May help in root
>> causing the issue.
>
> I tried disabled WPA security, it's still not working.

Thanks, Felipe

Could you check the runtime-pm for mmc1 controller. You need to find 
sdhci-acpi driver in sysfs. I think it is under 
/sys/bus/platform/drivers. One of the bound devices is mmc1 (although 
probably will have different nameing there) and there is subfolder power 
with file named control. Can you cat that file and do 'echo on > 
control' if it says auto.

Regards,
Arend

