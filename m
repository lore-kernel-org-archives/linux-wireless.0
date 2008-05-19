Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609AbYESLH5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 07:07:57 -0400
Subject: Re: [PATCHv2] mac80211: fix NULL pointer dereference
	in	ieee80211_compatible_rates
From: Dan Williams <dcbw@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Tomas Winkler <tomasw@gmail.com>, Helmut Schaa <hschaa@suse.de>,
	John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <483047DD.2050205@lwfinger.net>
References: <20080517203531.vus3gj5ce8ksskkc@imap.suse.de>
	 <1ba2fa240805180337h35bc3244od619e78c0d95d895@mail.gmail.com>
	 <1211117578.686.12.camel@localhost.localdomain>
	 <483047DD.2050205@lwfinger.net>
Content-Type: text/plain
Date: Mon, 19 May 2008 07:07:54 -0400
Message-Id: <1211195274.3203.11.camel@localhost.localdomain> (sfid-20080519_130822_236785_2A9F5A99)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-05-18 at 10:14 -0500, Larry Finger wrote:
> Dan Williams wrote:
> > On Sun, 2008-05-18 at 13:37 +0300, Tomas Winkler wrote:
> >> Again, mac should rather solve the problem that we do not connect to
> >> AP's that are not in the BSS list
> >> Personally I would NACK this as it's just hiding  the real problem
> > 
> > Ugh; is that what's happening?  If the AP isn't in the BSS list of the
> > card, then the card shouldn't be connecting to it.  It should have been
> > probe-scanned already and thus exist in the BSS list, right?
> > 
> > Dan
> > 
> >> The other issue is that we call ieee80211_rx_bss_put(dev, bss); before
> >> this call in ieee80211_send_assoc.
> 
> This AP certainly should have been in the BSS list. As I stated in the 
> original post, the system had been connected to that AP for about 18 hours 
> before the NULL bss NULL event occurred.
> 
> Clearly the sequence of events is improbable and it may be some time before 
> it happens again. What diagnostic information would be useful to capture 
> if/when it occurs? Is there any other location that I should monitor?

I'd think a printk whenever a unique BSS item is removed from the BSS
list; and the location of that removal in the code using __func__ and
__LINE__ in the output.

Dan

