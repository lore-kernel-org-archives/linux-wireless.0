Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52804
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753524AbXGPVxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jul 2007 17:53:55 -0400
Date: Mon, 16 Jul 2007 14:53:58 -0700 (PDT)
Message-Id: <20070716.145358.35015496.davem@davemloft.net>
To: jbenc@suse.cz
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix GCC warning on 64bit platforms
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070716184653.355253bf@griffin.suse.cz>
References: <20070714.185935.18577806.davem@davemloft.net>
	<20070714.204116.23012949.davem@davemloft.net>
	<20070716184653.355253bf@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jiri Benc <jbenc@suse.cz>
Date: Mon, 16 Jul 2007 18:46:53 +0200

> net/mac80211/ieee80211.c: In function ieee80211_register_hw:
> net/mac80211/ieee80211.c:4989: warning: comparison of distinct pointer types lacks a cast
> 
> Fix by casting from size_t to unsigned as size of ieee80211_tx_status_rtap_hdr
> structure will never be greater than that.
> 
> Signed-off-by: Jiri Benc <jbenc@suse.cz>

The macro "max_t" exists for these kinds of situations, please
use it. :-)
