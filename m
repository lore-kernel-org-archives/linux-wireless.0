Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41162 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbaBDKdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 05:33:17 -0500
Message-ID: <1391509992.4134.1.camel@jlt4.sipsolutions.net> (sfid-20140204_113320_265578_4000838E)
Subject: Re: [RFC 2/2] cfg80211: move channel switch logic to cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 04 Feb 2014 11:33:12 +0100
In-Reply-To: <1391508433.26522.61.camel@porter.coelho.fi>
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	 <1391421529-6067-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140203_110356_335827_0A67B036) <1391434913.4488.24.camel@jlt4.sipsolutions.net>
	 <1391508433.26522.61.camel@porter.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-04 at 12:07 +0200, Luca Coelho wrote:

> > Hmm, that sounds a bit the wrong way around? Shouldn't the CSA not be
> > possible (userspace CSA) or cause the switching interface to disconnect,
> > rather than *others*??
> 
> It depends.  And this logic is too complicated to stay in the kernel,
> IMHO.  If we are in a GO-follows-STA scenario, we want to disconnect the
> GO.  Now, if you have an AP (with tons of STAs connected to it) and a
> P2P client gets a CSA for whatever reason, do we really want to stop the
> AP?

Well, what I was describing was really only the default policy if
userspace didn't do anything useful, which IMHO should really just be:

 * client receives CSA - disconnect if it can't be done
 * AP/GO wants CSA - refuse if it can't be done, let userspace sort it
out

In the first case, userspace still has the time between receiving the
CSA and actually acting on it to make another decision.

johannes

