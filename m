Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38937
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753574AbXHHKRz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 06:17:55 -0400
Date: Wed, 08 Aug 2007 03:17:55 -0700 (PDT)
Message-Id: <20070808.031755.91441405.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, andy@warmcat.com,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] allow device to stop packet mirror behaviour
From: David Miller <davem@davemloft.net>
In-Reply-To: <1186564441.11717.5.camel@johannes.berg>
References: <1186475155.4067.17.camel@johannes.berg>
	<20070807.180607.116354128.davem@davemloft.net>
	<1186564441.11717.5.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 08 Aug 2007 11:14:01 +0200

> On Tue, 2007-08-07 at 18:06 -0700, David Miller wrote:
> > From: Johannes Berg <johannes@sipsolutions.net>
> > Date: Tue, 07 Aug 2007 10:25:55 +0200
> > 
> > > The only way to solve this problem therefore seems to be to suppress the
> > > mirroring out of the packet by dev_queue_xmit_nit(). The patch below
> > > does that by way of adding a new netdev flag.
> > 
> > Multicast packets also get looped back in a similar manner in the ipv4
> > code.  These will also be seen twice due to this issue.
> 
> I don't think these other places are of any interest because of the
> radiotap+802.11 framing on the devices where it is relevant to us; you
> can't actually add an IP route to a monitor interface as far as I can
> tell.

Then I don't understand your problem.  If they are specific 802.11
protocol packets, the radio stack is in a much better situation to
filter out things like this.
