Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59017 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1KCIcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 04:32:13 -0400
Subject: Re: [wireless-next PATCH 3/5] wifi: Allow overriding some HT
 information.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB1860E.5080800@candelatech.com>
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
	 <1319778680-11405-3-git-send-email-greearb@candelatech.com>
	 (sfid-20111028_071147_787476_DBCC8CCF) <1319789573.3914.15.camel@jlt3.sipsolutions.net>
	 <4EAAD95E.1030001@candelatech.com>
	 (sfid-20111028_183341_942256_664FE0B1) <1320221630.3950.22.camel@jlt3.sipsolutions.net>
	 <4EB176F9.7090304@candelatech.com>
	 <1320256198.7846.2.camel@jlt3.sipsolutions.net>
	 <4EB1860E.5080800@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 09:32:11 +0100
Message-ID: <1320309131.3950.9.camel@jlt3.sipsolutions.net> (sfid-20111103_093218_542828_ED9478C5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-02 at 11:03 -0700, Ben Greear wrote:

> >>>>           /* add attributes here, update the policy in nl80211.c */
> >>
> >> I copied some of that code from nl80211_set_station, which appears to
> >> also forget to check the length for the NL80211_ATTR_HT_CAPABILITY
> >> object.  Is there some reason why it doesn't need to check, or does
> >> that code need fixing as well?
> >
> > NL80211_ATTR_HT_CAPABILITY in particular *has* a policy entry.
> 
> Ahh, I didn't realize that's what was meant by policy.  Mind if
> I change that comment to something like what is below?
> 
> /* add attributes here, update the nl80211_policy array in nl80211.c */

That seems reasonable, though there are multiple policies for
differently nested attributes, but I guess anyone who understands that
will get far enough anyway :-)

FWIW, I just found that the exact example you pointed out had a bug --
NLA_BINARY enforces a *max*, not *min* length. There's a patch in flight
to fix it.

johannes

