Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:33269 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab1BBV3U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 16:29:20 -0500
Date: Wed, 2 Feb 2011 22:29:12 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] rt2x00: Add autowakeup timer for receiving beacons while
 in powersave mode
Message-ID: <20110202212912.GA28687@sig21.net>
References: <201101311600.39486.IvDoorn@gmail.com>
 <874o8mbaec.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <874o8mbaec.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 02, 2011 at 07:42:51PM +0200, Kalle Valo wrote:
> So the firmware/hardware doesn't have support for tracking and waking
> up for beacons? I didn't even know that such hardware exists :) Waking
> up for beacons from host sounds very inefficient and unrealiable. All
> the devices I have seen either do this in firmware or hardware due to
> time constraints. Even at76c50x-usb, which is ancient, does all this
> in firmware.

IMHO this is a bit exaggerated.  Given that the beacon interval
is typically ~100 msecs, and typical worst cast irq latencies
on Linux 2.6 are a few 100 usecs, we can sleep e.g. 90msecs
and wake up in time to catch the beacon with high probability, thus
saving 90% on PHY power.  Not perfect, but good enough, isn't it?


Johannes
