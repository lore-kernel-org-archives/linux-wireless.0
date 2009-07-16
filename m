Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:20808 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455AbZGPQJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 12:09:35 -0400
Received: by qw-out-2122.google.com with SMTP id 8so82112qwh.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 09:09:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907161138.58874.helmut.schaa@gmail.com>
References: <200907161138.58874.helmut.schaa@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 16 Jul 2009 09:09:14 -0700
Message-ID: <43e72e890907160909t6bc5809ued28581e1a7a668f@mail.gmail.com>
Subject: Re: Further improvements to the software scan implementation
To: Helmut Schaa <helmut.schaa@googlemail.com>,
	David Quan <David.Quan@atheros.com>,
	Michael Green <Michael.Green@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding David Quan and Michael Green, my reply in-line below.

On Thu, Jul 16, 2009 at 2:38 AM, Helmut
Schaa<helmut.schaa@googlemail.com> wrote:
> Hi,
>
> as already discussed with Johannes we can further optimize the scan
> implementation by allowing (on an active channel) to send probes as
> soon as any other frame is received (and updated the NAV) instead of
> ever waiting 30ms.
>
> Another optimization I thought of while reading [1] would be to take the
> same approach as Intel in their ucode. If a frame is received while
> scanning a passive channel switch to active scan mode and send out probes.
> That should allow us to shorten the time needed to stay on that channel.
> Luis, do you think this is ok in regard to regulatory restrictions?

Good question. We already enable active scanning if a beacon is
received from an AP and are world roaming. We do this in mac80211
through a beacon regulatory hint to the wireless core --
regulatory_hint_found_beacon(). The assumption of the beacon
regulatory hint is that APs *must* be compliant, and some cards world
roam therefore only allowing passive scan on some channels, when you
receive a beacon from an AP on a non-DFS channel or channel 12-14 it
is safe to assume you can actively scan and beacon on that same
channel. Reason for the passive scan flag to exist is for a way to
enable some cards to world roam on some channels. Because all APs must
beacon and since we will lift this passive scan flag during an initial
scan I am inclined to believe we shouldn't bother with processing
other 802.11 frames. So in summary I'd suggest to not do this because:

1) We already have the beacons during an initial scan
2) We'd have to figure out a way to ensure the frame was indeed from an AP

  Luis

> Thanks,
> Helmut
>
> [1] http://sourceforge.net/mailarchive/forum.php?thread_name=200907061428.55840.jung%40ecos.de&forum_name=ipw3945-devel
>
