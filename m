Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47410 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab1H0O7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 10:59:37 -0400
Received: by pzk37 with SMTP id 37so5862639pzk.1
        for <linux-wireless@vger.kernel.org>; Sat, 27 Aug 2011 07:59:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110827143513.GN3775@shale.localdomain>
References: <20110707002034.GA17885@broadcom.com>
	<20110824222801.GA5280@broadcom.com>
	<CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
	<20110827143513.GN3775@shale.localdomain>
Date: Sat, 27 Aug 2011 16:59:36 +0200
Message-ID: <CACna6rwW-aDndJmcsouujAeOeEcmn7GgWR2m=HWs11bg40cOfQ@mail.gmail.com> (sfid-20110827_170049_540471_6F71C506)
Subject: Re: [PATCH v2] Move brcm80211 to mainline
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 27 sierpnia 2011 16:35 użytkownik Dan Carpenter
<error27@gmail.com> napisał:
> On Thu, Aug 25, 2011 at 10:55:26PM +0200, Rafał Miłecki wrote:
>> 2011/8/25 Henry Ptasinski <henryp@broadcom.com>:
>> > With the latest series of cleanup patches merged in by Greg KH, I'd like to
>> > once again propose moving brcm80211 out of staging and into mainline.
>>
>> Henry: a simple question, please explain it to me, what brcmsmac does
>> provide that b43 doesn't?
>>
>
> Wow.  Why are we only having this discussion now?  Somewhere along
> the line, there has been a massive communications failure.  What
> happened here?  Henry, did you know about the b43 driver?  Can
> someone explain what's going on?

[Don't care to read that if you know b43&brcm80211 history]

You've to understand the architecture of Broadcom's cards first. It
less or more (less) like that:
Card -> Bus -> Chipset -> PHY & radio

The biggest part of the code is to support PHY and radio. There are of
course different types of both. It does not matter if PHY is located
on SSB bus or BCMA bus, you program it almost the same way.

brcm80211 (brcmsmac) supports PHY type "N", but it has support for
BCMA bus only.
When brcm80211 appeared, b43 supported PHY type "N", but it was
limited to SSB bus only.

I've added support for BCMA to b43 and this automatically enabled
support for new cards that were based on PHY type "N". Recently I've
added support for PHY type "HT" and now I'm working on LCN.

The code duplication between b43 and brcmsmac was acceptable when b43
didn't support BCMA. brcm80211 was really needed then because we
needed support for cards using BCMA. Now when b43 supports bcma it
sounds less interesting. brcm80211 duplicates a lot of general code,
PHY type N support code, but at the same time it doesn't support all
the N-PHY devices (there ssb based).

-- 
Rafał
