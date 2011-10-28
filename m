Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:53400 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab1J1NeN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 09:34:13 -0400
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Arend Van Spriel <arend@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2 13/12] cfg80211/mac80211: allow management TX to not wait for ACK
References: <20111021142322.229128720@sipsolutions.net>
	<1319743973.32221.4.camel@jlt3.sipsolutions.net>
	<400C43189542CE41BC0A5B252FC90136BC0E3753AA@SJEXCHCCR02.corp.ad.broadcom.com>
	<1319788880.3914.4.camel@jlt3.sipsolutions.net>
	<400C43189542CE41BC0A5B252FC90136BC0E37541B@SJEXCHCCR02.corp.ad.broadcom.com>
	<CAGXE3d9NiHgmE_ABc_red7MeNnhUGG+fOgbL19B9U3e9Fx9Vxw@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Fri, 28 Oct 2011 16:34:10 +0300
In-Reply-To: <CAGXE3d9NiHgmE_ABc_red7MeNnhUGG+fOgbL19B9U3e9Fx9Vxw@mail.gmail.com> (Helmut Schaa's message of "Fri\, 28 Oct 2011 11\:28\:03 +0200")
Message-ID: <877h3pb5pp.fsf@purkki.adurom.net> (sfid-20111028_153417_657892_CFE13E9E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa <helmut.schaa@googlemail.com> writes:

> The reason is the following: if you're running a mac80211 AP with multiple
> bssids, hostapd will answer to broadcast probe requests sent by STAs with
> one probe response per bssid (unicast of course). And since some clients
> stay only for a short amount of time on the scan-channel (a few ms) under
> some circumstances the probe responses aren't sent out yet before the
> scanning STA leaves the channel and thus retried till the maximum retry
> limit is reached. And these retries consume quite a lot of airtime. And to
> avoid this we just don't want to retry the probe responses in that case.

This is all good. But doesn't it also mean that this change increases
probability that the client doesn't receive the probe response, for
example due to interference where retransmission would help, and hence
the AP isn't included in the client's scan results?

-- 
Kalle Valo
