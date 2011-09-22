Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38610 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab1IVGrK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 02:47:10 -0400
Message-ID: <4E7AD9E6.1010700@hauke-m.de> (sfid-20110922_084714_407795_CE4D2661)
Date: Thu, 22 Sep 2011 08:47:02 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Brett Rudley <brudley@broadcom.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Greg KH <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline patch
 #2
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com> <20110920130338.GA9885@kroah.com> <20110920132203.GB7800@tuxdriver.com> <20110920140020.GA11386@kroah.com> <7A94256FD72B884D9E7C55586C3CBCEE195814DD85@SJEXCHCCR01.corp.ad.broadcom.com> <CACna6rzSiH3g9y6F6t8JT4abCy0pO9v+ATCBeYmNdmNdo5BaDQ@mail.gmail.com> <7A94256FD72B884D9E7C55586C3CBCEE195814DE4F@SJEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <7A94256FD72B884D9E7C55586C3CBCEE195814DE4F@SJEXCHCCR01.corp.ad.broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/22/2011 12:12 AM, Brett Rudley wrote:
>>> Our original plan was to remain a separate driver from b43. We were
>> aware of it and all the good work that had been done to create it and we
>> had no intention of interfering with it.  At that point there had not
>> been very much recent movement in b43 and it did not support any of our
>> AXI based chips.  We figured that ssb vs AXI was a good dividing line and
>> there would be no conflict, and there wasn't initially.
>>
>> The first obvious problem is that there are SSB and BCMA (aka AXI)
>> cards using N-PHY. That resulted in PHY code duplication between b43
>> and brcmsmac. And since we already supported N-PHY in b43, adding bcma
>> support automatically gave us BCM43224 and BCM43225 support. That of
>> course means duplicated supported for the same hardware.
> 
> Agree, when you created bcma, it did duplicate HW support already in brcmsmac.  Why didn't you address that then?

bcma is not only used to support the bus on a pci based wireless cards
it now also contains support for SoCs like the BCM4718. There it
provides a common interface to the hardware for the wireless so that
there were no changes in b43 needed to get the wireless core running on
this SoC. It also provides some parts needed to get the SoC boot in
Linux and so on, some parts are related to the MIPS CPU and not related
to the wireless core, so it makes sense to put that into an own module.

Hauke
