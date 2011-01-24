Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:45851 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab1AXUsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 15:48:14 -0500
Received: by yib18 with SMTP id 18so1438033yib.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 12:48:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295868924.3639.2.camel@jlt3.sipsolutions.net>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
 <1295816579-28925-3-git-send-email-arik@wizery.com> <1295868924.3639.2.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 24 Jan 2011 22:47:58 +0200
Message-ID: <AANLkTinJo7EV7zr=Z6oN3M2X3=gcv1W8G7cpbHPPNs=0@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] nl80211: Pass probe response data to drivers
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 24, 2011 at 13:35, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2011-01-23 at 23:02 +0200, Arik Nemtsov wrote:
>> Allow usermode to pass probe-response data. This data can be used as a
>> template probe-response offloading.
>
> Why use a separate command for this, and not do it like the SSID? I also

Its only relevant to AP-mode (at least for now) so bss_conf didn't
seem appropriate.
Also since its a dynamically allocated buffer it should be protected by RCU.

> was under the impression you wanted both (which is somewhat redundant
> since you can parse the SSID out of the probe response), so shouldn't
> they both be required (or none, for compatibility)?

The FW requires both the real SSID and a probe-response template.
Passing the SSID separately looked cleaner.

About compatibility - good point there. Currently the probe response
template is set according to the beacon for compatibility. As for SSID
- with the current wl12xx we'll set an empty SSID when a
non-supporting hostapd is encountered. I'll fix that (in a v3). Other
than that, we should be able to operate with either one configured.

>
> Also, should cfg80211 pretend it knows the SSID/probe response when
> userspace didn't set it (from the beacon) so that mac80211 or the
> low-level drivers don't need to worry?

Well in the current patches sent to hostapd the probe response is
always set with the beacon, so this shouldn't happen in AP mode.
Its not supported in these patches for other modes..

Regards,
Arik
