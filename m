Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49226 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbbIQQrA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 12:47:00 -0400
Message-ID: <1442508413.2821.11.camel@sipsolutions.net> (sfid-20150917_184704_304012_41D4E023)
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Date: Thu, 17 Sep 2015 18:46:53 +0200
In-Reply-To: <21994.26976.882903.355191@gargle.gargle.HOWL>
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	 <1441032517.13980.21.camel@sipsolutions.net> <wrfjmvx73u0l.fsf@redhat.com>
	 <1441120044.2441.9.camel@sipsolutions.net> <wrfj4mjcqn3x.fsf@redhat.com>
	 <wrfjvbbsp6ot.fsf@redhat.com> <1441275474.2565.18.camel@sipsolutions.net>
	 <wrfjmvx2gi0m.fsf@redhat.com>
	 <21994.26976.882903.355191@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-09-05 at 09:32 +0530, Sujith Manoharan wrote:
> Jes Sorensen wrote:
> > > Ah, this makes sense. There's an rc_update call or something like 
> > > that,
> > > that might have the requisite information. Not really sure off 
> > > the top
> > > of my head.
> 
> ieee80211_sta doesn't contain the preamble information, though ?
> 
> The bss information holds the short preamble information, so that can
> probably be used - using BSS_CHANGED_ERP_PREAMBLE.

Yes, this is a good point, and the preamble can't really be different
for different stations since all the stations in the BSS (and even
outside it on the same channel) must be able to decode it.

So yeah - Jes, you can remove that and use the
BSS_CHANGED_ERP_PREAMBLE.


johannes
