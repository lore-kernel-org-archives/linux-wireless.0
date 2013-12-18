Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48856 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab3LRJe3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 04:34:29 -0500
Message-ID: <1387359265.4694.11.camel@jlt4.sipsolutions.net> (sfid-20131218_103434_330796_4DE6CFD5)
Subject: Re: [PATCH v5] cfg80211: fix dfs channel state after stopping AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 18 Dec 2013 10:34:25 +0100
In-Reply-To: <201312171544.48479.sw@simonwunderlich.de>
References: <1387209049-25529-1-git-send-email-marek.puzyniak@tieto.com>
	 <201312171544.48479.sw@simonwunderlich.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-17 at 15:44 +0100, Simon Wunderlich wrote:
> > In AP mode DFS channel state is changed to DFS_AVAILABLE
> > after successful CAC and remains as such until a radar
> > signal is detected during the In-Service Monitoring.
> > When AP is stopped it is no longer monitoring current channel
> > for radar signals. DFS channel state should be changed
> > to DFS_USABLE when last AP interface is stopped. Starting AP
> > again on that channel will start CAC instead of starting radiation.
> > 
> 
> Sorry for answering after so many revisions, but ... why do you think this is 
> required? Many APs first do a CAC on all available channels, but then pick one 
> channel and use that, while being able to switch to another channel 
> immediately.

I'll drop the patch for now - please discuss :P

johannes


