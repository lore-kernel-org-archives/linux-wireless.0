Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.234]:7118 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbXFPXaC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2007 19:30:02 -0400
Received: by wx-out-0506.google.com with SMTP id t15so1186972wxc
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jun 2007 16:30:02 -0700 (PDT)
Message-ID: <1ba2fa240706161630r1fdb2ac1m87039a088c7d6bfd@mail.gmail.com>
Date: Sun, 17 Jun 2007 02:30:02 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH] bcm43xx QoS support
Cc: "Michael Buesch" <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	"Jiri Benc" <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	"Joseph Jezak" <josejx@gentoo.org>
In-Reply-To: <1182032257.23681.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200706161328.53726.mb@bu3sch.de>
	 <1ba2fa240706161438lfd629e4j7317bb62340c82a3@mail.gmail.com>
	 <1182032257.23681.1.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/17/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2007-06-17 at 00:38 +0300, Tomas Winkler wrote:
> > iwlwifi supports QoS. It has queues 4 hw for WMM access categories 2
> > hw queus for HCCA.
>
> But it too can't ever create QoS-data frames or negotiate TXOPs afaict,
> unless it does more than we want in hardware.

 True

> > There is also a discussion about supporting hardware queues in qdisc
> > in netdev.
>
> Which isn't really a concern to the driver since only mac80211 will need
> to be changed for that.
>
I'm not sure it's only mac80211 problem as driver is responsible for
stopping and waking up the queues. Only driver knows whether hw queue
is full or not.

> I suppose the question is: what are we missing in mac80211 now? It seems
> that we have no way of sending out QoS-data frames and that seems weird.

QoS frame are send just fine by mac80211 (at least under iwlwifi),
only the sequence numbers has to be overwritten in driver since the
current handler doesn't advance them per TID.

> Nor do we parse TXOP information etc. Possibly this is because we
> support WME and that's based on an early 802.11e draft?

I addition wme.c qdisc scheduler is rather naive one, it only
statically assign priorities, it wouldn't pass WMM certification I
guess.


> johannes
>
>
