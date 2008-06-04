Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:43778 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbYFDJRs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 05:17:48 -0400
Date: Wed, 4 Jun 2008 12:16:56 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: Re: mac80211 ad-hoc mode problems
Message-ID: <20080604091656.GE580@jm.kir.nu> (sfid-20080604_111804_192533_43E53ED1)
References: <1212543664.4237.14.camel@localhost.localdomain> <1212570001.14371.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1212570001.14371.16.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 04, 2008 at 11:00:00AM +0200, Johannes Berg wrote:
> On Tue, 2008-06-03 at 21:41 -0400, Dan Williams wrote:
> > 2) takes a _really_ long time to create an adhoc network.  This is
> > controlled by IEEE80211_IBSS_JOIN_TIMEOUT.  Why is that 20 seconds?

> Yeah, I don't know why it is that long. Jouni, do you remember maybe?
> I'm ok with reducing it.

Can't remember.. The only thing I can come up with is that 20 was the
next round number that is larger than IEEE80211_SCAN_INTERVAL_SLOW
defined on the previous line.. ;-) Anyway, I don't see why we would need
to wait that long. It should be enough to wait for a full scan of all
channels to be completed. It is of course nicer to avoid creating a new
IBSS if there is an existing one, but as long as merging works, it
should be fine to reduce this timeout.

-- 
Jouni Malinen                                            PGP id EFC895FA
