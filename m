Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44189 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab1H0QrE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 12:47:04 -0400
Message-ID: <4E591F1F.9070102@hauke-m.de> (sfid-20110827_184713_347406_5B1830C7)
Date: Sat, 27 Aug 2011 18:45:19 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Greg KH <gregkh@suse.de>, Dan Carpenter <error27@gmail.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
References: <20110707002034.GA17885@broadcom.com>	<20110824222801.GA5280@broadcom.com>	<CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>	<20110827143513.GN3775@shale.localdomain>	<20110827145003.GA9405@suse.de>	<CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com> <CACna6ryjaSb1aTtBAq7cXvvQeBtqbFgoV-0AjG2gvhNhBCVcUA@mail.gmail.com>
In-Reply-To: <CACna6ryjaSb1aTtBAq7cXvvQeBtqbFgoV-0AjG2gvhNhBCVcUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/27/2011 05:12 PM, Rafał Miłecki wrote:
> W dniu 27 sierpnia 2011 17:08 użytkownik Rafał Miłecki
> <zajec5@gmail.com> napisał:
>> 2011/8/27 Greg KH <gregkh@suse.de>:
>>> On Sat, Aug 27, 2011 at 05:35:13PM +0300, Dan Carpenter wrote:
>>>> On Thu, Aug 25, 2011 at 10:55:26PM +0200, Rafał Miłecki wrote:
>>>>> 2011/8/25 Henry Ptasinski <henryp@broadcom.com>:
>>>>>> With the latest series of cleanup patches merged in by Greg KH, I'd like to
>>>>>> once again propose moving brcm80211 out of staging and into mainline.
>>>>>
>>>>> Henry: a simple question, please explain it to me, what brcmsmac does
>>>>> provide that b43 doesn't?
>>>>>
>>>>
>>>> Wow.  Why are we only having this discussion now?  Somewhere along
>>>> the line, there has been a massive communications failure.  What
>>>> happened here?  Henry, did you know about the b43 driver?  Can
>>>> someone explain what's going on?
>>>
>>> I always thought that b43 and the staging driver supported different
>>> devices and had no overlap, which is why I had no problem with it.
>>>
>>> Was I totally mistaken and got this wrong?
>>
>> Please see my last e-mail in this thread for history overview.
>>
>> Right now the only card that is supported by brcmsmac and is not
>> supported by b43 is 14e4:4727. That card is based on PHY type LCN, and
>> I'm working on adding support for it in b43.
>>
>> Other cards supported by brcmsmac (14e4:4353, 14e4:4357) are supported
>> by b43.
> 
> b43 also works on SoCs (routers) using BCMA and having BCMA core based
> on N-PHY. This support was added by Hauke and I think he reported AP
> mode was somehow working for him. AFAIR it wasn't stable yet, but some
> packets were transferred :)
>
Yes AP mode is working with the code in wireless-testing, expect that
the architecture code (mips) does not provide the sprom stored in the
flash to bcma yet. I just set a random mac address for the device and
wireless worked. I have not tested it much, just connected with a client
and got the same speed with iperf as b43 running in client mode. As no
additional changes where needed for AP mode I think b43 should already
support the same functionality when using N-PHY devices as with G-PHY
devices.

Hauke

