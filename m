Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41640 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab1AYKMH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 05:12:07 -0500
Subject: Re: [PATCH v2 2/6] nl80211: Pass probe response data to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <AANLkTinJo7EV7zr=Z6oN3M2X3=gcv1W8G7cpbHPPNs=0@mail.gmail.com>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
	 <1295816579-28925-3-git-send-email-arik@wizery.com>
	 <1295868924.3639.2.camel@jlt3.sipsolutions.net>
	 <AANLkTinJo7EV7zr=Z6oN3M2X3=gcv1W8G7cpbHPPNs=0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 11:12:05 +0100
Message-ID: <1295950325.3650.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-24 at 22:47 +0200, Arik Nemtsov wrote:
> On Mon, Jan 24, 2011 at 13:35, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Sun, 2011-01-23 at 23:02 +0200, Arik Nemtsov wrote:
> >> Allow usermode to pass probe-response data. This data can be used as a
> >> template probe-response offloading.
> >
> > Why use a separate command for this, and not do it like the SSID? I also
> 
> Its only relevant to AP-mode (at least for now) so bss_conf didn't
> seem appropriate.
> Also since its a dynamically allocated buffer it should be protected by RCU.

But all that is unrelated to the nl80211 API, no? Also the SSID already
uses bss_conf too, and it's AP mode too...

> About compatibility - good point there. Currently the probe response
> template is set according to the beacon for compatibility. As for SSID
> - with the current wl12xx we'll set an empty SSID when a
> non-supporting hostapd is encountered. I'll fix that (in a v3). Other
> than that, we should be able to operate with either one configured.

Does that mean if you set an empty SSID it won't reply but pass them up?
Then you could implement the behaviour I just asked for ...

johannes

