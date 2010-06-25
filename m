Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:31593 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab0FYQBm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 12:01:42 -0400
Received: by fg-out-1718.google.com with SMTP id d23so322925fga.1
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jun 2010 09:01:40 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt2x00 & mac80211: correct usage of ieee80211_beacon_get_tim?
Date: Fri, 25 Jun 2010 18:01:06 +0200
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006241521.47623.helmut.schaa@googlemail.com> <1277394714.3870.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1277394714.3870.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006251801.06209.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 24 Juni 2010 schrieb Johannes Berg:
>  b) You need to get a new beacon frame from mac80211 only when it
>     changes. You can do this from set_tim(). HOWEVER: since you're not
>     getting a new one from mac80211 all the time anyway, you NEED to
>     have the driver or firmware overwrite the DTIM count, like b43's
>     firmware for example will do.

And the broad- and multicast buffering also needs to be done in the driver
(when the fw/hw cannot handle it) as mac80211 uses its own DTIM count for
deciding when to "release" buffered frames to the driver.

Helmut
