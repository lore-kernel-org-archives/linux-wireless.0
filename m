Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39093 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab3FROCB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 10:02:01 -0400
Message-ID: <1371564106.8318.18.camel@jlt4.sipsolutions.net> (sfid-20130618_160205_807979_971D783E)
Subject: Re: [RFC 0/4] add master channel switch announcement support
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Tue, 18 Jun 2013 16:01:46 +0200
In-Reply-To: <20130611141811.GA9490@pandem0nium>
References: <1367867635-3459-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1368439778.8300.20.camel@jlt4.sipsolutions.net>
	 <20130514092734.GA16426@pandem0nium>
	 <1370953885.8356.38.camel@jlt4.sipsolutions.net>
	 <20130611141811.GA9490@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-11 at 16:18 +0200, Simon Wunderlich wrote:

> > > I was thinking about adding another callback function or option for that for drivers
> > > who do the channel switch internally. Then we would only need mac80211 to adapt.
> > > 
> > > Would that help, or what would be problematic?
> > 
> > I don't really know. If you look at what we do in managed mode now, some
> > drivers will do the switching and report back when done.
> 
> OK, maybe we should leave that open to people who implement that feature for
> their respective drivers.

We just have to be aware of it and make the API "offloading-friendly"

> What I'm concered about is to initiate a channel switch from userspace. This will be
> required for IBSS-DFS: when a radar is detected and this event is sent to userspace, it
> must react by initiating a channel switch.

Why would that not happen in the kernel directly?

johannes

