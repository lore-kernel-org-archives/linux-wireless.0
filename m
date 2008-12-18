Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:41816 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206AbYLRHSs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 02:18:48 -0500
Date: Thu, 18 Dec 2008 09:18:33 +0200
From: Jouni Malinen <j@w1.fi>
To: Jouni Malinen <j@w1.fi>
Cc: Sujith <m.sujith@gmail.com>, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, mcgrof@gmail.com,
	jouni.malinen@atheros.com
Subject: Re: [RFC] Handle Channel Switch Announcement
Message-ID: <20081218071833.GA17064@jm.kir.nu> (sfid-20081218_081857_900900_C0270921)
References: <18761.4838.509784.281821@localhost.localdomain> <20081217162017.GA28712@jm.kir.nu> <18761.43079.702658.733757@localhost.localdomain> <20081218070508.GA15803@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081218070508.GA15803@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 18, 2008 at 09:05:08AM +0200, Jouni Malinen wrote:
> received a CSA may not be that good of an idea. Then again, channels
> that require radar detection should not really allow active scanning on
> them in the first place.

Just remembered one topic related to this that I was supposed to include
here.. We should really start looking at using passive scanning more in
some cases. The channel itself may not be completely restricted from
active scanning, but especially when roaming to a new regulatory domain,
it would be better to only use passive scanning until some life is
found (i.e., a Beacon is received) and only enable active scanning after
having learned which channels are allowed. This is actually a
requirement in 802.11-2007, too (see 9.8.1).

When receiving a CSA on a channel that requires DFS, but does not
enforce strict passive-scanning-only policy (should there be such
channels somewhere), it could be a good policy to drop that channel out
from the currently allowed active-scan-channels and only add it back if
passive scan find an AP Beaconing on the channel regardless of whether
this is strictly speaking required or not by the standard. This type of
dynamic mode changes for channels may need some work in mac80211, but it
would probably be a good idea to do it.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
