Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:32804 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754278Ab0DIIgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 04:36:43 -0400
Date: Fri, 9 Apr 2010 11:36:52 +0300
From: Jouni Malinen <j@w1.fi>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Any news regarding multicast rate configuration?
Message-ID: <20100409083651.GA3627@jm.kir.nu>
References: <282382.19639.qm@web51406.mail.re2.yahoo.com>
 <20100408194349.GA27848@jm.kir.nu>
 <195455.53971.qm@web51405.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <195455.53971.qm@web51405.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 08, 2010 at 01:07:36PM -0700, Joerg Pommnitz wrote:
> do you mean that I can't configure a separate rate
> for multicast frames? I thought that the rate bitmask
> was a way to tell the RC algorithm what rates to
> consider. Since multicast frames do not get acknowledged
> they are not subject to the automatic rate selection.

At least for now, there is no separate configuration option for
multicast frames, i.e., the same TX rate mask will apply to rate
selection for both unicast and multicast frames. Multicast frames are
subject to rate selection; the current mac80211 rate algorithms may not
do much in that area, though, apart from letting the lowest available
rate be selected. By changing which rates are enabled, you can change
that lowest rate..

> In fact, I'm perfectly happy to leave the rate selection
> for unicast frames in the capable hands of Minstrel, but
> I need something better than 1Mb/s for multicast. The
> lowest data rate just isn't enough for live video feeds.

Like I said in the previous mail, as long as you are fine dropping 1
Mbps from unicast rates, you can get higher rate for multicast..

> What I need is a way to tell mac80211 to use one specific
> basic rate for broadcast and multicast. 

Why would the currently available mechanism not work for you?

-- 
Jouni Malinen                                            PGP id EFC895FA
