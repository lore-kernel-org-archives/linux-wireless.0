Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab2GHJfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 05:35:13 -0400
Message-ID: <1341740110.4987.4.camel@jlt3.sipsolutions.net> (sfid-20120708_113517_982087_4B27C3C9)
Subject: Re: [PATCH 7/8] wl18xx: don't send static global struct to FW
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, arik@wizery.com
Date: Sun, 08 Jul 2012 11:35:10 +0200
In-Reply-To: <1341732211-25871-8-git-send-email-coelho@ti.com> (sfid-20120708_092401_300367_EF4BD9AD)
References: <1341732211-25871-1-git-send-email-coelho@ti.com>
	 <1341732211-25871-8-git-send-email-coelho@ti.com>
	 (sfid-20120708_092401_300367_EF4BD9AD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So the subject is wrong since "&priv->conf.phy" can hardly be "static
global", but 

> We get DMA alignment trouble if the beginning of the struct is
> unaligned. Allocate memory and send it to FW.

If this is all about alignment, and

> +	params = kzalloc(sizeof(*params), GFP_KERNEL);

kzalloc (which is pointless -- use kmemdup) alignment is sufficient,
then most likely you could just put "__aligned(4)" or something on the
conf.phy struct member and not allocate memory at all?

johannes

