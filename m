Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:38390 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab2ITGFa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 02:05:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAOjsGA2uvCxnX1PH85w2vO894kZT+af-Tgj7bV-3kw3ScxN10g@mail.gmail.com>
References: <1348053493-22955-1-git-send-email-jarl@softace.dk>
	<1348053493-22955-2-git-send-email-jarl@softace.dk>
	<CAOjsGA2uvCxnX1PH85w2vO894kZT+af-Tgj7bV-3kw3ScxN10g@mail.gmail.com>
Date: Thu, 20 Sep 2012 08:05:28 +0200
Message-ID: <CACna6ryRXB6GjymaP-RM8HTEeWRHnE8B=5tdH3J4JGyeHBEE6Q@mail.gmail.com> (sfid-20120920_080537_187889_20B7D99A)
Subject: Re: [PATCH 2/2] Using LP firmware for taking advantage of the
 low-power capabilities.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Jarl Friis <jarl@softace.dk>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	=?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	netdev@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/9/19 Jarl Friis <jarl@softace.dk>:
> 2012/9/19 Jarl Friis <jarl@softace.dk>:
>> This is using the LP specific firmware to better take advantage of the
>> Low-Power capabilities.
>
> Gosh... I just realized that the code I introduced is completely
> untested. My hardware does not reach these pieces of code...
>
> Sorry...
>
> However the code seems natural (due to the firmware file name pattern)
> for a PHY-LP hardware, that is a bcm4313 chip (pciid 14e4:4315).

Well, your BCM4322 is not LP-PHY card... does it really work better
after that change, and wakes up faster? ;)

BCM4313 is LCN-PHY, so your change won't affect it, not to mention it
is not supported by b43.

14e4:4315 is really BCM4312 (LP-PHY) and maybe could be affected by
this patch... but just in case of core 16. AFAIK our 14e4:4315 are
usually devices with core rev 15.

-- 
Rafał
