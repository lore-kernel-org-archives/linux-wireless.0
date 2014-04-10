Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46344 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965164AbaDJIXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 04:23:23 -0400
Message-ID: <1397118188.4757.10.camel@jlt4.sipsolutions.net> (sfid-20140410_102329_954208_575F1E7A)
Subject: Re: [PATCH 2/3] cfg80211: fix processing world regdomain when non
 modular
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Colleen T <colleen@cozybit.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sander Eikelenboom <linux@eikelenboom.it>
Date: Thu, 10 Apr 2014 10:23:08 +0200
In-Reply-To: <CA+XVXfdY65-7S-Hs1vAYSVx05wN98Q-5hmFTrhOduzKkVOdGCA@mail.gmail.com> (sfid-20140410_101742_972566_805ECE10)
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
	 <1393376982-28276-3-git-send-email-mcgrof@do-not-panic.com>
	 <1393852248.10039.5.camel@jlt4.sipsolutions.net>
	 <CANrMYP6Rvv4EBjY9-78bdm70G_3YGZFrJH9tFz5XVsbSSi-m=Q@mail.gmail.com>
	 <CAB=NE6X02Apk8XFt7yomQKwNoENvKAy1QbGBknQUGJ2ZDs73Gw@mail.gmail.com>
	 <CANrMYP4GhDZZzYkyyVCHKpb7YvJzNbFZn77hZH9T+y7HTQ4R=w@mail.gmail.com>
	 <CAB=NE6UHKptAvbt1OM4O_cRiCj2wyEKGF2fFPsO_rQ0EUZQahA@mail.gmail.com>
	 <CAFED-j=OAMJzFkjgCDx8YMHpEWfpZ6h4UQSRK7DQigrNuaOSig@mail.gmail.com>
	 <CAB=NE6UGWfZxU6zi=XzLKWeN+1aFgxTVUpr349FVHBsRgSGo+A@mail.gmail.com>
	 <CANrMYP7Meef9rt4aX_EeREq0z7uRtT6oSB6pjE3AqeHMx1GwJw@mail.gmail.com>
	 <CA+XVXffzFWsJOU+PLWkeoce1+dDvrqruyi3_GG7V-6dfWpK7gA@mail.gmail.com>
	 <1397071009.4964.18.camel@jlt4.sipsolutions.net>
	 <CA+XVXfdekoT_jhVL_vpjJSPPD5hAjyprUB+g4kAN2Nssv=9-Ng@mail.gmail.com>
	 <1397116902.4757.6.camel@jlt4.sipsolutions.net>
	 <CA+XVXfdY65-7S-Hs1vAYSVx05wN98Q-5hmFTrhOduzKkVOdGCA@mail.gmail.com>
	 (sfid-20140410_101742_972566_805ECE10)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-04-10 at 11:17 +0300, Arik Nemtsov wrote:

> >> It makes sense to me. Non-last requests are freed using kfree. The
> >> last request needs RCU.
> >
> > Yeah but there can only be one "last request", so why pass it?
> 
> oh. well that was weird before as well. :)
> let's wait to see if it solves the bug? I can respin it without the arg later.

Sure, makes sense.

johannes

