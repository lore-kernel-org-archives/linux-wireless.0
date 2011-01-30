Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:35246 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236Ab1A3Shf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 13:37:35 -0500
Date: Sun, 30 Jan 2011 20:37:21 +0200
From: Jouni Malinen <j@w1.fi>
To: Arik Nemtsov <arik@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2 0/6] Probe-resp offloading support
Message-ID: <20110130183721.GA28252@jm.kir.nu>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
 <1295869283.3639.7.camel@jlt3.sipsolutions.net>
 <AANLkTi=cSdi_i=RBtcp_aLG92S3xdMvJEMSfVdqX=qAK@mail.gmail.com>
 <20110126140444.GA30373@jm.kir.nu>
 <AANLkTi=AWanc8+JK7hQnRMpPEC+2hK0aTn0xenru7Ryw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=AWanc8+JK7hQnRMpPEC+2hK0aTn0xenru7Ryw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 30, 2011 at 01:24:56PM +0200, Arik Nemtsov wrote:
> After discussing this with the wl12xx FW guys, it seems that:
> - WPS2 and P2P special cases are currently not handled in FW - the
> default template is always returned for probe requests
> - The AP currently always responds to a probe request
> - The AP currently never passes up probe requests

I'm not too surprised about the first two, but the last one is somewhat
unfortunate for WPS use in general.

> In light of this new info, this might be a possible solution:
> - Implement a capability flag for
> ap-supports-offloading-of-basic-probe-reqs. With "basic" I mean WPS1/2
> and P2P IEs are not included.
> - Hostapd will configure a probe-resp template only when it supports
> probe-resp offloading (currently when WPS and P2P are off) and the
> driver supports it (using the capability flag).
> - Support a "pass and and don't reply to probe requests" mode in FW
> (this will take some time to implement).

That sounds reasonable. Though, it would be useful to indicate the
no-probe-req-notifications or well, document that flag to mean that
Probe Request processing is pretty much black box with now visibility to
the host.

As far as the pass-don't-reply mode is concerned, how would that be
selected (once implemented)? Would that add a new capability flag and
configuration option, so that hostapd could decide to configure it if
the configuration is enabling WPS and not use it if WPS is disabled?

> For now the wl12xx driver must operate in a "compatibility" mode,
> since the FW doesn't support passing-up probe requests. When the
> probe-resp template is not available we will use the beacon template,
> as currently used now. There are currently no plans for intelligent
> filtering of probe requests in FW - its all or nothing.

OK.

> Should hostapd reply to probe requests when offloading is configured?
> This is a moot point for wl12xx since probe-requests are not passed
> up. Do you have a preference here?

So far, hostapd is prepared for the driver taking care of Probe Request
handling mainly in the case that all of MLME operations, i.e., including
authentication and association, are done in the firmware/driver. In this
case, there is a driver wrapper event (EVENT_RX_PROBE_REQ) that
indicates the received Probe Request frames for WPS processing without a
response coming back. If the Probe Request frame is indicated in a same
way as other management frames (monitor interface currently with
mac80211, but that is subject to change at some point), as response will
be sent. As such, this decision could be done in mac80211 (e.g., add a
new nl80211 event for notification-only-RX-probe-req which would be
mapped into EVENT_RX_PROBE_REQ).

Since there is not much extra processing needed for trying to generate
and transmit the Probe Response frames, I don't care much if the driver
then ends up dropping it in the offloading case. Though, I think I would
have slight preference on using the EVENT_RX_PROBE_REQ to avoid extra
processing.

-- 
Jouni Malinen                                            PGP id EFC895FA
