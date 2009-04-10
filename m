Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:2280 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759886AbZDJUVJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 16:21:09 -0400
Subject: Re: [ath5k-devel] BUG in wiphy_update_regulatory when loading
 ath5k (on latest git)
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090410181157.GC5750@tesla>
References: <49DF6216.8040303@tuffmail.co.uk>
	 <49DF714F.9070600@tuffmail.co.uk> <1239385533.24621.11.camel@mj>
	 <20090410181157.GC5750@tesla>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 16:21:04 -0400
Message-Id: <1239394864.3673.2.camel@mj> (sfid-20090410_222114_797661_B827FF1E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-04-10 at 11:11 -0700, Luis R. Rodriguez wrote:

> Thanks pavel, please try this patch:

I checked ath5k, ath9k and b43, and in all cases last_request is
initialized before it's used by the code changed in your patch.  In
fact, last_request is initialized before there is any message from ath5k
or another driver.

I wonder if "module: create a request_module_nowait()" reverted in
wireless-testing was causing the initialization to go in a different
order.  I tried reapplying it and still could not reproduce the problem
(that is, last_request is not NULL in wiphy_update_regulatory).  But
maybe I'm just lucky.

Anyway, your patch makes the code safer and doesn't break anything for
me.

-- 
Regards,
Pavel Roskin
