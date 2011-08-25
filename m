Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49943 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1HYVLP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 17:11:15 -0400
Received: by gya6 with SMTP id 6so2115322gya.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 14:11:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
References: <20110707002034.GA17885@broadcom.com>
	<20110824222801.GA5280@broadcom.com>
	<CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
Date: Thu, 25 Aug 2011 23:11:14 +0200
Message-ID: <CACna6rzjO2yS0N0tbTrOwyLq5NXJAH-J8EJ4DCY+xyFeLWe-aw@mail.gmail.com> (sfid-20110825_231118_558583_951E5796)
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

W dniu 25 sierpnia 2011 22:55 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> 2011/8/25 Henry Ptasinski <henryp@broadcom.com>:
>> With the latest series of cleanup patches merged in by Greg KH, I'd like to
>> once again propose moving brcm80211 out of staging and into mainline.
>
> Henry: a simple question, please explain it to me, what brcmsmac does
> provide that b43 doesn't?
>
> brcmsmac doesn't support SSB and duplicates BCMA support (doesn't make
> use of bcma module)
> brmcsmac doesn't support older PHYs like G/LP
> brmcsmac doesn't support recent HT-PHY
> brmcsmac doesn't support AP or monitor mode
> all of that is supported by b43
>
> The one thing brcmsmac is better at, is support for 14e4:4727 card
> (BCM4313). I've already started work on support of this card in b43,
> hope to get it working soon.
>
>
> You mostly just duplicate support for cards that are already supported by b43.

I've another idea. What about adding support for 14e4:4727 (BCM4313)
into b43 (I'll handle that task) and dropping bcrmsmac?

We could focus on improving one driver instead of creating 2 drivers
for the same hardware.

-- 
Rafał
