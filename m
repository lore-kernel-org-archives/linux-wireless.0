Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbYHMM07 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 08:26:59 -0400
From: Helmut Schaa <hschaa@suse.de>
To: Jouni Malinen <j@w1.fi>
Subject: Re: Pondering: how to improve mac80211 roaming ...
Date: Wed, 13 Aug 2008 14:26:55 +0200
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
References: <200808120838.52888.hs4233@mail.mn-solutions.de> <200808121440.24098.hschaa@suse.de> <20080812154223.GE4981@jm.kir.nu>
In-Reply-To: <20080812154223.GE4981@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808131426.55673.hschaa@suse.de> (sfid-20080813_142703_774266_584A7E63)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 12. August 2008 17:42:23 schrieb Jouni Malinen:
> On Tue, Aug 12, 2008 at 02:40:23PM +0200, Helmut Schaa wrote:
> > JFYI I already started to rework the existing scan code in mac80211
> > (software scan) to do something like background scanning:
> >
> > 1) notify current AP about leaving the channel
> > 2) scan one channel
>
> It might be useful to leave this "one" as a parameter to allow easy
> experiments with scanning more than one channel at a time to reduce
> latency.

Good point.

> Ideally, this--along the interval for background scans--could 
> be something that is dynamically changed based on the expected traffic
> pattern. Whenever there is lot of data traffic being (mostly
> successfully) transmitted, it would be beneficial not to jump to other
> channels as frequently or for as long a time. If there has not been any
> data transmission for some time, it may be more acceptable to scan more
> frequently and to remain away from the operational channel for longer
> periods of time. Though, we should also keep in mind that background
> scans are going to increase power consumption on otherwise inactive
> situation, so setting a suitable policy for this can get quite complex.

It might even be beneficial to cancel a currently active background scan once 
the TX queue is filling up and report the already gathered information to the 
user space.

Helmut
