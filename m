Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:56691 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765912AbXGTO5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 10:57:11 -0400
Message-ID: <46A0CB16.6010901@warmcat.com>
Date: Fri, 20 Jul 2007 15:47:50 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Larry Finger <larry.finger@lwfinger.net>
CC: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 2/2] bcm43xx-mac80211: Fix reported rx frequency and channel
References: <20070611103828.961999956@warmcat.com> <20070611103914.577674038@warmcat.com> <20070719191052.GC6603@tuxdriver.com> <200707192139.14930.mb@bu3sch.de> <46A050B4.3060500@warmcat.com> <46A0C851.2040302@lwfinger.net>
In-Reply-To: <46A0C851.2040302@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> Andy Green wrote:
>>
>> I never heard of a special blessed firmware before, I don't think that
>> the driver made any dmesg when given the non-blessed one, if that is
>> what it is?  I was given this firmware by the traditional "person on
>> IRC" and don't know where it came from, but I still have it here if any
>> versioning can be extracted from it.
> 
> Just as API's and ABI's change, the writers of firmware can change their
> layout, which is what happened here. Nothing "blessed", just one
> behavior before, and a second after, the change. The version info can be
> gotten from fwcutter.

Understood, that is why I consider it a bad thing that functionality
that can be done in the mac80211 driver is pushed into the binary-only
firmware when there is a choice (otherwise known as "paranoia", apparently).

However you stripped some quoting from Michael:

''But it is actually no problem in reality, as the use-it-or-die
firmware doesn't have this problem. So if someone uses another
firmware than the one we suggest, he will probably run into more
problems, as well.
The fix is called: Use the correct firmware.
For now, at least.''

I would summarize this that Michael is telling me one pariticular
version of firmware - "use it or die firmware" - is especially
blessed/correct.  It might be an idea to let people know they have
strayed from the dependency of the required firmware version in dmesg if
indeed there is an effective dependency of the driver on it.

Can I still get the firmware version from fwcutter if I don't have the
original Windows binary the firmware came from?

-Andy
