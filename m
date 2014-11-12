Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34108 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaKLPXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 10:23:43 -0500
Received: by mail-oi0-f48.google.com with SMTP id x69so8652296oia.7
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2014 07:23:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54633939.6000400@broadcom.com>
References: <CAMP44s2XAmaiK2=BJA3TCW48Uo=5qyT5WsASDsZnOiSNgK6b0A@mail.gmail.com>
	<545F4611.3010207@broadcom.com>
	<CAMP44s2V59VDx0s7q5Yr=KvGZNn8ptRJGHS4W8Ja=+ciKZaSzg@mail.gmail.com>
	<54633939.6000400@broadcom.com>
Date: Wed, 12 Nov 2014 09:23:42 -0600
Message-ID: <CAMP44s1DOA31ob24=qzz83MnVFmm60EpgaPYvLbwUv-AP5FRbw@mail.gmail.com> (sfid-20141112_162346_690746_7FF8F167)
Subject: Re: brcmfmac not working on ECS LIVA
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 12, 2014 at 4:40 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 11-11-14 23:32, Felipe Contreras wrote:
>> On Sun, Nov 9, 2014 at 4:46 AM, Arend van Spriel <arend@broadcom.com> wrote:
>>
>>> Could you share the nvram obtained from EFI? Also please create a kernel log
>>> with debug=0xd416.
>>
>> There you go:
>> http://people.freedesktop.org/~felipec/dmesg-brcm.txt
>>
>
> It is using the sdhci-acpi driver for the sdio host controller. If I am
> not mistaken that one does runtime-pm. This has caused issues with our
> device. This is what happens:
>
> 1. driver sends control message and waits for firmware response.
>  2. runtime pm kicks in and suspends host controller.
>   3. host controller suspend disable sdio clock.
>    4. host controller does not detect firmware interrupt for response.
>     5. control message times out.
>
> You can disable it through sysfs, but the patch below may do it.

I tried this patch, and although it seems to make a difference, it
still doesn't work.

http://people.freedesktop.org/~felipec/dmesg-brcm-2.txt

-- 
Felipe Contreras
