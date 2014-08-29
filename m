Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([193.35.52.29]:49457 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaH2ITH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 04:19:07 -0400
Date: Fri, 29 Aug 2014 10:19:02 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Support DTPC IE (from Cisco Client eXtensions)
Message-ID: <20140829081902.GB21763@sesse.net> (sfid-20140829_101912_845564_EFF9C44E)
References: <20140824103728.GA2938@sesse.net>
 <E1XLZxt-0002h9-Um@pannekake.samfundet.no>
 <1409211818.2505.12.camel@jlt4.sipsolutions.net>
 <20140828083738.GA19530@sesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20140828083738.GA19530@sesse.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2014 at 10:37:38AM +0200, Steinar H. Gunderson wrote:
> We should honor its request, just as we honor it when it comes through
> 802.11h or 802.11d.

I've been running with this a few days now, and I've noticed that while the
patch works fine, it is not entirely complete.

The problem is that sometimes the AP can send _both_ 802.11h and the DTPC IE;
the 802.11h IE seemingly because there's some kind of regulatory pressure
(ie., “something detected on your channel, you have to go down”), and the
DTPC IE due to the configured lower transmit power. In this case, 802.11h
says 21 (24 - 3) dBm and DTPC 7 dBm, and we pick the former.

In this situation, my current patch lets 802.11h override (on the grounds that
it's an official standard, and that it's required for regulatory compliance),
but it should probably do a min() of the two advertised power levels instead.
Does this sound reasonable? I'll be sending a patch later today.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
