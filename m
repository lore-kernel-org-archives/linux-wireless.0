Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43691
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750943AbXLYFSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 00:18:46 -0500
Date: Mon, 24 Dec 2007 21:18:45 -0800 (PST)
Message-Id: <20071224.211845.192499191.davem@davemloft.net> (sfid-20071225_051853_201789_A772A2E4)
To: joe@perches.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [WEXT 3/12]: Extract standard call iw_point handling into
 seperate function.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1198308172.4895.11.camel@localhost>
References: <20071221.205407.165162566.davem@davemloft.net>
	<1198308172.4895.11.camel@localhost>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joe Perches <joe@perches.com>
Date: Fri, 21 Dec 2007 23:22:52 -0800

> On Fri, 2007-12-21 at 20:54 -0800, David Miller wrote:
> > [WEXT]: Extract standard call iw_point handling into seperate function.
> 
> This potentially does copy_from_user twice,
> first to the stack, second to a kmalloc'ed area.
> Perhaps it's better to kmalloc first and copy once?

I'm preserving existing behavior in these changes,
feel free to make these kinds of improvements as
a follow-on changeset.
