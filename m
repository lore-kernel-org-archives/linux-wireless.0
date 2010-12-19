Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43146 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab0LSJHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Dec 2010 04:07:32 -0500
MIME-Version: 1.0
In-Reply-To: <1292501797.3612.12.camel@jlt3.sipsolutions.net>
References: <AANLkTikYvBspVmAZ0DCMXJ-3WxkotwX+n8NpTtM+97_i@mail.gmail.com>
	<1292501797.3612.12.camel@jlt3.sipsolutions.net>
Date: Sun, 19 Dec 2010 11:07:29 +0200
Message-ID: <AANLkTinb77yjqvX5WrN2hTCk=Oiqc5Bti=FWZ=RcBgPk@mail.gmail.com>
Subject: Re: BUG: while bridging Ethernet and wireless device:
From: Tomas Winkler <tomasw@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 16, 2010 at 2:16 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-12-16 at 14:11 +0200, Tomas Winkler wrote:
>
>> Dec 15 14:36:41 User-PC kernel: [175576.120452] kernel BUG at include/linux/skbuff.h:1178!
>
>> Dec 15 14:36:41 User-PC kernel: [175576.123193] EIP is at br_multicast_rcv+0xc95/0xe1c [bridge]
>
> So as I said to Tomas in private before -- it kinda looks like something
> here is not handling paged SKBs correctly? But I would imaging that
> causing more issues, unless there was a bug here that made bridging
> require more data in the skb header than we put in there right now -- it
> can end up being empty I believe.
>
> Thing is, I looked at the code and it seemed fine.
>
> johannes
>
opened bug https://bugzilla.kernel.org/show_bug.cgi?id=25202

>
