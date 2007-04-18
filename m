Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35638
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992707AbXDRVJ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2007 17:09:56 -0400
Date: Wed, 18 Apr 2007 14:09:56 -0700 (PDT)
Message-Id: <20070418.140956.116355415.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	flamingice@sourmilk.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wext: allow wext users without rtnl
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070418140451.075370fc@freekitty>
References: <1176825010.3902.28.camel@johannes.berg>
	<20070418140451.075370fc@freekitty>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Wed, 18 Apr 2007 14:04:51 -0700

> On Tue, 17 Apr 2007 17:50:10 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > This patch modifies wext adding a flag that allows drivers to specify that
> > they do not wish their wext calls made under rtnl. The default is to still
> > acquire the rtnl.
> > 
> > Warning: a device reference is held for the new no_locking API,
> > therefore it is not safe to call unregister_netdev on the passed device!
> > 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > 
> >
> 
> NACK Conditional locking is bad design.
> Either lock or not, make up your mind and fix the devices.

It is also wrong because all entities in the kernel assume
that network configuration changes all occur under the RTNL
therefore it must be held consistently everywhere.

I don't know what kind of deadlock or other issues are being
worked around here, but you'll have to find another way.
