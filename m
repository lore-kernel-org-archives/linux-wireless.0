Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60287 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0LPMQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 07:16:39 -0500
Subject: Re: BUG: while bridging Ethernet and wireless device:
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTikYvBspVmAZ0DCMXJ-3WxkotwX+n8NpTtM+97_i@mail.gmail.com>
References: <AANLkTikYvBspVmAZ0DCMXJ-3WxkotwX+n8NpTtM+97_i@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 13:16:37 +0100
Message-ID: <1292501797.3612.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-16 at 14:11 +0200, Tomas Winkler wrote:

> Dec 15 14:36:41 User-PC kernel: [175576.120452] kernel BUG at include/linux/skbuff.h:1178!

> Dec 15 14:36:41 User-PC kernel: [175576.123193] EIP is at br_multicast_rcv+0xc95/0xe1c [bridge]

So as I said to Tomas in private before -- it kinda looks like something
here is not handling paged SKBs correctly? But I would imaging that
causing more issues, unless there was a bug here that made bridging
require more data in the skb header than we put in there right now -- it
can end up being empty I believe.

Thing is, I looked at the code and it seemed fine.

johannes

