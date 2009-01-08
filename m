Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f29.google.com ([209.85.218.29]:47495 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbZAHMIt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 07:08:49 -0500
Received: by bwz10 with SMTP id 10so6544841bwz.13
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2009 04:08:46 -0800 (PST)
To: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH 12/14] mac80211: 802.11w - Optional software CCMP for management frames
Date: Thu, 8 Jan 2009 13:08:21 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Dan Williams <dcbw@redhat.com>
References: <20090107112346.369581673@atheros.com> <200901081057.46495.helmut.schaa@gmail.com> <20090108104822.GA12480@jm.kir.nu>
In-Reply-To: <20090108104822.GA12480@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901081308.23046.helmut.schaa@gmail.com> (sfid-20090108_130855_272442_CBAB2CE3)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 8. Januar 2009 schrieb Jouni Malinen:
> On Thu, Jan 08, 2009 at 10:57:45AM +0100, Helmut Schaa wrote:
> 
> > Jouni, what do you think about extending wpa_supplicant to allow mutliple
> > drivers to be set on the commandline (-Dnl80211,wext). The supplicant would
> > then try to register the first driver and only if that fails it takes the next
> > one (e.g. try nl80211 first and if that fails use wext). That way NM could
> > use nl80211 for drivers that support nl80211 (mainly mac80211-drivers) and
> > wext for the other drivers by passing "-Dnl80211,wext" to the supplicant.
> 
> Well, that could be done inside wpa_supplicant, but more or less the
> same effect should already be doable by NM trying to first add the
> interface with nl80211 as the driver interface and if that fails, fall
> back to wext.

True. However, other consumers of wpa_supplicant (e.g. Yast in SUSE) could
also benefit from this feature if implemented inside the supplicant. But as
I wrote, this was just a quick thought on how to make the transition from
wext to nl80211 smoother.

Helmut
