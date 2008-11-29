Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:44317 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbYK2RGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 12:06:23 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/3] mac80211: add power state transition callbacks
Date: Sat, 29 Nov 2008 18:06:19 +0100
Cc: linux-wireless@vger.kernel.org,
	Stefan Steuerwald <salsasepp@googlemail.com>
References: <200811282345.48379.chunkeey@web.de> <200811291315.01685.chunkeey@web.de> <1227961293.3542.7.camel@johannes.berg>
In-Reply-To: <1227961293.3542.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811291806.20309.chunkeey@web.de> (sfid-20081129_180626_878941_68D660FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 29 November 2008 13:21:33 Johannes Berg wrote:
> On Sat, 2008-11-29 at 13:15 +0100, Christian Lamparter wrote:
> 
> > > Unless we want to defer RX packet processing to a workqueue rather than
> > > a tasklet?
> 
> > Hmm, but if we put the RX packet processing into a workqueue, we have to
> > put the tx status report processing in one too (see comment about rx/tx race
> > in main.c line 400)?
> 
> Yeah, probably. I don't know all the details all the time, so I write
> such comments ;)
> 
> > Or do you mean I should only put ap_sta_ps_end  (& ap_sta_ps_start) 
> > resending stuff into a workqueue? (Yeah, this makes a lot more sense,
> > and might actually work!, well let's prepare another patch)
> 
> No idea!
> 
> The only thing I was thinking is that it's not a good plan to have a
> callback that has different locking requirements depending on a
> parameter.

yeah...  go back to the extra sta_notify_ps callback approach?
I tried to do this with workqueues, but It turned out that queue_work
doesn't work since we disabled the irqs in the rx path.
( http://linux.derkeiler.com/Mailing-Lists/Kernel/2005-02/3350.html
 has a story about the bitter consequences of queue_work & irq_disabled) 

Regards,
	Chr
