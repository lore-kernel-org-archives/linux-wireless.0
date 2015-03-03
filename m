Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54526 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbbCCIRH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 03:17:07 -0500
Message-ID: <1425370617.2450.3.camel@sipsolutions.net> (sfid-20150303_091728_901620_9B48410B)
Subject: Re: [PATCH net-next 13/14] wireless: Use eth_<foo>_addr instead of
 memset
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Mar 2015 09:16:57 +0100
In-Reply-To: <0c710456e4875ff00c1a9fcff9378ed15110dcd3.1425354528.git.joe@perches.com>
References: <cover.1425354527.git.joe@perches.com>
	 <0c710456e4875ff00c1a9fcff9378ed15110dcd3.1425354528.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-02 at 19:54 -0800, Joe Perches wrote:
> Use the built-in function instead of memset.

Please don't use <foo> in the title, especially not if the patch only
introduces usage of eth_zero_addr(). It's easier to look for in the
commit log without it.

Other than that, I guess I'll apply this, but I really wish there was a
way to distinguish more easily which of these require alignment and
which don't.

eth_zero_addr() doesn,t but is_zero_ether_addr() does. So does
ether_addr_copy(). Frankly, it's getting a bit confusing, so I can't
really fault anyone for using memset()/memcpy().

johannes

