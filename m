Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:43953 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbZAEOJw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 09:09:52 -0500
Date: Mon, 5 Jan 2009 15:23:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Andi Kleen <andi@firstfloor.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
Message-ID: <20090105142343.GS496@one.firstfloor.org> (sfid-20090105_150954_758966_64FE00C6)
References: <20090104164649.GV496@one.firstfloor.org> <200901041736.47650.mb@bu3sch.de> <20090104174123.GW496@one.firstfloor.org> <49615465.4090604@lwfinger.net> <20090105025302.GF496@one.firstfloor.org> <49618497.50809@lwfinger.net> <20090105050248.GG496@one.firstfloor.org> <496193A6.3040608@lwfinger.net> <20090105054830.GJ496@one.firstfloor.org> <49620BE5.9030507@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49620BE5.9030507@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 05, 2009 at 02:32:21PM +0100, Felix Fietkau wrote:
> It looks like mac80211 is not getting proper feedback from the tx
> status of the device. Is this with the patch that Larry suggested?
> If so, please revert that patch and post an updated version of the
> same stats.

With Larry's patch reverted. Rate is still at 1Mbit/s of course.
This is all only with rtl8180, I didn't try everything on the realtek
card too. 

-Andi

rate     throughput  ewma prob   this prob  this succ/attempt   success    attempts
TtP  1         0.9       99.2      100.0          1(  1)         23          32
     2         0.0        0.0        0.0          0(  0)          0           0
     5.5       0.0        0.0        0.0          0(  0)          0           1
    11         0.0        0.0        0.0          0(  0)          0           0
     6         0.0        0.0        0.0          0(  0)          0           0
     9         0.0        0.0        0.0          0(  0)          0           0
    12         0.0        0.0        0.0          0(  0)          0           0
    18         0.0        0.0        0.0          0(  0)          0           0
    24         0.0        0.0        0.0          0(  0)          0           0
    36         0.0        0.0        0.0          0(  0)          0           0
    48         0.0        0.0        0.0          0(  0)          0           0
    54         0.0        0.0        0.0          0(  0)          0           0

Total packet count::    ideal 25      lookaround 1



-- 
ak@linux.intel.com
