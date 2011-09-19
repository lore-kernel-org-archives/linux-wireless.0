Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab1ISQiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 12:38:46 -0400
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Kalle Valo <kvalo@adurom.com>, Luciano Coelho <coelho@ti.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CAB3XZEdiTRDJGUHWJ5UorQq2w-ZLP+TP0b-qSSVUTzhPG4H2rg@mail.gmail.com> (sfid-20110919_183129_883763_93E84C66)
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
	 <1316408970.2157.9.camel@cumari> <87aaa0k0a1.fsf@purkki.adurom.net>
	 <CAB3XZEdiTRDJGUHWJ5UorQq2w-ZLP+TP0b-qSSVUTzhPG4H2rg@mail.gmail.com>
	 (sfid-20110919_183129_883763_93E84C66)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 18:38:39 +0200
Message-ID: <1316450319.5995.33.camel@jlt3.sipsolutions.net> (sfid-20110919_183849_522201_F9BE57E3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-19 at 19:30 +0300, Eliad Peller wrote:

> AFAIU from the coex guys, the scenario is something like this:
> upon coex activity, the fw might delay its rx and tx paths. this means
> that the fw might get a frame within the 100ms of the dyn ps, but
> delay its processing and pass it up to the driver only later.
> this will cause redundant psm enter (after 100ms) and psm exit (after
> the fw passed the packet).
> i'm not sure about the exact effect during coex operation, but
> eventually these psm enter/exit affect the throughput.
> 
> another point here, is that during a specific period (during auto_mode
> on), there might or might not be coex activity. thus, we can't just
> disable dyn_ps, as it will hurt throughput (when there is no coex
> activity).
> 
> bottom line - i'm not sure about all the details, but according to
> their tests - it does improve the throughput.
> (i can try getting better details if you have additional questions)

It'd be interesting to see if we can just treat this as a "minimum awake
time", kinda like going back to the range I thought about earlier.

johannes

