Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49750 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbbIDSCn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2015 14:02:43 -0400
Message-ID: <1441389753.1971.16.camel@sipsolutions.net> (sfid-20150904_200246_604278_0EB1F61D)
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Date: Fri, 04 Sep 2015 20:02:33 +0200
In-Reply-To: <wrfjr3megjoi.fsf@redhat.com>
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	 <1441032517.13980.21.camel@sipsolutions.net> <wrfjmvx73u0l.fsf@redhat.com>
	 <1441120044.2441.9.camel@sipsolutions.net> <wrfj4mjcqn3x.fsf@redhat.com>
	 <1441275442.2565.17.camel@sipsolutions.net> <wrfjr3megjoi.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-09-04 at 13:48 -0400, Jes Sorensen wrote:
> 
> Gotcha, now you mention it, that rings a bell! I'll put that on my todo
> list. One of the biggest things puzzling me is how much the firmware
> does with AMPDU - there is a break bit I can set in the TX descriptor to
> say 'don't AMPDU this packet' but do not actually know if it will do all
> of this behind my back. I need to dig more into the vendor driver (and
> their 80211 stack) to see if I can figure that out.
> 

That also seems possibly like something you'd set within an existing
aggregation session - you can still send non-aggregated frames, and
might decide to do that for example for EAPOL frames.

johannes
