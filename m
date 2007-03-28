Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47715
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965524AbXC1LdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 07:33:13 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rx racing against removing interfaces?
Date: Wed, 28 Mar 2007 13:32:40 +0200
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1174950322.25887.59.camel@johannes.berg> <200703281259.55764.mb@bu3sch.de> <1175080054.5151.50.camel@johannes.berg>
In-Reply-To: <1175080054.5151.50.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200703281332.40879.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 March 2007 13:07, Johannes Berg wrote:
> On Wed, 2007-03-28 at 12:59 +0200, Michael Buesch wrote:
> 
> > Oh, you mean virtual interfaces.. yeah, there's probably a race. I don't
> > know the locking there.
> 
> Yes, I mean virtual interfaces, when the thing is in progress while we
> iterate through.
> 
> > But my comment about the non-irqsafe-variants-should-be-hidden still applies :)
> 
> I'll reread it ;)
> 
> But I'm not sure I fully agree. If the driver calls __ieee80211_rx in
> softirq context that should be good without requiring to reschedule in
> mac80211.

I'm not sure there is an easy and non-racy way to drop the driver IRQ lock
while calling __ieee80211_rx synchronously.

-- 
Greetings Michael.
