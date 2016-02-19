Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:59623 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992508AbcBSTsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 14:48:06 -0500
Date: Fri, 19 Feb 2016 21:39:36 +0200
From: Jouni Malinen <j@w1.fi>
To: J Mo <jmomo@jmomo.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wpa_supplicant bridging problems
Message-ID: <20160219193936.GA24116@w1.fi> (sfid-20160219_204810_635188_BD6444AA)
References: <56C3E95A.7080104@jmomo.net>
 <56C4340D.9000508@luceor.com>
 <56C445E2.1050904@jmomo.net>
 <56C545B3.2060902@jmomo.net>
 <56C567FD.7020004@jmomo.net>
 <56C69232.6080200@jmomo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56C69232.6080200@jmomo.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 18, 2016 at 07:55:30PM -0800, J Mo wrote:
> This was a bug already fixed in git. The Debian wpa_supplicant is
> old (2.3). Source right now is pre-2.6. I compiled my own and it
> works fine.

> I suspect this was fixed in git commit
> e6dd8196e5daf39e4204ef8ecd26dd50fdca6040, but there are two other
> commits which also look like they are related to bridging and EAPOL.

That is not really a fix for the real problem.. It is only a workaround
to avoid the quite unfortunate and already years old kernel regression..
While that workaround covers some cases, it has a cost (more CPU use)
and it is possible to come up with sequences that break even that
workaround. Unfortunately, I'm not aware of any robust way of working
around this from user space without significant CPU load increase.

This thread from 2013 discusses that root issue:
http://marc.info/?l=linux-wireless&m=136743495526905&w=2

Unfortunately, there is still no fix for this in the kernel.. There is a
proposed fix that is included in OpenWrt, but it is unclear how this
issue could be fixed properly.

-- 
Jouni Malinen                                            PGP id EFC895FA
