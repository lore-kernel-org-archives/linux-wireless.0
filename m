Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41121 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932932AbbFPJPx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 05:15:53 -0400
Message-ID: <1434446150.2337.17.camel@sipsolutions.net> (sfid-20150616_111605_569723_75726173)
Subject: writing timestamps to outgoing packets
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev <netdev@vger.kernel.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 16 Jun 2015 11:15:50 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

For MA-USB (media-agnostic USB, but specifically we're working on doing
it over 802.11 wifi) there's a need to write a timestamp to outgoing
packets at a specific offset inside the packet.

Unfortunately, it's not that we have to write the timestamp of the
previous packet or similar which could be achieved with the existing
timestamp service, but the packet that's being sent.

We'll probably have to use LLC, so ideally we could use the LLC
framework (though - it seems to have some bugs - is anyone using it?),
but that obviously makes it difficult to pass enough information to the
low-level driver to enable the timestamping (which is done in
firmware/hardware.)

Does anyone have any thoughts? Should we try to mark the packet somehow?
But all ways I can find could possibly conflict with other markers. Or
perhaps we should add a generic "write timestamp to packet" framework?

I'm a bit surprised that nobody else has had this need before - or
perhaps they did and solved the problem in a different way?

johannes

