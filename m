Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43695 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbcFGHOE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 03:14:04 -0400
Message-ID: <1465283632.2304.16.camel@sipsolutions.net> (sfid-20160607_091408_316148_D8CEDC48)
Subject: Re: wext: making deprecation more visible
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Prasun Maiti <prasunmaiti87@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dibyajyoti Ghosh <dibyajyotig@gmail.com>,
	Ujjal Roy <royujjal@gmail.com>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Date: Tue, 07 Jun 2016 09:13:52 +0200
In-Reply-To: <87porxlfqb.fsf_-_@purkki.adurom.net>
References: <1464248432-12595-1-git-send-email-prasunmaiti87@gmail.com>
	 <1464690345.3076.17.camel@sipsolutions.net>
	 <CAEO8o4=-oYuHuh42yfRa6kAUZ2hBmxHabU-W3V82kURg-GZv_g@mail.gmail.com>
	 <1464979620.2224.5.camel@sipsolutions.net>
	 <87porxlfqb.fsf_-_@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I know we can't remove wext because of legacy applications but is
> there anything more we can do to make the users aware that wext is
> depreciated and really should be avoided? For example a onetime
> kernel warning? Or is that too spammy? Anything else?

The problem is that wext is in this weird hybrid state where it's
really deprecated if you can use nl80211, but you are required to use
wext if you can't use nl80211. Now, we disabled wext-for-cfg80211 by
default, but it's still there and could be used for some cases.

We probably should try to fix things, but I realize that code that
never gets tested [1].

Maybe we could print a message in the special cfg80211-wext case, which
has a special case in wext-core to avoid creating all those iw_handler
tables?

johannes

[1] and yeah - people move to nl80211 once told, so there's evidently
very little incentive to keep using wext, so in reality people don't
really seem to have applications that only use wext even with pure
cfg80211 drivers ...
