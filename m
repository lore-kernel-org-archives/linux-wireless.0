Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:56698 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbYESGfQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 02:35:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] mac80211: rewrite fragmentation code
Date: Mon, 19 May 2008 13:08:13 +1000
Cc: herbert@gondor.apana.org.au, mb@bu3sch.de,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, ron.rindjunsky@intel.com, tomasw@gmail.com,
	ivdoorn@gmail.com, peter.p.waskiewicz.jr@intel.com
References: <200805161201.48835.rusty@rustcorp.com.au> <200805162032.48469.rusty@rustcorp.com.au> <20080516.124039.253626477.davem@davemloft.net>
In-Reply-To: <20080516.124039.253626477.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805191308.14548.rusty@rustcorp.com.au> (sfid-20080519_083532_241435_045DEA96)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 17 May 2008 05:40:39 David Miller wrote:
> My description describes how I want the mid-layer queue to disappear
> entirely.  Queueing would be done by the driver only.

Ok, the more I ponder this, the more I like it.  It has a very nice side 
benefit for virtio_net: we can xmit a whole bunch of packets before notifying 
the host.  Real NICs might gain similarly.

The bit I can't see is what to do about qdisc if the driver manages its own 
queue(s).  Leave the qdisc as currently in place and have the driver call 
dev_dequeue_skb() (or some wrapper) directly?  Modulo locking issues, that 
should be a fairly simple change.

Thanks,
Rusty.
