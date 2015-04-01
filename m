Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:46351 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751030AbbDAG2u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 02:28:50 -0400
Message-ID: <1427869720.10642.6.camel@coelho.fi> (sfid-20150401_082854_371310_B0453F00)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend@broadcom.com>, Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 01 Apr 2015 09:28:40 +0300
In-Reply-To: <1427811715.2057.24.camel@sipsolutions.net>
References: <55105DA7.3040703@broadcom.com>
	 <1427811715.2057.24.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: broadcast ssid in scheduled scan
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-31 at 16:21 +0200, Johannes Berg wrote:
> On Mon, 2015-03-23 at 19:38 +0100, Arend van Spriel wrote:
> > Johannes, Jouni,
> > 
> > I have noticed that under some circumstances wpa_supplicant initiates a 
> > scheduled scan with broadcast ssid. This is something our firmware can 
> > not do so could this be avoided? Maybe by adding a feature flag for it. 
> 
> I guess this would be difficult to do since you'd basically have to
> "remove" support for normal scheduled scan (that assumes this ability)
> and add support for another scheduled scan (that doesn't assume it) in
> nl80211 ... just to be compatible with older implementations of
> wpa_supplicant etc.
> 
> I do wonder why the firmware cannot do this though - there's no
> fundamental reason the 0-length SSID is all that different from a 1-byte
> one?

Is the problem in having a 0-length SSID in the probe_reqs or is it in
having it in the matches (i.e. it doesn't support "pass all")? The
latter makes a bit more sense, since filtering on a 0-length SSID, if
not treated specially, would return nothing (since it would never match,
unless an AP does send an SSID IE with 0-length).

It doesn't make much sense to have a "match all" scheduled scan though,
unless wpa_s needs to find more SSIDs than what the driver supports.
Even in that case, it wouldn't make much difference than using a normal
scan periodically...

--
Luca.

