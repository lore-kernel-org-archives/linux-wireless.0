Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47159 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab1AZIo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 03:44:59 -0500
Subject: Re: [PATCH v2 0/6] Probe-resp offloading support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <AANLkTikKM3sz5Y=+BNh9z6u-RuhUB81Y9BWavFnjKH7s@mail.gmail.com>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
	 <1295869283.3639.7.camel@jlt3.sipsolutions.net>
	 <AANLkTi=cSdi_i=RBtcp_aLG92S3xdMvJEMSfVdqX=qAK@mail.gmail.com>
	 <1295950241.3650.3.camel@jlt3.sipsolutions.net>
	 <AANLkTikKM3sz5Y=+BNh9z6u-RuhUB81Y9BWavFnjKH7s@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 09:44:57 +0100
Message-ID: <1296031497.3635.27.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[let me take both your emails at once]

> > That is _very_ dangerous. If the user has older firmware that doesn't
> > know about WSC2, how would the user know not to configure WSC2 in
> > hostapd? That needs to be known to hostapd so it can verify this
> > situation. For P2P, we already know whether or not P2P is supported, but
> > that's rather vague in case there will ever be a revision of the P2P
> > spec with say different IEs.
> 
> Well basically the FW should white-list probe-requests it knows about
> and pass up all the rest.

Indeed. But we need to know what things the firmware knows about, so we
can disable additional functionality automatically.

> > IMHO it would be smarter to rework the firmware to only reply to probe
> > requests if the probe response is configured. Then, if WSC, P2P, or
> > similar technologies are in use on the interface, hostapd can simply
> > decide to not configure the probe response and have host-based
> > processing. Would that be a change you could still make?
> 
> With the current set of patches the decision is left at the hands of
> the driver/fw. Hostapd currently doesn't have a way of toggling
> probe-resp offloading in the low level driver.
> This kind of plumbing is not needed in case the FW handles what it can
> and passes up unknown probe-requests.

Well, it could trivially have this functionality by simply not setting
the SSID/probe response frame -- older hostapd would "automatically" not
use this feature, and you'd even have a good upgrade path -- the feature
is only used for new hostapd, and then only when hostapd knows that it
is possible to use the feature.

> Its also conceivable that an old driver/fw won't work when some
> protocol is changed/updated, even if hostapd supports it.
> I'm not sure the probe-resp will be the culprit here..

Indeed. But in such cases, we've dealt with it. But with a simple update
like for example WSC 3.0 (which I don't think is being planned yet, but
may eventually be written) your approach would certainly require a
firmware update. I think that's a bit undesirable, but I'm not saying
that you _need_ to change the firmware. I'm merely recommending that if
the firmware doesn't know the SSID, it will pass up all probe requests.
It has to have the "pass up" functionality already for P2P/WSC2, so that
could trivially be extended to pass up when the driver sets a certain
bit to request it always.


It's been pointed out to me that maybe I'm not always communicating
things effectively -- so let me try to write a summary of the entire
thing again:

The way you're implementing this feature right now _relies_ on the
firmware to do the right thing for all protocols. However,
hostapd/wpa_supplicant have no way of knowing what protocols the
firmware knows about, and they will almost certainly be extended for
more protocols in the future. This I don't want to see -- I want you to
advertise in nl80211 what protocols (including their versions) the
firmware knows about, so that a future hostapd can automatically disable
new protocols that the firmware doesn't know about.

I'm also _recommending_ that you change the firmware implementation to
guard against that and be more backward compatible: allow the driver to
set a bit meaning "pass up all probe requests". Yes, that will destroy
host power savings obtained by this feature if enabled, but will allow
hostapd/wpa_s to implement new features and one could then actually at
least test, if not use, them with the older device. You could also get
rid of the beacon parsing code etc. and simply require that a modern
hostapd that implements the offload be used for maximum power saving.

johannes


