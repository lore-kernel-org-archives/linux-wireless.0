Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18439 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3FENad (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 09:30:33 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	"Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v8] cfg80211: P2P find phase offload
Date: Wed, 5 Jun 2013 16:30:29 +0300
Message-ID: <1894431.CPHELQbCIP@lx-vladimir> (sfid-20130605_153036_996563_651ED03A)
In-Reply-To: <1370418780.8920.19.camel@jlt4.sipsolutions.net>
References: <8887AA04B7EC49479420AE48C5F94A930EF6C0AA@NASANEXD02D.na.qualcomm.com> <2109265.XIVW7kjjZK@lx-vladimir> <1370418780.8920.19.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, June 05, 2013 09:53:00 AM Johannes Berg wrote:
> > When reporting probes, driver/firmware may do its best to filter out
> > probes that would not be replied with probe-resp accordingly to the
> > P2P rules for active device configuration.
> 
> This I think should be more specific. "[W]ould not be replied" is
> clearly one step, but in an environment where you actually want to
> offload the P2P probe responses that is pretty much useless. I'd rather
> say something like:
> 
> ---
> When probe response offload it supported, the device should not report
> probe requests to the host that it already responded to. It must report
> (and therefore not respond to) probe requests that indicate the sending
> device is in active PBC mode (specifically, <...add more details...>).
> It may also drop invalid or malformed probe requests or ones that would
> not be replied to for other reasons.
> ---

> 
> I think this would be a reasonable tradeoff. It means that if a probe
> request is actually reported, wpa_supplicant must reply to it, and we
> don't have to get into the business of having to decide whether or not
> it needs to respond.
> 
> Alternatively, we could specify that the device _must_ respond if
> offload is supported, and then report it.

I like this alternative. Except, reporting is accordingly to the rx filter.
wpa_s may be not interesting in probes at all, or want only ones with PBC.
If device answer probes in firmware, this would reduce CPU wake-ups.

> 
> However, we need to clearly specify this so that we don't get two
> responses, one from the device and one from wpa_s. If there's no way to
> specify this, we need to introduce a "reply already sent" flag into the
> frame reporting.

Said above translates to all-or-nothing approach w.r.t. responses:

- If device indicate probe-resp offload, it must reply all probes, supplicant
must not send probe-resp.
- If device does not indicate probe-resp offload, it should never send
probe-resp by itself; it should report all matching probes
and supplicant will generate probe-resp.

Regarding what probes to report, I'd specify relaxed requirements
for the driver:

- in non-offload case, driver must report all matching probes
(but may just report all, and wpa_s will filter)
- in offload case, must report matching probes if rx filter says so. It is not
neccessary to report all probes that device replied to.

I don't want to force firmware or driver to parse probes to detect PBC; if we
got frame to the host, from power perspective there is no much difference who
will filter it - driver or wpa_s; and wpa_s already do this parsing.

For PBC - can one specify "probes with PBC" using existing rx filter mechanism?

Also, I feel this explanation get large, it deserves separate comment block,
it is overkill for start_p2p_find comment. Maybe do it in another patch?

Thanks, Vladimir
