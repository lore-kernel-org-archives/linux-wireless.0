Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37429 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3FKMMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 08:12:30 -0400
Message-ID: <1370952746.8356.30.camel@jlt4.sipsolutions.net> (sfid-20130611_141233_500619_F400D0A7)
Subject: Re: [PATCH v8] cfg80211: P2P find phase offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	"Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>
Date: Tue, 11 Jun 2013 14:12:26 +0200
In-Reply-To: <1894431.CPHELQbCIP@lx-vladimir>
References: <8887AA04B7EC49479420AE48C5F94A930EF6C0AA@NASANEXD02D.na.qualcomm.com>
	 <2109265.XIVW7kjjZK@lx-vladimir>
	 <1370418780.8920.19.camel@jlt4.sipsolutions.net>
	 <1894431.CPHELQbCIP@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > ---
> > When probe response offload it supported, the device should not report
> > probe requests to the host that it already responded to. It must report
> > (and therefore not respond to) probe requests that indicate the sending
> > device is in active PBC mode (specifically, <...add more details...>).
> > It may also drop invalid or malformed probe requests or ones that would
> > not be replied to for other reasons.
> > ---
> 
> > 
> > I think this would be a reasonable tradeoff. It means that if a probe
> > request is actually reported, wpa_supplicant must reply to it, and we
> > don't have to get into the business of having to decide whether or not
> > it needs to respond.
> > 
> > Alternatively, we could specify that the device _must_ respond if
> > offload is supported, and then report it.
> 
> I like this alternative. Except, reporting is accordingly to the rx filter.
> wpa_s may be not interesting in probes at all, or want only ones with PBC.
> If device answer probes in firmware, this would reduce CPU wake-ups.

Well, wpa_s is always going to be interested, and it can't really
specify in the subscription filter that it only wants PBC ones. The
filters aren't expressive enough for that.

This isn't really my favourite alternative because it means the device
can't just "chicken out" and treat this as a best effort thing, it means
that it always has to reply. I fear that for some devices this might
mean having to reply in software in certain circumstances, which seems
like a bad idea.

> > However, we need to clearly specify this so that we don't get two
> > responses, one from the device and one from wpa_s. If there's no way to
> > specify this, we need to introduce a "reply already sent" flag into the
> > frame reporting.
> 
> Said above translates to all-or-nothing approach w.r.t. responses:
> 
> - If device indicate probe-resp offload, it must reply all probes, supplicant
> must not send probe-resp.
> - If device does not indicate probe-resp offload, it should never send
> probe-resp by itself; it should report all matching probes
> and supplicant will generate probe-resp.

Right. I guess I can live with this, though see above.

> Regarding what probes to report, I'd specify relaxed requirements
> for the driver:
> 
> - in non-offload case, driver must report all matching probes
> (but may just report all, and wpa_s will filter)
> - in offload case, must report matching probes if rx filter says so. It is not
> neccessary to report all probes that device replied to.

see above -- the filters aren't expressive enough to allow specifying "I
want PBC". For probe requests, the filter is going to be all or nothing,
so this won't really do anything useful.

> I don't want to force firmware or driver to parse probes to detect PBC; if we
> got frame to the host, from power perspective there is no much difference who
> will filter it - driver or wpa_s; and wpa_s already do this parsing.

Firmware should parse it, obviously.

> For PBC - can one specify "probes with PBC" using existing rx filter mechanism?

No.

> Also, I feel this explanation get large, it deserves separate comment block,
> it is overkill for start_p2p_find comment. Maybe do it in another patch?

I think we need to nail this down before we merge the API. I have a
feeling we may end up having to implement the third alternative (report
whether a response was sent or not)

johannes

