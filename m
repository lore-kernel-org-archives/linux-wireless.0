Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:32939 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1AZGfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 01:35:42 -0500
Received: by gwj20 with SMTP id 20so16842gwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 22:35:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295950241.3650.3.camel@jlt3.sipsolutions.net>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
 <1295869283.3639.7.camel@jlt3.sipsolutions.net> <AANLkTi=cSdi_i=RBtcp_aLG92S3xdMvJEMSfVdqX=qAK@mail.gmail.com>
 <1295950241.3650.3.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 26 Jan 2011 08:35:26 +0200
Message-ID: <AANLkTikKM3sz5Y=+BNh9z6u-RuhUB81Y9BWavFnjKH7s@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Probe-resp offloading support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 25, 2011 at 12:10, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2011-01-24 at 23:21 +0200, Arik Nemtsov wrote:
>
>> Well a wiphy flag won't do here. Probe requests may be filtered in
>> some modes (AP-mode) but needed in others (p2p?).
>> I think flexibility is a nice added bonus here. A FW can decide to
>> handle most standard probe-requests and simply not pass them up.
>> Others ("complicated" ones) it can pass up to hostapd and expect it to reply.
>>
>> The current patches leave this policy in the hands of the driver/fw.
>
> That is _very_ dangerous. If the user has older firmware that doesn't
> know about WSC2, how would the user know not to configure WSC2 in
> hostapd? That needs to be known to hostapd so it can verify this
> situation. For P2P, we already know whether or not P2P is supported, but
> that's rather vague in case there will ever be a revision of the P2P
> spec with say different IEs.

Well basically the FW should white-list probe-requests it knows about
and pass up all the rest.

>
> Additionally, a "regular AP" (not P2P, not WSC) would still want to
> reply to probe requests from WSC/P2P devices with the normal template.
>
> IMHO it would be smarter to rework the firmware to only reply to probe
> requests if the probe response is configured. Then, if WSC, P2P, or
> similar technologies are in use on the interface, hostapd can simply
> decide to not configure the probe response and have host-based
> processing. Would that be a change you could still make?

With the current set of patches the decision is left at the hands of
the driver/fw. Hostapd currently doesn't have a way of toggling
probe-resp offloading in the low level driver.
This kind of plumbing is not needed in case the FW handles what it can
and passes up unknown probe-requests.

Arik
