Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1DFHIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 03:08:32 -0400
Subject: RE: [PATCH 1/2] mwifiex: return success in set_default_key for
 WPA/WPA2
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Jouni Malinen <j@w1.fi>
In-Reply-To: <477F20668A386D41ADCC57781B1F704307FA911F91@SC-VEXCH1.marvell.com>
References: <1301708207-16265-1-git-send-email-bzhao@marvell.com>
	 <1301817775.3984.3.camel@jlt3.sipsolutions.net>
	 <1301819826.3984.9.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F704307FA911ED9@SC-VEXCH1.marvell.com>
	 <1302029584.4968.6.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F704307FA911F91@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 09:08:28 +0200
Message-ID: <1302073708.3811.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-05 at 16:22 -0700, Bing Zhao wrote:

> > > WPA: Installing PTK to the driver.
> > > WPA: RSC - hexdump(len=6): 00 00 00 00 00 00
> > > wpa_driver_nl80211_set_key: ifindex=12 alg=2 addr=0x80a7168 key_idx=0 set_tx=1 seq_len=6 key_len=32
> > >    addr=00:1b:2f:55:79:7e

> > What happens if you just reject the set_default_key and return -EINVAL
> > instead of 0?
> 
> wpa_supplicant disconnects if we return -EINVAL in set_default_key handler.
> 
> WPA: Installing PTK to the driver.
> WPA: RSC - hexdump(len=6): 00 00 00 00 00 00
> wpa_driver_nl80211_set_key: ifindex=3 alg=2 addr=0x9f6eef8 key_idx=0 set_tx=1 seq_len=6 key_len=32
>    addr=00:50:43:21:07:f8
> nl80211: set_key default failed; err=-22 Invalid argument)
> WPA: Failed to set PTK to the driver (alg=2 keylen=32 bssid=00:50:43:21:07:f8)
> wpa_driver_nl80211_disconnect

Ok. In the meantime, Jouni kinda convinced me that returning 0 is fine
since we only ever TX to the AP, and that key will already be used for
that, so let's go with the patch for now -- I'd still like to figure out
why wpa_s is even requesting this, but that doesn't need to be on you.

johannes

