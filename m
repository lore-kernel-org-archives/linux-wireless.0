Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:3095 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbXLVHXB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 02:23:01 -0500
Subject: Re: [WEXT 3/12]: Extract standard call iw_point handling into
	seperate function.
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20071221.205407.165162566.davem@davemloft.net>
References: <20071221.205407.165162566.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 23:22:52 -0800
Message-Id: <1198308172.4895.11.camel@localhost> (sfid-20071222_072307_797534_65B386F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-12-21 at 20:54 -0800, David Miller wrote:
> [WEXT]: Extract standard call iw_point handling into seperate function.

This potentially does copy_from_user twice,
first to the stack, second to a kmalloc'ed area.
Perhaps it's better to kmalloc first and copy once?



