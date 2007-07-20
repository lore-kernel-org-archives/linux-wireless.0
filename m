Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:50081 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762378AbXGTQ6k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 12:58:40 -0400
Message-ID: <46A0E9B0.1050600@lwfinger.net>
Date: Fri, 20 Jul 2007 11:58:24 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Andy Green <andy@warmcat.com>
CC: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 2/2] bcm43xx-mac80211: Fix reported rx frequency and channel
References: <20070611103828.961999956@warmcat.com> <20070611103914.577674038@warmcat.com> <20070719191052.GC6603@tuxdriver.com> <200707192139.14930.mb@bu3sch.de> <46A050B4.3060500@warmcat.com> <46A0C851.2040302@lwfinger.net> <46A0CB16.6010901@warmcat.com>
In-Reply-To: <46A0CB16.6010901@warmcat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Green wrote:
> 
> Understood, that is why I consider it a bad thing that functionality
> that can be done in the mac80211 driver is pushed into the binary-only
> firmware when there is a choice (otherwise known as "paranoia", apparently).

Unfortunately, that is a necessary result of this type of reverse-engineering. If Broadcom put some 
function in the firmware, we have to leave it there as we have no idea what would break.

> However you stripped some quoting from Michael:
> 
> ''But it is actually no problem in reality, as the use-it-or-die
> firmware doesn't have this problem. So if someone uses another
> firmware than the one we suggest, he will probably run into more
> problems, as well.
> The fix is called: Use the correct firmware.
> For now, at least.''
> 
> I would summarize this that Michael is telling me one pariticular
> version of firmware - "use it or die firmware" - is especially
> blessed/correct.  It might be an idea to let people know they have
> strayed from the dependency of the required firmware version in dmesg if
> indeed there is an effective dependency of the driver on it.

It isn't that it is blessed or correct, but that it has been tested. Your version has not. Who knows 
what else might have changed? Once we know the version with the different behavior, a warning 
message can be prepared. I don't think anyone knew about this problem until you submitted your patch.

> Can I still get the firmware version from fwcutter if I don't have the
> original Windows binary the firmware came from?

AFAIK, fwcutter can only get the version from the foreign driver. It can be gotten from the dmesg 
output of your inlaws computer, or if you have the extracted firmware files here, you can bundle 
them up and email them to me privately.


Larry
