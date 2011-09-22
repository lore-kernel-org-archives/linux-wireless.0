Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45514 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab1IVJIM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 05:08:12 -0400
Received: by mail-ww0-f44.google.com with SMTP id 22so1889283wwf.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 02:08:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <400C43189542CE41BC0A5B252FC90136BC0CC8ABD8@SJEXCHCCR02.corp.ad.broadcom.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
	<20110920130338.GA9885@kroah.com>
	<20110920132203.GB7800@tuxdriver.com>
	<20110920140020.GA11386@kroah.com>
	<7A94256FD72B884D9E7C55586C3CBCEE195814DD85@SJEXCHCCR01.corp.ad.broadcom.com>
	<CACna6rzSiH3g9y6F6t8JT4abCy0pO9v+ATCBeYmNdmNdo5BaDQ@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE195814DE4F@SJEXCHCCR01.corp.ad.broadcom.com>
	<4E7AD9E6.1010700@hauke-m.de>
	<400C43189542CE41BC0A5B252FC90136BC0CC8ABD8@SJEXCHCCR02.corp.ad.broadcom.com>
Date: Thu, 22 Sep 2011 11:08:11 +0200
Message-ID: <CACna6rwCWhbWm28cLFxPkLmDZO0sOHuLTSb=-rLwhW2ZV4AZ0w@mail.gmail.com> (sfid-20110922_110819_727713_51D537A0)
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline patch #2
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend Van Spriel <arend@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Brett Rudley <brudley@broadcom.com>, Greg KH <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/22 Arend Van Spriel <arend@broadcom.com>:
>> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>> owner@vger.kernel.org] On Behalf Of Hauke Mehrtens
>> Sent: donderdag 22 september 2011 8:47
>> To: Brett Rudley
>> Cc: Rafał Miłecki; Greg KH; John W. Linville; Franky (Zhenhui) Lin;
>> gregkh@suse.de; devel@linuxdriverproject.org; linux-
>> wireless@vger.kernel.org
>> Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for
>> mainline patch #2
>>
>> On 09/22/2011 12:12 AM, Brett Rudley wrote:
>> >>> Our original plan was to remain a separate driver from b43. We were
>> >> aware of it and all the good work that had been done to create it
>> and we
>> >> had no intention of interfering with it.  At that point there had
>> not
>> >> been very much recent movement in b43 and it did not support any of
>> our
>> >> AXI based chips.  We figured that ssb vs AXI was a good dividing
>> line and
>> >> there would be no conflict, and there wasn't initially.
>> >>
>> >> The first obvious problem is that there are SSB and BCMA (aka AXI)
>> >> cards using N-PHY. That resulted in PHY code duplication between b43
>> >> and brcmsmac. And since we already supported N-PHY in b43, adding
>> bcma
>> >> support automatically gave us BCM43224 and BCM43225 support. That of
>> >> course means duplicated supported for the same hardware.
>> >
>> > Agree, when you created bcma, it did duplicate HW support already in
>> brcmsmac.  Why didn't you address that then?
>>
>> bcma is not only used to support the bus on a pci based wireless cards
>> it now also contains support for SoCs like the BCM4718. There it
>> provides a common interface to the hardware for the wireless so that
>> there were no changes in b43 needed to get the wireless core running on
>> this SoC. It also provides some parts needed to get the SoC boot in
>> Linux and so on, some parts are related to the MIPS CPU and not related
>> to the wireless core, so it makes sense to put that into an own module.
>>
>> Hauke
>
> You are right. BCMA in itself only duplicates part of what is in brcmsmac
> and its existence provides good functional separation. That is why we fully
> intend to have brcmsmac use bcma. Brett meant that the duplication started
> when b43 was getting patches for bcma support.
>
> Rafał indicated that b43 team was working on n-phy support when we released
> the brcm80211 driver (aka brcmsmac). No one indicated this before so I can
> only assume that b43 decided to move on building bcma and have no interest
> in brcmsmac moving in the linux tree.

It's not really about seeing interest in that. I just don't see
advantages for us from this.

If we assume we will have the same level support in both drivers soon,
then what are the differences? brcmsmac seems to be preferred only
because Broadcom guys like it.

-- 
Rafał
