Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f42.google.com ([209.85.212.42]:48635 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab1IPH32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 03:29:28 -0400
Received: by vwl1 with SMTP id 1so6553422vwl.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 00:29:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <400C43189542CE41BC0A5B252FC90136BC0C9DEF26@SJEXCHCCR02.corp.ad.broadcom.com>
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
	<CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com>
	<CAC9WiBi5L7uV=OzYBKs=sdjRr4Xykcd2USQPtPhCsSBLdpW-6g@mail.gmail.com>
	<20110913132844.GB11772@tuxdriver.com>
	<CACna6ryHL1K-1E7aZz_-5XzQZST5bzM4Fh99HbcmQDXvjn4ooA@mail.gmail.com>
	<400C43189542CE41BC0A5B252FC90136BC0C9DEF26@SJEXCHCCR02.corp.ad.broadcom.com>
Date: Fri, 16 Sep 2011 09:29:27 +0200
Message-ID: <CACna6ryswqewxN3MCO20TWstTkipo2WU0aG=Er3UGGfK-RCW8w@mail.gmail.com> (sfid-20110916_092934_265859_C0B23AFB)
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend Van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Francis Moreau <francis.moro@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 14 września 2011 11:11 użytkownik Arend Van Spriel
<arend@broadcom.com> napisał:
> Francis has a 4313. As support for that device is not yet in b43 you could consider not claiming it for now in bcma.

There's a little conflict theory vs. practice. Driver bcma supports
14e4:4727 fine, the problem is that there is no additional driver
using bcma bus and having support for LCN-PHY.

So in theory there is not reason to drop 14e4:4727 from bcma.
In practice we could do that to avoid conflict between bcma and brcmsmac.

Support for LCN in b43 is WIP, we already have a lot of code, so the
whole problem will disappear soon anyway.

-- 
Rafał
