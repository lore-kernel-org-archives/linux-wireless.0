Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57428 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbcA1WMr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 17:12:47 -0500
Message-ID: <1454019155.2332.15.camel@sipsolutions.net> (sfid-20160128_231256_462881_DF986834)
Subject: Re: WARNING at net/mac80211/rate.c:513 ieee80211_get_tx_rates
 [mac80211]
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: David Miller <davem@davemloft.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>
Date: Thu, 28 Jan 2016 23:12:35 +0100
In-Reply-To: <CA+55aFzF0gWfvmE+6ZcHmjnO4xp-oVAQ5SWxYJhOzns2ocgCsw@mail.gmail.com> (sfid-20160128_230454_551008_3AE61B48)
References: <CA+55aFxe22iWok6UojY=hCoG2k1wNpJ9CfQ0b+STSxq67tb86Q@mail.gmail.com>
	 <1453983185.2217.12.camel@sipsolutions.net>
	 <CA+55aFya9K4JboNY8kB9cg6zt9otguhdzfHm3jvLmWedxQTSWg@mail.gmail.com>
	 <1454013625.2332.9.camel@sipsolutions.net>
	 <CA+55aFx73nv9ny-fu5BR6v8wL=f2oFomwrZoLRw=x2kNP76cYA@mail.gmail.com>
	 <CA+55aFzF0gWfvmE+6ZcHmjnO4xp-oVAQ5SWxYJhOzns2ocgCsw@mail.gmail.com>
	 (sfid-20160128_230454_551008_3AE61B48)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-01-28 at 14:04 -0800, Linus Torvalds wrote:
> 
> Well, it "makes a difference" in the sense that the warning goes
> away.
> But it doesn't make things work. In fact, it might be making things
> worse.

Heh, ok.

> Because with that patch, the wireless still authenticates and
> associates, but then it doesn't even get an IP address, so now even
> dhcp doesn't work. Of course, I was surprised that it worked last
> time, and I'm not 100% sure it did work consistently. I'll re-test
> without the patch, just to make sure, but it doesn't really seem to
> improve on anything.
> 

It makes some sense, here's some speculation:

VHT rates are MCS 0-9. If the rate scaling decides to use only VHT
MCSes with a VHT-capable peer, then it stands to reason it might still
start at 0, but forget to set the VHT_MCS flag, so it would really use
rate index 0 from the table, which is 6 MBps. Then, it would see that
"working" (since it's not the right thing) and scale up until it hits
MCS 8 or 9, which is no longer a valid rate (those are only 0-7).

Since the suggested changes make it worse, we can assume that this is
not the only place where VHT is simply completely broken, and fixing
VHT here will instead uncover a bug elsewhere, that was previously not
happening because we never got to real VHT rates.

Your best workaround may just be to ignore VHT for now - clearly it's
broken so using "just" HT (which is likely not that much of a penalty
anyway since you're apparently not using 80 MHz) will be much better.

Go into

_rtl_init_hw_vht_capab()

and just remove or stub out the entire contents of that (or you could
just remove the "vht_supported=true" if you feel like it.)

That should get it to HT only, which is likely tested and working
better.

johannes
