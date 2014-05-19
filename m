Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33927 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395AbaESQCi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 12:02:38 -0400
Message-ID: <1400515344.4273.19.camel@jlt4.sipsolutions.net> (sfid-20140519_180252_862822_CC4BE4F7)
Subject: Re: [RFC] mac80211: at76x50x_usb driver broken by commit 3afc216..
 and RX path involved in scan
From: Johannes Berg <johannes@sipsolutions.net>
To: andrea.merello@gmail.com
Cc: emmanuel.grumbach@intel.com,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	joerg.albert@gmx.de, Alex Stewart <alex@foogod.com>,
	n0_5p4m_p13453@hotmail.com, Pavel Roskin <proski@gnu.org>,
	agx@sigxcpu.org, Kalle Valo <kalle.valo@iki.fi>, sesmo@gmx.net,
	John Linville <linville@tuxdriver.com>
Date: Mon, 19 May 2014 18:02:24 +0200
In-Reply-To: <CAN8YU5OdpxQ0F7RMEFeQWC6PNzppHu6bDEt7Tv6dKntEUMy-9A@mail.gmail.com> (sfid-20140519_174304_515534_3F6FAD39)
References: <CAN8YU5Nh-FwrBWuCz-YArmHg9NSLqsS2aan_6edaVDg+i6018g@mail.gmail.com>
	 <1400509775.4273.8.camel@jlt4.sipsolutions.net>
	 <1400510950.4273.9.camel@jlt4.sipsolutions.net>
	 <CAN8YU5OdpxQ0F7RMEFeQWC6PNzppHu6bDEt7Tv6dKntEUMy-9A@mail.gmail.com>
	 (sfid-20140519_174304_515534_3F6FAD39)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-05-19 at 17:42 +0200, Andrea Merello wrote:

> About Johannes patch.. Looks good :) But I already tried to do almost
> the same thing in the at79 driver, but I failed, because despite
> setting the single channel and performing a bunch of HW scan (one for
> each ch), it happened that my HW did several full scans disregarding
> the channel setting.

Well, if it doesn't work we can go back to the mac80211 solution I
suppose. Although the better solution even then might be to at least
detect in the driver that we're in the scan, and then attempt to parse
the DS information in the driver, so that it works regardless of whether
mac80211 has both those long paths or not. That patch would also be
simpler.

johannes

