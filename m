Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E164C282C2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 14:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 172EE218CD
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 14:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbfAYOAk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 09:00:40 -0500
Received: from 5.mo68.mail-out.ovh.net ([46.105.62.179]:46001 "EHLO
        5.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfAYOAk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 09:00:40 -0500
X-Greylist: delayed 17347 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2019 09:00:38 EST
Received: from player796.ha.ovh.net (unknown [10.109.159.136])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id 3194210E647
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2019 10:11:29 +0100 (CET)
Received: from RCM-web2.webmail.mail.ovh.net (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player796.ha.ovh.net (Postfix) with ESMTPSA id 9B6681EC4BFC;
        Fri, 25 Jan 2019 09:11:22 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 25 Jan 2019 10:11:22 +0100
From:   =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [PATCH] brcmfmac: support monitor frames with hardware/ucode
 header
In-Reply-To: <66fcd804-73f7-ae58-53f5-537ec8cb2802@broadcom.com>
References: <20190122110858.12993-1-zajec5@gmail.com>
 <66fcd804-73f7-ae58-53f5-537ec8cb2802@broadcom.com>
Message-ID: <9db0a0b702d2f2c28381de17c5b15c68@milecki.pl>
X-Sender: rafal@milecki.pl
User-Agent: Roundcube Webmail/1.3.8
X-Originating-IP: 194.187.74.233
X-Webmail-UserID: rafal@milecki.pl
X-Ovh-Tracer-Id: 15186419419559464576
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrieegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-01-25 09:51, Arend Van Spriel wrote:
> On 1/22/2019 12:08 PM, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>> 
>> The new FullMAC firmwares for 4366b1/4366c0 were supposed to provide
>> monitor frames with radiotap header but it doesn't seem to be the 
>> case.
> 
> I was not aware that this was supposed to. I did not build a radiotap
> variant to keep it feature-wise similar to 4366b0 firmware.

Well, then apparently I got confused :( When you wrote:

On Mon, 11 Jun 2018 at 12:48, Arend van Spriel 
<arend.vanspriel@broadcom.com> wrote:
> Looking into our firmware repo it there are two flags, ie. WL_MONITOR
> and WL_RADIOTAP. It seems both are set for firmware containing -stamon-
> feature. Your list below confirms that. I still plan to add indication
> for WL_RADIOTAP in the "cap" iovar, but a stamon feature check could be
> used for older firmwares.

I assumed you'll add "rtap" cap value (to the internal wl code 
repository?)
because you mean to release a firmware using it.

Maybe you just meant it to be for your customers compiling firmwares on
their own?


>> Testing the latest release resulted in discovering a new format being
>> used. It seems (almost?) identical to the one known from ucode used in
>> SoftMAC devices which is most likely the same codebase anyway.
> 
> I am a bit confused. How many formats are there? It is either ucode
> format or radiotap, right?

So far we got two formats:
1) 802.11 frames (with frame (sub)type & all addresses)
2) 802.11 frames with the radiotap header
and now we also have:
3) 802.11 frames with the ucode header

For more info please check my original post:
Research + questions on brcmfmac and support for monitor mode
https://www.spinics.net/lists/linux-wireless/msg173573.html


>> While radiotap support was meant to be announced with the "rtap" fw
>> capability string it seems no alternative was added for the hw/ucode
>> format. It means each firmware requires a feature mapping quirk.
> 
> I thought we only needed a quirk for the firmware that provide
> radiotap but do not announce it. For the others we can assume ucode
> format if monitor mode is supported. Probably missing something.

802.11 frames with ucode header is something entirely new, I didn't see 
any
Asus/Linksys/Netgear/TP-LINK firmware using it.

As the old firmwares were providing frames without any header (also 
making
it impossible to e.g. read signal strength) we need this new flag to
distinguish firmwares with ucode header from them.
