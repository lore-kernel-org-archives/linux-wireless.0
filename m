Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:49218 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbYJYLZ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 07:25:27 -0400
Date: Sat, 25 Oct 2008 13:25:26 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
Message-ID: <20081025112526.GB12252@Chamillionaire.breakpoint.cc> (sfid-20081025_132532_864071_1BFA89F7)
References: <4902DEBB.3050205@hotmail.com> <1224926241.6695.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <1224926241.6695.1.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Johannes Berg | 2008-10-25 11:17:21 [+0200]:

>> [  277.190494] Kernel unaligned access at TPC[10129b68] zd_mac_rx+0x144/0x32c [zd1211rw]
>
>my best bet is this:
>
>        fc = *(__le16 *)buffer;
>
>could you try something with get_unaligned? Though if this is it,
>then ... We really need disassembly of the exact spot.
A few lines before that:
|         buffer += ZD_PLCP_HEADER_SIZE;

and ZD_PLCP_HEADER_SIZE is 5 so we end up unaligned, don't we?

>
>johannes

Sebastian
