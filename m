Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43480
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753980AbYFCVbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 17:31:52 -0400
Date: Tue, 03 Jun 2008 12:05:15 -0700 (PDT)
Message-Id: <20080603.120515.193703574.davem@davemloft.net> (sfid-20080603_233158_309565_E994CC6D)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, kirill@shutemov.name
Subject: Re: [PATCH] wireless.h: improve userland include-ability
From: David Miller <davem@davemloft.net>
In-Reply-To: <1212515497-21578-1-git-send-email-linville@tuxdriver.com>
References: <1212515497-21578-1-git-send-email-linville@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue,  3 Jun 2008 13:51:37 -0400

> From: Kirill A. Shutemov <kirill@shutemov.name>
> 
> This patch partially reverts commit 2218228392080f0ca2fc2974604e79f57b12c436
> ("Make linux/wireless.h be able to compile") while still making it
> easier to include wireless.h in userland apps.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

I not thrilled about this patch.

This means the user has to figure out what include file to add
to get IFNAMSIZ and things like that which wireless.h needs.

That is non-intuitive and magic.  These headers should be entirely
self-contained so that if you include linux/wireless.h it should
just work and there should be no dependencies not handlind by
wireless.h doing the necessary includes.

+/* This header is used in user-space, therefore need to be sanitised
+ * for that purpose. Those includes are usually not compatible with glibc.
+ * To know which includes to use in user-space, check iwlib.h. */

Yeah, go check so me magic userspace tool header to see what magic is
needed just to include a core networking header file correctly.

No, thanks.
