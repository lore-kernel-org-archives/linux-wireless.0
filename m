Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35946 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466AbZCKNwp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 09:52:45 -0400
Subject: Re: configuring while interface is down
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Samuel Ortiz <samuel@sortiz.org>,
	Alina Friedrichsen <x-alina@gmx.net>
In-Reply-To: <1236774973.20266.13.camel@johannes.local>
References: <1236774973.20266.13.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 09:49:59 -0400
Message-Id: <1236779399.10989.3.camel@localhost.localdomain> (sfid-20090311_145322_904569_4D9050F7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-03-11 at 13:36 +0100, Johannes Berg wrote:
> Hi,
> 
> Alina raised an interesting point -- wext allows you to configure an
> interface while it is down, at least by convention. Some parameters for
> cfg80211 we reject while an interface is down, e.g. adding new stations,
> partly for technical reasons and partly because that doesn't make sense
> when the mode of interface isn't fixed.
> 
> For cfg80211's assoc/ibss calls, I think we should reject them outright
> when the interface is down, any objections?

wext *allows* that, but drivers never consistently implemented that
(prism54 for example).  With most soft-mac style adapters you can't scan
while the interface is down either.  Anything meaningful use of the
interface happens when the firmware (if any) is loaded and the device is
operational.  The only reason for setting parameters while the device
was down was to allow "commit-style" handling of the parameters; set
them all up while down, bring the interface up, and it uses all the
params you've set/locked on the interface.  With cfg80211, that's
already handled in a much better manner, thus +1 from me.

Dan


