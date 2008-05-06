Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41017
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754471AbYEFUkw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 16:40:52 -0400
Date: Tue, 06 May 2008 13:40:47 -0700 (PDT)
Message-Id: <20080506.134047.86330538.davem@davemloft.net> (sfid-20080506_224007_225595_A4529600)
To: xemul@openvz.org
Cc: netdev@axxeo.de, johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4][MAC80211]: Fix GFP_KERNEL allocation under read
 lock.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4820997E.1070305@openvz.org>
References: <48206F4C.5050105@openvz.org>
	<200805061840.37713.netdev@axxeo.de>
	<4820997E.1070305@openvz.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pavel Emelyanov <xemul@openvz.org>
Date: Tue, 06 May 2008 21:46:38 +0400

> I do not quite like doing so. Since this relies on fact that kfree bears
> NULL pointers. But if we ever switch from kmalloc to kmem_cache_alloc,
> this will result in an oops.

The whole reason we made kfree allow NULL points is so that
checks for it would be ommitted at kfree calls sides, whether
they be direct or indirect.

Adding the check for some theoretical-or-not future change is
rediculious.
