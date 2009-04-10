Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:49520 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764880AbZDJRph (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 13:45:37 -0400
Subject: Re: [ath5k-devel] BUG in wiphy_update_regulatory when loading
 ath5k (on latest git)
From: Pavel Roskin <proski@gnu.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <49DF714F.9070600@tuffmail.co.uk>
References: <49DF6216.8040303@tuffmail.co.uk>
	 <49DF714F.9070600@tuffmail.co.uk>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 13:45:33 -0400
Message-Id: <1239385533.24621.11.camel@mj> (sfid-20090410_194541_657028_CF52B3E0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-04-10 at 17:18 +0100, Alan Jenkins wrote:

> [   65.062652] BUG: unable to handle kernel NULL pointer dereference at
> 00000004
...
> [   65.063330] Code: b8 da 17 e0 83 c0 04 e8 92 f9 ff ff 84 c0 75 2a 8b 
> 55 d4 8b 42 28 85 c0 74 0c 83 c0 04 e8 7c f9 ff ff 84 c0 75 14 a1 bc da 
> 17 e0 <83> 78 04 03 74 66 8b 4d d4 80 79 08 00 74 5d a1 e0 d2 17 e0 48

"<83> 78 04 03" is "cmpl   $0x3,0x4(%rax)", which I can find in
disassemly of reg_is_world_roaming(), which was inlined into
wiphy_update_regulatory().

0x3 is almost certainly NL80211_REGDOM_SET_BY_COUNTRY_IE in
reg_is_world_roaming().  %rax must be 0, so we have a read at address
0x4.

last_request must be NULL.  The "initiator" field is at offset 4, which
is consistent with the assembly.

Thus, wiphy_update_regulatory() is called before last_request was
assigned a value.

last_request only seems to get a value in __regulatory_hint(), which is
ultimately called by reg_todo(), a work handler.

-- 
Regards,
Pavel Roskin
