Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33720 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118AbaESOta (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 10:49:30 -0400
Message-ID: <1400510950.4273.9.camel@jlt4.sipsolutions.net> (sfid-20140519_164938_360796_E0B7530F)
Subject: Re: [RFC] mac80211: at76x50x_usb driver broken by commit 3afc216..
 and RX path involved in scan
From: Johannes Berg <johannes@sipsolutions.net>
To: andrea.merello@gmail.com
Cc: emmanuel.grumbach@intel.com,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	joerg.albert@gmx.de, alex@foogod.com, n0_5p4m_p13453@hotmail.com,
	proski@gnu.org, agx@sigxcpu.org, kalle.valo@iki.fi, sesmo@gmx.net,
	John Linville <linville@tuxdriver.com>
Date: Mon, 19 May 2014 16:49:10 +0200
In-Reply-To: <1400509775.4273.8.camel@jlt4.sipsolutions.net> (sfid-20140519_163001_496941_4CFA01FA)
References: <CAN8YU5Nh-FwrBWuCz-YArmHg9NSLqsS2aan_6edaVDg+i6018g@mail.gmail.com>
	 (sfid-20140517_174307_788362_95E52488) <1400509775.4273.8.camel@jlt4.sipsolutions.net>
	 (sfid-20140519_163001_496941_4CFA01FA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-05-19 at 16:29 +0200, Johannes Berg wrote:

> Since there's no "rx channel" information in this driver, but there does
> seem to be a (currently unused) channel field in the scan request, maybe
> we can make the driver request up to 14 single-channel scans (rather
> than a single full scan), and then it can keep track of the current
> channel in software and assign the pointer properly.
> 
> This would also allow implementing regulatory for scan properly, which
> seems like a good idea as well.

Maybe something like this works?

http://p.sipsolutions.net/fa75caf17c54747a.txt

johannes

