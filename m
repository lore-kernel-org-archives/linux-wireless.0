Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:38862 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbYHLMjd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2008 08:39:33 -0400
From: Helmut Schaa <hschaa@suse.de>
To: Jouni Malinen <j@w1.fi>
Subject: Re: Pondering: how to improve mac80211 roaming ...
Date: Tue, 12 Aug 2008 14:40:23 +0200
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
References: <200808120838.52888.hs4233@mail.mn-solutions.de> <20080812082246.GD4981@jm.kir.nu>
In-Reply-To: <20080812082246.GD4981@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808121440.24098.hschaa@suse.de> (sfid-20080812_143938_250274_99224B1E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 12. August 2008 schrieb Jouni Malinen:
> On Tue, Aug 12, 2008 at 08:38:52AM +0200, Holger Schurig wrote:

> > In-kernel or in-userspace?   --- or hybrid?
> > -------------------------------------------
> 
> > So I think I'd opt to a hybrid approach. Userspace uses cfg80211
> > to configure some roaming threshold to mac80211. mac80211 would
> > gain AP-is-about-to-fail detection and, if it detects this, it
> > would signal via cfg80211 (is this possible?) to user-space that
> > it should now roam.
> 
> I would also think that this is the most useful design. You could
> already do background scanning in the kernel (triggered by whatever) and
> just sen SIOCSIWSCAN WE event to notify user space (e.g.,
> wpa_supplicant) of availability of new scan results. This is something
> that madwifi for example is already doing.

JFYI I already started to rework the existing scan code in mac80211
(software scan) to do something like background scanning:

1) notify current AP about leaving the channel
2) scan one channel
3) get back to the operating channel
4) notify current AP about being back
5) back to 1) if more channels need to be scanned

The code basically works but is not cleaned up though and not yet triggered
by any event (just used the current start scan event to initiate a background
scan).

Maybe it is reasonable to use background scanning if the interface is
currently associated with an AP and regular scanning in all other cases.

Helmut
