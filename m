Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36721 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab1IVLkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 07:40:09 -0400
Subject: Re: [RFC 2/5] mac80211: handle TDLS high-level commands and frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Kalyan C Gaddam <chakkal@iit.edu>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CA+XVXffOFw9RFFuwDTB_ei6Ktwai1tCicTuTeF5=4=WqZSZafw@mail.gmail.com> (sfid-20110922_093544_383002_D7230372)
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
	 <1316082334-7664-3-git-send-email-arik@wizery.com>
	 <1316606713.3940.29.camel@jlt3.sipsolutions.net>
	 <CA+XVXffOFw9RFFuwDTB_ei6Ktwai1tCicTuTeF5=4=WqZSZafw@mail.gmail.com>
	 (sfid-20110922_093544_383002_D7230372)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 13:40:05 +0200
Message-ID: <1316691605.3899.43.camel@jlt3.sipsolutions.net> (sfid-20110922_134014_457830_03AE0C40)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-22 at 10:34 +0300, Arik Nemtsov wrote:

> > Also accessing u.mgd.associated as a bool like this is fine, but
> > obviously racy. How do we deal with that? Do we even tear down links
> > when disassociating, and do we even need to beyond just killing the
> > station entries?
> 
> We don't tear down links just before disassociating (there are too
> many corner cases here). We just disable the links post-factum.
> Killing the station entries won't help for packets meant to be sent
> over the AP. I guess we can take the mutex for a little extra safely
> (but it won't do much).
> 
> The race is even worse - from queuing until the actual Tx, we could
> have disconnected from this AP and connected do a totally different
> one. But this shouldn't happen in reality (and we can add some guards
> to wpa_supplicant to make sure).
> Do you see this as a security threat?

I don't really know :-) I just saw the possible race here. If you remove
the TDLS station entries when disassociating then it shouldn't be an
issue, right? Since you require a station entry pretty early on anyway.

johannes

