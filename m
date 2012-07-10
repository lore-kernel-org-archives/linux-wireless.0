Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38143 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab2GJLUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 07:20:07 -0400
Message-ID: <1341919201.4475.11.camel@jlt3.sipsolutions.net> (sfid-20120710_132012_268275_796E1829)
Subject: Re: [RFC] nl80211: Avoid checking for empty WoWLAN triggers
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 10 Jul 2012 13:20:01 +0200
In-Reply-To: <4FFC0F22.6040906@qca.qualcomm.com>
References: <1341914875-14647-1-git-send-email-mohammed@qca.qualcomm.com>
	 <1341918365.4475.9.camel@jlt3.sipsolutions.net>
	 <4FFC0F22.6040906@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-10 at 16:46 +0530, Mohammed Shafi Shajakhan wrote:
> Hi Johannes,
> 
> On Tuesday 10 July 2012 04:36 PM, Johannes Berg wrote:
> > On Tue, 2012-07-10 at 15:37 +0530, Mohammed Shafi Shajakhan wrote:
> >> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> >>
> >> Previously we would check in nl80211 with an empty
> >> cfg80211_wowlan structure to check for 'iw phy phyX wowlan enable'
> >> with empty arguments (or) no triggers and disable WoWLAN.
> >
> > No ... that's not how it works. If you enable WoWLAN without any
> > triggers, then that's what you get: the connection is kept alive but
> > there are no wakeup sources. If you don't specify the triggers at all
> > then it's disabled.
> >
> 
> If we want to do disable WoWLAN we can use the command 'iw phy phyX 
> wowlan disable' command. Its true that we would 'Keep Alive'
> the connection, but we would disable the wake up capability via
> 'set_wakeup' callback, something similar to wowlan disable command.
> Please let me know if i am missing something (or) the advantage having
> the connection Keep alive with wowlan enable without triggers.

I don't know if there's any advantage. It could be useful for example to
get a connection up quicker after resume. I just didn't want to preclude
that use case.

johannes

