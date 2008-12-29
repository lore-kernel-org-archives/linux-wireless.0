Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31898 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbYL2SnQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 13:43:16 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2008 10:43:16 -0800
Date: Mon, 29 Dec 2008 10:43:01 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Pavel Roskin <proski@gnu.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Michael Buesch <mb@bu3sch.de>, Dan E <trg_info@mailhaven.com>,
	Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Hostapd doesn't like crda
Message-ID: <20081229184301.GW5944@tesla> (sfid-20081229_194334_626627_3C9FA8CD)
References: <200812272208.20153.mb@bu3sch.de> <200812291128.00512.mb@bu3sch.de> <20081229155613.GR5944@tesla> <200812291704.28163.mb@bu3sch.de> <20081229161828.GT5944@tesla> <1230575256.22537.3.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1230575256.22537.3.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 29, 2008 at 10:27:36AM -0800, Pavel Roskin wrote:
> On Mon, 2008-12-29 at 08:18 -0800, Luis R. Rodriguez wrote:
> > > I think this wouldn't be hackish, but do we actually _know_ when crda has finished
> > > uploading regulatory information? Does it do it all in one step?
> >
> > It would go in through another nl80211 command, NL80211_CMD_SET_REG. nl80211 eventually
> > calls set_regdom() and this will set it, so if all goes well we can remove the timer
> > at the end if its active (other means can call CRDA like for 802.11d or the wireless core
> > upon initialization).
> 
> Can we have a command to _get_ regulatory settings?  I think it would be
> useful.  Then hostapd could wait until the correct settings are active.
> If it doesn't happen after some time, hostapd should exit with an error.

Yeah, I've been meaning to get to that but haven't yet, we should have
a nl80211 command which lets userspace get the entire rd structure, and maybe
some info from last_request.

> It would be even better if hostapd could wait for an event notifying of
> the regulatory settings change.

Whatever works. But as can be seen this just requires a bit of work.

  Luis
