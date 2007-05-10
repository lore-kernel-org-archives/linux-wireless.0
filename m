Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-39.dex002.intermedia.net ([64.78.21.124]:9807 "EHLO
	dhost002-39.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755424AbXEJPsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 11:48:43 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Thu, 10 May 2007 08:48:59 -0700
To: Jiri Benc <jbenc@suse.cz>
Cc: James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Specifing rate control algorithm?
Message-ID: <20070510154859.GA24712@devicescape.com>
References: <464253CE.2030504@linux.intel.com> <20070510132756.2ca660a0@midnight.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070510132756.2ca660a0@midnight.suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2007 at 01:27:56PM +0200, Jiri Benc wrote:

> A driver is not supposed to set rate control. Under no circumstances.
> If you know about a bug in default rate control algorithm, fix it and
> send a patch. Otherwise, fix your driver.

I don't think I would fully agree with this. Sure, the default rate
control algorithm should work with all drivers, but it is quite possible
that some rate control algorithms do not work with all drivers and some
combinations are much better than the "default algorithm". In other
words, I think there is benefit in drivers being able to "suggest" a
rate control algorithm to be used and there is not much point having to
force the user space to do this selection for the initial rate control
algorithm. Sure, this should still be something that can be changed from
user space, but the defaults selection could as well be the best
available combination.

Some hardware designs provide extra functionality that can be used to
improve rate control algorithm and as such, they may benefit greatly
from a specific rate control implementation. Because of this, there was
originally possibility for allowing the rate control algorithms to know
the driver name and use this to select whether to allow the algorithm to
be used with the driver. The request here was for a bit different way of
doing this, but anyway, I see value in this whichever way it would be
implemented.

-- 
Jouni Malinen                                            PGP id EFC895FA
