Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46747
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbXHBWiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 18:38:16 -0400
Date: Thu, 02 Aug 2007 15:38:16 -0700 (PDT)
Message-Id: <20070802.153816.98863127.davem@davemloft.net>
To: mb@bu3sch.de
Cc: dsd@gentoo.org, dwmw2@infradead.org, larry.finger@lwfinger.net,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	jbenc@suse.cz, flamingice@sourmilk.net
Subject: Re: mac80211 IPv6 problems
From: David Miller <davem@davemloft.net>
In-Reply-To: <200708030036.13317.mb@bu3sch.de>
References: <1186088678.2931.10.camel@pmac.infradead.org>
	<46B25B04.5020804@gentoo.org>
	<200708030036.13317.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Buesch <mb@bu3sch.de>
Date: Fri, 3 Aug 2007 00:36:12 +0200

> On Friday 03 August 2007, Daniel Drake wrote:
> > David Woodhouse wrote:
> > > My experience is that mac80211 is broken w.r.t IPv6 -- it receives its
> > > own packets. It would be suboptimal for me if the softmac version of
> > > bcm43xx were to go away before that got fixed.
> > 
> > This may be a stack-level issue. This is one of the issues holding back 
> > zd1211rw-mac80211 going into mainline: we have a report that 
> > zd1211rw-softmac works fine with IPv6 but mac80211 only works 
> > occasionally with the same device on the same system.
> > 
> > Does anyone have any ideas?
> 
> This is certainly an issue in the packet filtering of mac80211.

Another thing to always be mindful of with ipv6 is that it
uses multicast as part of it's normal operation.
