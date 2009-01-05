Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:45198 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303AbZAENcc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 08:32:32 -0500
Message-ID: <49620BE5.9030507@openwrt.org> (sfid-20090105_143250_425175_4F48B4C4)
Date: Mon, 05 Jan 2009 14:32:21 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
References: <20090104164649.GV496@one.firstfloor.org> <200901041736.47650.mb@bu3sch.de> <20090104174123.GW496@one.firstfloor.org> <49615465.4090604@lwfinger.net> <20090105025302.GF496@one.firstfloor.org> <49618497.50809@lwfinger.net> <20090105050248.GG496@one.firstfloor.org> <496193A6.3040608@lwfinger.net> <20090105054830.GJ496@one.firstfloor.org>
In-Reply-To: <20090105054830.GJ496@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andi Kleen wrote:
> Lots of zeroes.
> 
> -Andi
> 
> rate     throughput  ewma prob   this prob  this succ/attempt   success    attempts
> TtP  1         0.0        0.0        0.0          1(  0)          0           0
>      2         0.0        0.0        0.0          0(  0)          0           0
>      5.5       0.0        0.0        0.0          0(  0)          0           0
>     11         0.0        0.0        0.0          0(  0)          0           0
>      6         0.0        0.0        0.0          0(  0)          0           0
>      9         0.0        0.0        0.0          0(  0)          0           0
>     12         0.0        0.0        0.0          0(  0)          0           0
>     18         0.0        0.0        0.0          0(  0)          0           0
>     24         0.0        0.0        0.0          0(  0)          0           0
>     36         0.0        0.0        0.0          0(  0)          0           0
>     48         0.0        0.0        0.0          0(  0)          0           0
>     54         0.0        0.0        0.0          0(  0)          0           2
> 
> Total packet count::    ideal 46      lookaround 2
It looks like mac80211 is not getting proper feedback from the tx
status of the device. Is this with the patch that Larry suggested?
If so, please revert that patch and post an updated version of the
same stats.
The info->status.rates[0].count is supposed to contain the number of
tx attempts, not the number of retransmissions (at least that's what
minstrel expects).

- Felix
