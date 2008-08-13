Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbYHMMA4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 08:00:56 -0400
Subject: Re: Pondering: how to improve mac80211 roaming ...
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <200808130852.15051.hs4233@mail.mn-solutions.de>
References: <200808120838.52888.hs4233@mail.mn-solutions.de>
	 <20080812082246.GD4981@jm.kir.nu>
	 <200808130852.15051.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 08:02:30 -0400
Message-Id: <1218628950.27171.7.camel@localhost.localdomain> (sfid-20080813_140059_720472_26EA48CA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-08-13 at 08:52 +0200, Holger Schurig wrote:
> > cfg80211 lacks a command for request new scans, so that could
> > also be an area that would benefit of improvements if the
> > current SIOCSIWSCAN WE ioctl does not provide all the
> > functionality needed for this (though, it may be more because
> > of SIOCSIWSCAN handler in mac80211 lacking support for many of
> > the options).
> 
> If cfg80211 get's a scan command, it should probably get more 
> than one command:
> 
> * command "do scan" with lot's of options, e.g. band, channels,
>   ESSID, active/passive
> 
> * a notification from mac80211->userspace "scan completed"
> 
> * command "get current scan list"
>   - this command should not return the equivalent of -EAGAIN
>   - always return the whole list, even if one process asked
>     a "do scan" with ESSID "MUH" and another process asked
>     a "do scan" with ESSID "BLAH" one second later
>   - filtering/sorting should be done in user-space

Yes; a scan list is a system resource, not per-process of course; the
driver should be adding the new results to it's internal scan cache and
timing out old results as appropriate.  And since the process that
requested the filtered scan obviously knows what filter options it was
requesting, it can certainly apply that filter itself.

That said, it would be useful to pass the requested scan options along
with the "scan completed" response.  Say process A just scans "ch1 +
ssid foo", and process B wants full scans.  If process B just listens
for scan events, and backs off a scan timer each time an event comes in,
it'll never ever get any results other than what process A requested.
If scan options were passed along with the "scan completed" event, then
process B could figure out that it needs more complete scan information
and trigger a scan by itself.  Right now with WEXT, we can't do this
AFAIK.

Dan

