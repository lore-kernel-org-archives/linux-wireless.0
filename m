Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42105
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbXF0Mtj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 08:49:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211/bcm43xx deadlock
Date: Wed, 27 Jun 2007 14:48:57 +0200
Cc: linux-wireless@vger.kernel.org
References: <1182848382.3830.5.camel@johannes.berg> <200706261617.45713.mb@bu3sch.de> <1182937106.4769.10.camel@johannes.berg>
In-Reply-To: <1182937106.4769.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200706271448.58087.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 27 June 2007 11:38:26 Johannes Berg wrote:
> On Tue, 2007-06-26 at 16:17 +0200, Michael Buesch wrote:
> 
> > That's a known bug.
> > See the FIXME at stop_core() where we stop the mac80211-queues.
> > mac80211 needs to be fixed to fix this. ;)
> > We need a function to stop and flush the TX queues from
> > _outside_ of the TX handlers.
> 
> Are you sure it's the same bug? I don't think we get into

Pretty, yeah. I'm probably going to solve this bug elsewhere.
Need to think about it.

> ieee80211_if_shutdown from bcm43xx itself.

bcm43xx causes it only imlicitely. Calling ieee80211_stop_queues()
(from outside of the TX path) will result in a deadlock in the
qdisc handler, which will result in a complete system freeze on UP.
So bcm43xx won't show up in the call-trace.

-- 
Greetings Michael.
