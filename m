Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:53197
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbXCWSgz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 14:36:55 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: Properly kill tasklets before shutdown
Date: Fri, 23 Mar 2007 19:36:42 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <200703061902.00001.mb@bu3sch.de> <200703231822.50522.mb@bu3sch.de> <20070323183220.11ffb2a3@griffin.suse.cz>
In-Reply-To: <20070323183220.11ffb2a3@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703231936.42249.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 March 2007 18:32, Jiri Benc wrote:
> On Fri, 23 Mar 2007 18:22:50 +0100, Michael Buesch wrote:
> > kill == (make sure it's not scheduled anymore) && disable
> 
> Are you sure? I cannot find anything in tasklet_kill which disables the
> tasklet.

It doesn't bounce the count, but it waits for the tasklet to finish
and makes sure it's not scheduled anymore.
Why do you want to inc the count? There is no point in that.


disable does: Wait for it to finish running && inc the count

kill does: make sure it's not scheduled, wait for it to finish.

Why disable it? If there's anything scheduling the tasklet while
we have unregistered we _want_ it to crash, as that's a real bug
in the first place. (And I don't think it's possible to
schedule it after unregister).

-- 
Greetings Michael.
