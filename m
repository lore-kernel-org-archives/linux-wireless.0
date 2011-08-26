Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36447 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab1HZTho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 15:37:44 -0400
Received: by pzk37 with SMTP id 37so4747178pzk.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 12:37:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110826175510.GG4888@broadcom.com>
References: <20110707002034.GA17885@broadcom.com>
	<20110824222801.GA5280@broadcom.com>
	<CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
	<20110826175510.GG4888@broadcom.com>
Date: Fri, 26 Aug 2011 21:37:44 +0200
Message-ID: <CACna6ryaOdfsJjJDEkfrPrWrg_m-6jFZ1ae=VHzgACq-cs-sag@mail.gmail.com> (sfid-20110826_213748_209906_12597E37)
Subject: Re: [PATCH v2] Move brcm80211 to mainline
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 26 sierpnia 2011 19:55 użytkownik Henry Ptasinski
<henryp@broadcom.com> napisał:
> On Thu, Aug 25, 2011 at 01:55:26PM -0700, Rafał Miłecki wrote:
>> 2011/8/25 Henry Ptasinski <henryp@broadcom.com>:
>> > With the latest series of cleanup patches merged in by Greg KH, I'd like to
>> > once again propose moving brcm80211 out of staging and into mainline.
>>
>> Henry: a simple question, please explain it to me, what brcmsmac does
>> provide that b43 doesn't?
>
> The brcmsmac driver supports the BCM4313, BCM43224, and BCM43225 chipsets with
> full performance i.e. rate vs. range comparable to what's achived with these
> chips running under other operating systems.
>
> The underlying phy algorithms, especially the dynamic calibrations, have been
> designed and tested, over the full range of chip operating temperatures, and
> across fabrication process corners, to maximize the performance acheived in all
> cases.

Are you aware, that b43's code comes from RE efforts and PHY part is
mostly identical to brcmsmac/wl's one?

We have the same functions, conditions, operations here. Sometimes
called in a different way, sometimes we have different code
structures, but generally code is the same.

So I still don't see the advantages of using brcmsmac instead of b43.


> The driver is fully supported by Broadcom, and provides an API for addition of
> phy support for newer chipsets that will help speed up the process of getting
> support for those chipsets into the kernel.

I'm glad you're so proud of yours flexible API, but b43 has the same
implemented since 2008. You can see we've just easily added support
for HT-PHY using our API and I'm working on LCN-PHY right now (without
modifying the API).

We would like to have b43 supported by Broadcom. It sounds much
better, I've shown you a lot of advantages of such a choice. Switching
to brcmsmac on the other hand needs a lot of work and improvements.

-- 
Rafał
