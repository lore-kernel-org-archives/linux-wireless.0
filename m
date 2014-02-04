Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:38345 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaBDLLy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 06:11:54 -0500
Message-ID: <1391512311.26522.75.camel@porter.coelho.fi> (sfid-20140204_121157_736415_60DC7D22)
Subject: Re: [RFC 2/2] cfg80211: move channel switch logic to cfg80211
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 04 Feb 2014 13:11:51 +0200
In-Reply-To: <1391509992.4134.1.camel@jlt4.sipsolutions.net>
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	 <1391421529-6067-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140203_110356_335827_0A67B036) <1391434913.4488.24.camel@jlt4.sipsolutions.net>
	 <1391508433.26522.61.camel@porter.coelho.fi>
	 <1391509992.4134.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-04 at 11:33 +0100, Johannes Berg wrote:
> On Tue, 2014-02-04 at 12:07 +0200, Luca Coelho wrote:
> 
> > > Hmm, that sounds a bit the wrong way around? Shouldn't the CSA not be
> > > possible (userspace CSA) or cause the switching interface to disconnect,
> > > rather than *others*??
> > 
> > It depends.  And this logic is too complicated to stay in the kernel,
> > IMHO.  If we are in a GO-follows-STA scenario, we want to disconnect the
> > GO.  Now, if you have an AP (with tons of STAs connected to it) and a
> > P2P client gets a CSA for whatever reason, do we really want to stop the
> > AP?
> 
> Well, what I was describing was really only the default policy if
> userspace didn't do anything useful, which IMHO should really just be:
> 
>  * client receives CSA - disconnect if it can't be done
>  * AP/GO wants CSA - refuse if it can't be done, let userspace sort it
> out
> 
> In the first case, userspace still has the time between receiving the
> CSA and actually acting on it to make another decision.

Right, this is okay, but the point is, what happens to the *other*
interfaces?

What does "it can't be done" mean for the client? If there's a GO in the
same context and no free contexts for the switch, do we simply
disconnect the client (and leave the GO hanging in the same channel)? We
should probably tell the userspace and let it decide.

--
Luca.

