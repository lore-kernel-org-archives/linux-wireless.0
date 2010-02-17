Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:42658 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757595Ab0BQWwN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 17:52:13 -0500
Subject: Re: [PATCH v3] mac80211: deprecate RX status noise
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Benoit PAPILLAULT <benoit.papillault@free.fr>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e891002171429j7f47c86bqd4374bf07b8979de@mail.gmail.com>
References: <1266437114.23447.0.camel@jlt3.sipsolutions.net>
	 <1266438137.23447.1.camel@jlt3.sipsolutions.net>
	 <1266438446.23447.2.camel@jlt3.sipsolutions.net>  <4B7C561C.70702@free.fr>
	 <43e72e891002171429j7f47c86bqd4374bf07b8979de@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 17 Feb 2010 17:51:58 -0500
Message-Id: <1266447118.12365.21.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-02-17 at 14:29 -0800, Luis R. Rodriguez wrote:

> > Being per packet or global, I'm not an RF engineer to say what's best, but
> > even if it is global, "last_noise" would still be useful as "global noise
> > when the last packets was received from this node".
> 
> If anything it should be per center freq.

The noise value will be missed.  It's useful to see the signal to noise
ratio.  I have little trust to the absolute noise values, but I know
that the connection is bad if signal is just 3 dBm above the noise
measured by the same card with the same antenna on the same channel. 

Maybe it would be better to remove per-packet noise only when the "next
generation noise" is implemented?  It could be a batch of patches.

-- 
Regards,
Pavel Roskin
