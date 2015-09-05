Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:55670 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbbIEEB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Sep 2015 00:01:27 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21994.26976.882903.355191@gargle.gargle.HOWL> (sfid-20150905_060146_042285_AB085793)
Date: Sat, 5 Sep 2015 09:32:40 +0530
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
In-Reply-To: <wrfjmvx2gi0m.fsf@redhat.com>
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	<1441032517.13980.21.camel@sipsolutions.net>
	<wrfjmvx73u0l.fsf@redhat.com>
	<1441120044.2441.9.camel@sipsolutions.net>
	<wrfj4mjcqn3x.fsf@redhat.com>
	<wrfjvbbsp6ot.fsf@redhat.com>
	<1441275474.2565.18.camel@sipsolutions.net>
	<wrfjmvx2gi0m.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen wrote:
> > Ah, this makes sense. There's an rc_update call or something like that,
> > that might have the requisite information. Not really sure off the top
> > of my head.

ieee80211_sta doesn't contain the preamble information, though ?

The bss information holds the short preamble information, so that can
probably be used - using BSS_CHANGED_ERP_PREAMBLE.

> I'll add a comment to the code explaining why it is done this way. I had
> a peak at the rate_control code earlier, but it wasn't obvious to me
> whether I should be using that API at all. Is there an explanation of
> the API and it's usage somewhere?

sta_rc_update() can be used when the target firmware (or a custom rate
control module) expects the driver to provide valid operational bitrates.

Sujith
