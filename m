Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35190 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab0AXLpV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 06:45:21 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: hwtkip hangs on b43
Date: Sun, 24 Jan 2010 12:45:15 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>, kecsa@kutfo.hit.bme.hu,
	linux-wireless@vger.kernel.org
References: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu> <4B5BE16E.7080901@lwfinger.net> <1264332771.23766.24.camel@johannes.local>
In-Reply-To: <1264332771.23766.24.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001241245.17176.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 24 January 2010 12:32:50 Johannes Berg wrote:
> > >>> We can just remove the lock and add a comment explaining why it is not locked...
> 
> Mind you, it won't work on SDIO hardware since the callback cannot
> sleep, contrary to what Kalle documented :(

I don't understand. Why wouldn't SDIO be allowed to sleep?
b43 is fully preemptible, except for the lowlevel PCI interrupt handler.

-- 
Greetings, Michael.
