Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43672
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752420Ab0IVU5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 16:57:18 -0400
Date: Wed, 22 Sep 2010 13:57:37 -0700 (PDT)
Message-Id: <20100922.135737.70200377.davem@davemloft.net>
To: chunkeey@googlemail.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2010-09-21
From: David Miller <davem@davemloft.net>
In-Reply-To: <201009222246.31687.chunkeey@googlemail.com>
References: <201009222054.05469.chunkeey@googlemail.com>
	<20100922.121902.71115228.davem@davemloft.net>
	<201009222246.31687.chunkeey@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Christian Lamparter <chunkeey@googlemail.com>
Date: Wed, 22 Sep 2010 22:46:30 +0200

> But the driver can try to minimizes the access to unaligned elements,
> by using temporary variables (so the value needs to be accessed only
> once). In fact that's already done, the only room for improvement
> would be in carl9170_tx_prepare (temporary u16 for mac_control,
> u8 super_misc, u8 rate_info).

I think you're going for %20 improvement when there's a %100 one
sitting right under your nose. :-)

You know these things will always be aligned properly, so why not just
declare this "u16 + 2 u8" thing as a proper endiannized "u32", load
that, and mask out the parts that you need.

And any struct that has only u32 and larger objects need not have
any __packed attribute at all.

