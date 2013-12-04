Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46960 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab3LDJOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 04:14:31 -0500
Message-ID: <1386148462.4284.13.camel@jlt4.sipsolutions.net> (sfid-20131204_101437_441505_F640B008)
Subject: Re: [PATCH 4/4] nl80211: add VHT support for set_bitrate_mask
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Date: Wed, 04 Dec 2013 10:14:22 +0100
In-Reply-To: <CAFED-jkJ0d+AAmjusWXhFH5dutof7VSQkwqK+Ead1M8JUmhjVg@mail.gmail.com> (sfid-20131204_100834_380854_3EA7654F)
References: <1386060648-6020-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1386060648-6020-4-git-send-email-janusz.dziedzic@tieto.com>
	 <1386080659.4393.29.camel@jlt4.sipsolutions.net>
	 <CALhHN=q63LmZb7CvO=4sDWf70-O7_vc7T6jhU7gFQNtsH7PuDQ@mail.gmail.com>
	 <1386145635.4284.10.camel@jlt4.sipsolutions.net>
	 <CAFED-jkJ0d+AAmjusWXhFH5dutof7VSQkwqK+Ead1M8JUmhjVg@mail.gmail.com>
	 (sfid-20131204_100834_380854_3EA7654F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-12-04 at 10:08 +0100, Janusz Dziedzic wrote:

> Yes, and I added 8 bitmaps:
> 
> + u16 vht_mcs[IEEE80211_VHT_NSS_MAX];

But that was the internal API, inside the kernel.

> 80 bytes is because of format we will from user mode (80 available
> combinations for VHT mask).
> I decided for:
> >> 9 - NSS=1, MCS=9
> >> 10 - NSS=2, MCS=0
> >> 11 - NSS=2, MCS=1
> To be compatible with ht-mcs set.
> You mean better to send 8*u16 from user mode and do conversion in IW
> (currently we send 80 bytes and do conversion in nl80211, same as for
> HT)?

But HT MCS is specified that way, there are 77 MCSes in HT, which each
have implicit NSS etc. That's how the standard works for HT. For VHT,
the standard works completely differently.

So yes, I think sending 8 bitmaps from userspace would be much easier to
understand.

johannes

