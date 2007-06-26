Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47824
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbXFZOSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2007 10:18:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211/bcm43xx deadlock
Date: Tue, 26 Jun 2007 16:17:45 +0200
Cc: linux-wireless@vger.kernel.org
References: <1182848382.3830.5.camel@johannes.berg>
In-Reply-To: <1182848382.3830.5.camel@johannes.berg>
MIME-Version: 1.0
Message-Id: <200706261617.45713.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 26 June 2007 10:59:41 Johannes Berg wrote:
> Hey,
> 
> I just managed to deadlock bcm43xx when I was trying to do something
> with iwconfig at the same time as telling network manager to shut off
> the interface. It stayed up and things were locked up.
> 
> I haven't been able to analyse it yet, I dumped process stacks a few
> times and put the resulting log at
> http://johannes.sipsolutions.net/files/mac80211-bcm43xx-deadlock
> 
> Note that many processes are in rtnl_lock() but wpa_supplicant is stuck
> in wait_for_completion.
> 
> johannes
> 

That's a known bug.
See the FIXME at stop_core() where we stop the mac80211-queues.
mac80211 needs to be fixed to fix this. ;)
We need a function to stop and flush the TX queues from
_outside_ of the TX handlers.

-- 
Greetings Michael.
