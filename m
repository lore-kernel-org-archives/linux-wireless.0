Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sj-iport-2.cisco.com ([171.71.176.71]:48907 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761054AbYGRRKY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 13:10:24 -0400
From: Roland Dreier <rdreier@cisco.com>
To: hadi@cyberus.ca
Cc: Patrick McHardy <kaber@trash.net>,
	David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in RCU.
References: <487F4327.1000107@trash.net> <1216301732.4726.26.camel@localhost>
	<487F50EC.80008@trash.net>
	<20080717.152447.89672084.davem@davemloft.net>
	<487FDA67.30902@trash.net> <1216386624.4833.94.camel@localhost>
Date: Fri, 18 Jul 2008 10:10:21 -0700
In-Reply-To: <1216386624.4833.94.camel@localhost> (jamal's message of "Fri, 18
	Jul 2008 09:10:24 -0400")
Message-ID: <adaljzz6ruq.fsf@cisco.com> (sfid-20080718_191037_439223_827FADD3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 > The question is whether the packets sitting on the fifo qdisc are being
 > sorted fairly when congestion kicks in. Remember there is still a single
 > wire still even on multiple rings;->

This is definitely true, but it is good to keep in mind that in the near
future we will start to see things look a little like multiple "virtual
wires."  This is because of new ethernet standards like per-priority
pause, which makes it possible that one hardware ring on a NIC can
transmit while another ring is paused (possibly because of congestion
far off in the network).

 - R.
