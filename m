Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:59326 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab1HMIao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 04:30:44 -0400
Received: by iye16 with SMTP id 16so3192365iye.1
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 01:30:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E462C07.3050004@broadcom.com>
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
	<CACna6rztueomzzas=hQjfj6htD=SHFhrtFPSqbviqVDwaihJ9w@mail.gmail.com>
	<4E4555AD.7040809@broadcom.com>
	<CACna6rx_d4btykdK7AMwFxeFMs_MxjHEHvR6coxaZkfqkQVafA@mail.gmail.com>
	<4E462C07.3050004@broadcom.com>
Date: Sat, 13 Aug 2011 10:30:43 +0200
Message-ID: <CACna6rwFh9WLW9zWs8i6HxSXRkceJ1=Y6Maeek+D0t4iYfwg0g@mail.gmail.com> (sfid-20110813_103048_287512_4F43A126)
Subject: Re: [PATCH 00/14] staging: brcm80211: brcmfmac driver cleanup
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 13 sierpnia 2011 09:47 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
> On 08/12/2011 10:04 PM, Rafał Miłecki wrote:
>>
>> W dniu 12 sierpnia 2011 18:32 użytkownik Arend van Spriel
>> <arend@broadcom.com>  napisał:
>>>
>>> On 08/12/2011 04:02 PM, Rafał Miłecki wrote:
>>>>
>>>> 2011/8/12 Arend van Spriel<arend@broadcom.com>:
>>>>>
>>>>> Several cleanup patches to reduce code for the brcmfmac driver and
>>>>> get rid of a remaining checkpatch warning. The driver sources should
>>>>> be clear from checkpatch issue now.
>>>>>
>>>>> This series applies to staging-next and depends on the following patch
>>>>> set:
>>>>
>>>> Are you testing patches on some hardware? Or just compile-testing?
>>>>
>>>> I believe this driver is meant to support BCM4329, which is not PCI(e)
>>>> board. What adapter do you use?
>>>>
>>>> I've heard about Arasan adapter. Have you tried it? Is that something
>>>> reachable from arasan.com?
>>>
>>> Our brcm80211 source tree under drivers/staging contain two drivers. The
>>> brcmsmac driver currently supporting the PCI(e) cards with bcm43224,
>>> bcm43225, and bcm4313 chips and the brcmfmac driver currently supporting
>>> the
>>> SDIO card with bcm4329 chip. brcmsmac is a mac80211 driver and brcmfmac
>>> is a
>>> cfg80211 driver.
>>>
>>> We indeed use the Arasan adapter and both drivers are running in nightly
>>> test cycle testing our common internal repository. So the drivers are
>>> functionally tested on the x86 platforms (32 and 64 bit). Also looking at
>>> sparc64 and powerpc64 but not in a nightly cycle.
>>
>> Is there a chance you can donate me with such a adapter and card?
>
> Hi Rafał,
>
> If your interest is getting SDIO supported in bcma this card is not very
> useful to you. The bcm4329 is using the SSB interconnect.

That surprised me, interesting. I've never dig into brcmfmac code.

This still should be possible to adopt brcmfmac to use ssb, right? A
first random ssb-related function: dhdsdio_chip_resetcore. It
duplicates ssb code.

I'm still willing to help in brcmfmac development.

-- 
Rafał
