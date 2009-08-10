Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:45175 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbZHJMwl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 08:52:41 -0400
Date: Mon, 10 Aug 2009 14:52:41 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: ath5k broken after suspend-to-ram
Message-ID: <20090810125241.GA6082@sig21.net>
References: <20090807215155.GA17043@sig21.net>
 <b6c5339f0908090906p3d29fdd2x8473dcc6df178167@mail.gmail.com>
 <20090809170401.GB16332@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090809170401.GB16332@sig21.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 09, 2009 at 07:04:01PM +0200, Johannes Stezenbach wrote:
> With the nl80211 driver everything works.

Although it might not be that important I though I should
report the following observations when using
wpa_supplicant with the nl80211 driver onn ath5k:

1. wpa_supplicant complains about "Could not configure driver
   to use managed mode" and "Failed to set interface wlan0 mode"
   (but it works anyway). This is Debian sid wpasupplicant_0.6.9-3.
   The error is from wpasupplicant-0.6.9/src/drivers/driver_nl80211.c
   where is sends the NL80211_CMD_SET_INTERFACE msg.

2. The first ifup after boot or ath5k module reload
   (modprobe ath5k -r; modprobe ath5k) is much faster
   than the second and subsequent ifup.  The first time
   it takes around 7 secs until "wpa_cli status" reports
   wpa_state=COMPLETED, the second time it takes around 25 secs.
 

Thanks
Johannes
