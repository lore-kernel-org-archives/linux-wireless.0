Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 91-65-240-14-dynip.superkabel.de ([91.65.240.14]:54456 "EHLO
	charon.n2.diac24.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbXFMNZs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 09:25:48 -0400
Date: Wed, 13 Jun 2007 15:25:36 +0200
From: David Lamparter <lists@diac24.net>
To: Mark Powell <Mark.Powell@csr.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Lamparter <lists@diac24.net>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] {cfg,nl}80211 API
Message-ID: <20070613132536.GB5493@charon.n2.diac24.net>
References: <20070611230434.GA13221@charon.n2.diac24.net> <20070612131458.GA6411@charon.n2.diac24.net> <F3555D2D288C3C4CBA0001C074188F119F88C3@cameurexb01.EUROPE.ROOT.PRI> <200706120945.41154.flamingice@sourmilk.net> <F3555D2D288C3C4CBA0001C074188F119F8913@cameurexb01.EUROPE.ROOT.PRI>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <F3555D2D288C3C4CBA0001C074188F119F8913@cameurexb01.EUROPE.ROOT.PRI>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Shouldn't wpa_supplicant know when the connection is ready? 
> > It has support for dormant mode, so the link can be held down 
> > by userspace until it is ready. 
> > The driver shouldn't need to figure out when the link is 
> > ready to go up.
> 
> This is to do with the operation of the "Controlled Port" as specified
> by 802.1x, which is handled by the driver. When the key exchanges are
> complete and the link is secure, then data is allowed to flow. With
> wext, the driver has to guess when this state is reached, based on
> knowledge of how wpa_supplicant uses wext.

I don't know too much about WPA, so, er... is it possible for a device to
have a set of keys configured and still not be operational?

Basing operational state on a sequence of set-key operations is obviously
weird, but basing it on having a full set of keys might actually be right,
IF and only IF those two statements are equivalent, so - are they?

-David

P.S.: anyone got some WPA doc/spec pointer for me?

