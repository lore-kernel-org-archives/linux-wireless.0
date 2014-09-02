Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55230 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbaIBMUu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 08:20:50 -0400
Message-ID: <1409660440.1808.17.camel@jlt4.sipsolutions.net> (sfid-20140902_142055_352612_D153360F)
Subject: truesize for pages shared between SKBs
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: Ido Yariv <ido@wizery.com>, Emmanuel Grumbach <egrumbach@gmail.com>
Date: Tue, 02 Sep 2014 14:20:40 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In our driver, we have 4k receive buffers, but usually ~1500 byte
packets.

How do other drivers handle this? We currently set up the truesize of
each SKB to be its size plus the 4k page size, but we see performance
improvements when we lie and pretend the truesize is just 4k/(# of
packets in the page), which is correct as long as the packets are all
pending in the stack since they share the page.

How do other drivers handle this? Should the truesize maybe be aware of
this kind of sharing? Should we just lie about it and risk that the
truesize is accounted erroneously if some but not all of the packets are
freed?

Thanks,
johannes

