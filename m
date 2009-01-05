Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47625 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbZAEOmD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 09:42:03 -0500
Message-ID: <49621C36.70602@openwrt.org> (sfid-20090105_154211_331477_95C2AC99)
Date: Mon, 05 Jan 2009 15:41:58 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
References: <20090104164649.GV496@one.firstfloor.org> <200901041736.47650.mb@bu3sch.de> <20090104174123.GW496@one.firstfloor.org> <49615465.4090604@lwfinger.net> <20090105025302.GF496@one.firstfloor.org> <49618497.50809@lwfinger.net> <20090105050248.GG496@one.firstfloor.org> <496193A6.3040608@lwfinger.net> <20090105054830.GJ496@one.firstfloor.org> <49620BE5.9030507@openwrt.org> <20090105142343.GS496@one.firstfloor.org>
In-Reply-To: <20090105142343.GS496@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andi Kleen wrote:
> With Larry's patch reverted. Rate is still at 1Mbit/s of course.
> This is all only with rtl8180, I didn't try everything on the realtek
> card too. 
> 
> -Andi
> 
> rate     throughput  ewma prob   this prob  this succ/attempt   success    attempts
> TtP  1         0.9       99.2      100.0          1(  1)         23          32
>      2         0.0        0.0        0.0          0(  0)          0           0
>      5.5       0.0        0.0        0.0          0(  0)          0           1
>     11         0.0        0.0        0.0          0(  0)          0           0
>      6         0.0        0.0        0.0          0(  0)          0           0
>      9         0.0        0.0        0.0          0(  0)          0           0
>     12         0.0        0.0        0.0          0(  0)          0           0
>     18         0.0        0.0        0.0          0(  0)          0           0
>     24         0.0        0.0        0.0          0(  0)          0           0
>     36         0.0        0.0        0.0          0(  0)          0           0
>     48         0.0        0.0        0.0          0(  0)          0           0
>     54         0.0        0.0        0.0          0(  0)          0           0
> 
> Total packet count::    ideal 25      lookaround 1
OK, that confirms that Larry's patch was wrong - at least the dump
looks consistent now.
Probably the RT2561 and the RTL8180 simply have a lower Tx power and
thus can't get the signal through the walls as easily as the zd1211rw.
If you still think that it's a rate control problem, please try all
the rates individually and see if one of them works better.

- Felix
