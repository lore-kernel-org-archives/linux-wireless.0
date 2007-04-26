Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:52521 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbXDZQxH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 12:53:07 -0400
Date: Thu, 26 Apr 2007 09:53:04 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 9/9] net_device: dont include wext bits if not required
Message-ID: <20070426165304.GC22576@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070424180732.371620000@sipsolutions.net> <20070424180850.595757000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070424180850.595757000@sipsolutions.net>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 24, 2007 at 08:07:41PM +0200, Johannes Berg wrote:
> This patch makes the wext bits in struct net_device depend on
> CONFIG_WIRELESS_EXT.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

	I personally would not do that. Having conditional fields in
"struct net_device" is very bad, it's a sure way to crash on modules
in some cases. If I remember well, Jeff Garzik has been fighting those
over the years.

	Jean
