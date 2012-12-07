Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58802 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2LGV4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 16:56:10 -0500
Message-ID: <1354917388.9124.24.camel@jlt4.sipsolutions.net> (sfid-20121207_225614_323257_820F556A)
Subject: Re: [RFC PATCH] af_packet: don't to defrag shared skb
From: Johannes Berg <johannes@sipsolutions.net>
To: Eric Leblond <eric@regit.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Fri, 07 Dec 2012 22:56:28 +0100
In-Reply-To: <1354916768.4530.18.camel@tiger2>
References: <1354906561-4695-1-git-send-email-eric@regit.org>
	 <20121207.153134.25835204617509469.davem@davemloft.net>
	 <1354915824.9124.11.camel@jlt4.sipsolutions.net>
	 <1354916768.4530.18.camel@tiger2>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HI,

> > That's interesting. A single one seems odd. I might have expected two,
> > but not one. Well, since you removed the crash ... I guess I'll have to
> > believe that there's just one and the second one doesn't show up because
> > we crashed before :-)
> 
> It was the case with initial code but I've suppressed the BUG() call and
> replaced it with a return ;)

Right. Well, does it actually still work then? I wonder if then you
don't see a second packet because the first one doesn't make it
through ... I'm thinking that this is just an internal af_packet problem
with multiple listeners.


> I've no simple code available to test it. I've add the problem when
> running suricata. Maybe you could use it. It is packaged in most
> distribution now.
> To enable packet fanout. Modify default /etc/suricata/suricata.yaml to
> have something like:
> af-packet:
>   - interface: wlan0
>     # Number of receive threads (>1 will enable experimental flow pinned
>     # runmode)
>     threads: 3

That'll should do, thanks.

johannes

