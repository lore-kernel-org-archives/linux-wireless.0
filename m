Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbYFDRan (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 13:30:43 -0400
Subject: Re: mac80211 ad-hoc mode problems
From: Dan Williams <dcbw@redhat.com>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080604155504.GH580@jm.kir.nu>
References: <1212543664.4237.14.camel@localhost.localdomain>
	 <1212570001.14371.16.camel@johannes.berg> <20080604091656.GE580@jm.kir.nu>
	 <1212589104.13676.17.camel@localhost.localdomain>
	 <20080604155504.GH580@jm.kir.nu>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 13:30:32 -0400
Message-Id: <1212600632.20764.7.camel@localhost.localdomain> (sfid-20080604_193046_633467_15306FC6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-04 at 18:55 +0300, Jouni Malinen wrote:
> On Wed, Jun 04, 2008 at 10:18:24AM -0400, Dan Williams wrote:
> 
> > Ok, I'll drop it down to 5 seconds if that's OK with you.  That's still
> > the same amount of time as the wpa_supplicant assoc_failed auth timeout
> > in wpa_supplicant_associate() though, so they could still step on each
> > other.  Not quite sure what to do about that except bump up the
> > wpa_supplicant assoc_failed timeout by a few more seconds?
> 
> As long as there is still enough time for the scan to be completed
> before deciding to create a new IBSS. I don't remember how that code
> worked, so I don't know whether 5 second as the IBSS timeout will
> guarantee this for every case. If there are any problems in providing
> such guarantee, I have nothing against increasing the wpa_supplicant
> timeout for IBSS. I might do that anyway since there is not really much
> point in timing out IBSS join/create in most cases.

That's probably the best solution; to increase the supplicant's timeout
for the IBSS case and decrease the mac80211 IBSS create timeout.

Dan

