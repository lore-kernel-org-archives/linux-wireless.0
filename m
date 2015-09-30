Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51626 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932630AbbI3S2r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 14:28:47 -0400
Message-ID: <1443637722.1859.15.camel@sipsolutions.net> (sfid-20150930_202852_081219_8BBC8C75)
Subject: Re: Low latency communication over wifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Bastian Bittorf <bittorf@bluebottle.com>, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@do-not-panic.com,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Date: Wed, 30 Sep 2015 20:28:42 +0200
In-Reply-To: <20150930172440.GA11160@amd>
References: <20150926102403.GA21555@amd>
	 <1443426103.2401.1.camel@sipsolutions.net> <20150930172440.GA11160@amd>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-09-30 at 19:24 +0200, Pavel Machek wrote:
> On Mon 2015-09-28 09:41:43, Johannes Berg wrote:
> > On Sat, 2015-09-26 at 12:24 +0200, Pavel Machek wrote:
> > > 
> > > That would be equivalent to ping -Q, right? It does not seem to have
> > > any effect :-(. I'd expect at least local machine to use shorter waits
> > > for medium, and thus drop packets instead of waiting.
> > 
> > Correct. But it won't *drop* packets, it just increases the chances of
> > getting medium access.
> 
> Increases chances of medium access, but limits number of retries, so
> it should drop sooner, no?

No, assigning VO AC by itself won't (typically) limit the number of
retries.

> This should send the second  ping to the priority queue based on -Q,
> but I don't see an effect against one access point.... and it seems to
> work somehow against second one. Good!
> 
Well it depends on whether or not your AP supports WMM/QoS to start
with :)

johannes
