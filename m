Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbYFDOSj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 10:18:39 -0400
Subject: Re: mac80211 ad-hoc mode problems
From: Dan Williams <dcbw@redhat.com>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080604091656.GE580@jm.kir.nu>
References: <1212543664.4237.14.camel@localhost.localdomain>
	 <1212570001.14371.16.camel@johannes.berg>  <20080604091656.GE580@jm.kir.nu>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 10:18:24 -0400
Message-Id: <1212589104.13676.17.camel@localhost.localdomain> (sfid-20080604_161842_788188_93C2B212)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-04 at 12:16 +0300, Jouni Malinen wrote:
> On Wed, Jun 04, 2008 at 11:00:00AM +0200, Johannes Berg wrote:
> > On Tue, 2008-06-03 at 21:41 -0400, Dan Williams wrote:
> > > 2) takes a _really_ long time to create an adhoc network.  This is
> > > controlled by IEEE80211_IBSS_JOIN_TIMEOUT.  Why is that 20 seconds?
> 
> > Yeah, I don't know why it is that long. Jouni, do you remember maybe?
> > I'm ok with reducing it.
> 
> Can't remember.. The only thing I can come up with is that 20 was the
> next round number that is larger than IEEE80211_SCAN_INTERVAL_SLOW
> defined on the previous line.. ;-) Anyway, I don't see why we would need
> to wait that long. It should be enough to wait for a full scan of all
> channels to be completed. It is of course nicer to avoid creating a new
> IBSS if there is an existing one, but as long as merging works, it
> should be fine to reduce this timeout.

Ok, I'll drop it down to 5 seconds if that's OK with you.  That's still
the same amount of time as the wpa_supplicant assoc_failed auth timeout
in wpa_supplicant_associate() though, so they could still step on each
other.  Not quite sure what to do about that except bump up the
wpa_supplicant assoc_failed timeout by a few more seconds?

dan

