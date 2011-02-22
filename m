Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42814 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1BVE6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 23:58:30 -0500
Received: by fxm17 with SMTP id 17so2350421fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Feb 2011 20:58:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <op.vqfj0pud3ri7v4@arend-laptop>
References: <AANLkTinq6_GVzD3hF4krxdBTn2gwgiu_8EuaOFCuEaq4@mail.gmail.com> <op.vqfj0pud3ri7v4@arend-laptop>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Tue, 22 Feb 2011 13:57:57 +0900
Message-ID: <AANLkTikW7kDBE_yczthCKiUSafvp8jBWFUn5OpLneQuU@mail.gmail.com>
Subject: Re: Suspend/Resume Doesnot work with brcmfmac driver
To: Arend van Spriel <arend@broadcom.com>, henryp@broadcom.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend Van Spriel/Henry

I am facing a problem with the wifi connectivity using BRCM4329 chipset.
The problem is, while browsing some time i lost the connect with the
AP, dmesg shows the below msges:

ERROR @wl_cfg80211_config_default_key : error (-22)
cfg80211: Calling CRDA to update world regulatory domain

I traced the code and find that this is happening when i hit the condition

if (wsec & WEP_ENABLED) {

and basically ioctl WLC_SET_KEY_PRIMARY is failed.

can you please give your though why this is happening(connection lost to AP)?
Is there is some problem with my AP setting?
Is there is any problem with the RF setting (basically nvram parameters)?
Any help will be appreciated.

Regards,
Alim


On Sat, Feb 5, 2011 at 9:44 PM, Arend van Spriel <arend@broadcom.com> wrote:
>
> Hi Alim,
>
> On Sat, 05 Feb 2011 10:21:41 +0100, Alim Akhtar <alim.akhtar@gmail.com> wrote:
>
>> Dear Arend Van Spriel
>>
>> I am using BCM4329 chip and downloaded the driver for google chromium git repo (2.6.36 kernel version).
>> I am facing a problem, suspend/resume does not works with this driver.
>> I have seem your commit in the staging tree on 22th Jan "staging: brcm80211: fix suspend/resume in brcmsmac" but i cannt find the fix for brcmfmac. Can you please till suspend/resume for brcmfmac driver is already fixed or it is work in progress? Also if fixed, please till me patch location or send me the patch it self.
>
> The suspend/resume changes for brcmfmac is work in progress at the moment as I was told by colleagues working on that driver. I assume the patch will be included in the chromium repo and also in the staging repo (git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6.git - staging-next branch).
>
> For the staging repo you can keep an eye on the mailing list: http://driverdev.linuxdriverproject.org/pipermail/devel/
>
>> Any help will be appreciated.
>>
>> Regards,
>> Alim
>>
>>
>> --
>>
>
> Gr. AvS
> --
> "The most merciful thing in the world, I think, is the inability of the human
> mind to correlate all its contents." - "The Call of Cthulhu"
>



--
aLim akHtaR
mAin hUn nA :-)
