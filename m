Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47382 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3BEOQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 09:16:56 -0500
Message-ID: <1360073836.8376.10.camel@jlt4.sipsolutions.net> (sfid-20130205_151706_344715_2E47E8AD)
Subject: Re: [RFC] cfg80211: configuration for WoWLAN over TCP
From: Johannes Berg <johannes@sipsolutions.net>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 05 Feb 2013 15:17:16 +0100
In-Reply-To: <1360072210.8376.9.camel@jlt4.sipsolutions.net> (sfid-20130205_144950_996774_14518D3F)
References: <1360062367-15970-1-git-send-email-johannes@sipsolutions.net>
	 <51110D86.8030500@gmail.com>
	 (sfid-20130205_144759_494055_8E3FC786) <1360072210.8376.9.camel@jlt4.sipsolutions.net>
	 (sfid-20130205_144950_996774_14518D3F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-05 at 14:50 +0100, Johannes Berg wrote:
> On Tue, 2013-02-05 at 14:47 +0100, Pontus Fuchs wrote:
> > On 2013-02-05 12:06, Johannes Berg wrote:
> > >
> > > Intel Wireless devices are able to make a TCP connection
> > > after suspending, sending some data and waking up when
> > > the connection receives wakeup data (or breaks). Add the
> > > WoWLAN configuration and feature advertising API for it.
> > >
> > 
> > What's protecting this feature from stomping on an existing connection 
> > when specifying the source port?
> 
> Nothing. Presumably if you specify it you know what you're doing, and
> don't also create a connection to the same IP from the same port?
> 
> Hmm. Maybe we could allocate the socket anyway and make it allocate the
> chosen port, failing if it isn't available? I guess I need to check the
> APIs.

I guess this might work: http://p.sipsolutions.net/e5bc789d26b5e34a.txt

johannes

