Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:50862 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964985AbbLOUga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2015 15:36:30 -0500
Date: Tue, 15 Dec 2015 15:36:26 -0500 (EST)
Message-Id: <20151215.153626.1500179484827859040.davem@davemloft.net> (sfid-20151215_213649_414809_71BD474D)
To: dvyukov@google.com
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller@googlegroups.com, edumazet@google.com, kcc@google.com,
	glider@google.com, sasha.levin@oracle.com
Subject: Re: Information leak in llcp_sock_bind/llcp_raw_sock_bind
From: David Miller <davem@davemloft.net>
In-Reply-To: <CACT4Y+bjSFyXZi1PKTUsT9PhAYvCGiGjRkOBRbUON0Pw7rJxGg@mail.gmail.com>
References: <CACT4Y+bjSFyXZi1PKTUsT9PhAYvCGiGjRkOBRbUON0Pw7rJxGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 15 Dec 2015 21:00:20 +0100

> The problem is that llcp_sock_bind/llcp_raw_sock_bind do not check
> sockaddr_len passed in, so they copy stack garbage from stack into the
> socket and then return it in getsockname.
> This can defeat ASLR, leak crypto keys, etc.

That's actually the first thing these functions do.

They completely clear out the on-stack llcp_addr, then they copy only
as much as the user gave them, being careful not to use more than
sizeof(llcp_addr).

	memset(&llcp_addr, 0, sizeof(llcp_addr));
	len = min_t(unsigned int, sizeof(llcp_addr), alen);
	memcpy(&llcp_addr, addr, len);

I don't see what the problem is, you'll need to be more specific.

Even wrt. llcp_sock->service_name, the code limits the string to
NFC_LLCP_MAX_SERVICE_NAME.
