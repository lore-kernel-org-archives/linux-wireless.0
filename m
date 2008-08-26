Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:2095 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbYHZFF3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2008 01:05:29 -0400
Date: Tue, 26 Aug 2008 08:05:16 +0300
From: Martin Michlmayr <tbm@cyrius.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: ath5k: bad udelay call, build failure on ARM
Message-ID: <20080826050516.GB5474@deprecation.cyrius.com> (sfid-20080826_070548_842435_F4FE163F)
References: <20080825115715.GA13506@deprecation.cyrius.com> <20080825190811.GC17297@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080825190811.GC17297@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* John W. Linville <linville@tuxdriver.com> [2008-08-25 15:08]:
> There are "udelay(2300)" calls in phy.c and hw.c.  How important is
> that exact number?  Could those be replaced by mdelay(3) instead?
> 
> Of course, looking in include/linux/delay.h, mdelay(3) may still
> translate to __bad_udelay on arm.

mdelay(3) compiles on ARM, so replacing the udelay(2300) with
mdelay(3) might be an option. (I don't have the hardware to test
though.)
-- 
Martin Michlmayr
http://www.cyrius.com/
