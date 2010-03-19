Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41658 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab0CSG73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 02:59:29 -0400
Received: by bwz1 with SMTP id 1so2705148bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 18 Mar 2010 23:59:28 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCHv3 0/2] mac80211: cfg80211: Roam trigger support
References: <1268830877-5162-1-git-send-email-juuso.oikarinen@nokia.com>
	<20100317132236.GC2990@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 19 Mar 2010 08:59:25 +0200
In-Reply-To: <20100317132236.GC2990@tuxdriver.com> (John W. Linville's message of "Wed\, 17 Mar 2010 09\:22\:36 -0400")
Message-ID: <87aau4dcfm.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> On Wed, Mar 17, 2010 at 03:01:15PM +0200, Juuso Oikarinen wrote:
>> To implement good performance WLAN roaming, it is not sufficient to start
>> scanning for other available AP's only after the currently serving association
>> is lost.
>> 
>> The entity controlling the roaming will need to get indication of a
>> deteriorating WLAN connection in order to start preparing for roaming already
>> before the serving association is lost. This way, it can roam to a better AP
>> perhaps even before the serving association becomes too bad in quality.

[...]

> Any idea what other hardware (besides libertas) supports this
> concept?

I myself only know that wl1251 and wl1271 have this. But I wouldn't be
surprised if recent Intel designs also support it. It's a quite useful
feature, I would say that it's even a must-have feature for power
consumption critical devices.

And even if hardware wouldn't support this, having a host-based
implementation host would make it easier for wpa_supplicant.

> Do you anticipate adding a host-based implementation to mac80211?

I think we need a support for this, otherwise testing is next to
impossible because of small number of wl1271 and wl1251 upstream
users. I would prefer to have the host-based implementation right from
the start.

> Is RSSI really a useful enough indicator for this function?

Yes, it actually is. I implemented a similar hack for Nokia N900 which
is now in use by real customers. I just had to use WE custom events
due to project schedule constraints.

But I'm sure in the future we use different attributes for this, for
example retransmissions.

> Will applications actually use it?

The idea is that wpa_supplicant will listen to these events, and will
enable or disable backround scan (ie. scanning for new APs when
associated) based on information received from the events. When the
connection to the AP is good enough, it can disable background scan
which makes it possible to save power and also get rid of latency
introduced by the background scan.

I haven't seen any implementation for wpa_supplicant yet, but we have
talked about that few times during the last two years.

-- 
Kalle Valo
