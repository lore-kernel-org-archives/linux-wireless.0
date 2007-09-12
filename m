Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:54411
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756628AbXILNUx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2007 09:20:53 -0400
Date: Wed, 12 Sep 2007 05:34:11 -0700 (PDT)
Message-Id: <20070912.053411.21914920.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: herbert@gondor.apana.org.au, satyam@infradead.org, flo@rfc822.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, michal.k.k.piotrowski@gmail.com,
	ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com
Subject: Re: BUG: scheduling while atomic: ifconfig/0x00000002/4170
From: David Miller <davem@davemloft.net>
In-Reply-To: <1189091995.28781.99.camel@johannes.berg>
References: <alpine.LFD.0.999.0709060923340.26804@enigma.security.iitk.ac.in>
	<20070906082301.GB21929@gondor.apana.org.au>
	<1189091995.28781.99.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 06 Sep 2007 17:19:55 +0200

> 
> Oh btw. Can we stick a might_sleep() into dev_close() *before* the test
> whether the device is up? That way, we'd have seen the bug, but
> apparently nobody before Florian ever did a 'ip link set wmaster0 down'
> while the other interfaces were still open.

I've added this to net-2.6.24
