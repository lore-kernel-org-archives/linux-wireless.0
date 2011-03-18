Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:45681 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab1CRNEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 09:04:42 -0400
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000028819.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 15:03:39 +0200
Subject: Re: [RFC][PATCH] ssb: separate common scanning functions
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
In-Reply-To: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
References: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 18 Mar 2011 15:03:53 +0200
Message-Id: <1300453433.13499.18.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> To keep ssb clean and avoid bigger code duplications, my idea is to:
> 1) Rename ssb directory to bcmb (like Broadcom's bus)
> 2) Have two *separated* drivers in it: ssb and ai
> 3) Share common function between ssb and ai
> Example of such a common functions can be translating enum to *char and
> (re)mapping MMIO.
Current ssb code ideology isn't really good place to start with support
for ai backplanes. Its really great to see you willing to get ai
supported in mainline but I'm sure this should be done apart from the
ssb code and not even with one as the design decisions origin. Several
concepts the ssb is based on are not designed to support anything else
than ocp/sb and will require workarounds to suport ai. 
Thanks to Michael I had a time to think over the possibly code
abstraction for shared sb and ai support. And while I'm still sure the
patchwork for ai over ssb support is of good use as some intermediate
decision to support ai-based hardware in sertain distributions but now I
support Michael in that such (hopefully) a temporary buildups should not
be in mainline.

Have nice day,
George


