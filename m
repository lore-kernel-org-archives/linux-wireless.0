Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab0JLM4a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 08:56:30 -0400
Subject: Re: [PATCH v3 3/4] wl1271: Allocate TX descriptors more efficiently
From: Johannes Berg <johannes@sipsolutions.net>
To: Ido Yariv <ido@wizery.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1286887752-19321-4-git-send-email-ido@wizery.com>
References: <1286887752-19321-1-git-send-email-ido@wizery.com>
	 <1286887752-19321-4-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 14:56:28 +0200
Message-ID: <1286888188.3753.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-12 at 14:49 +0200, Ido Yariv wrote:

> +	id = find_first_zero_bit(wl->tx_frames_map, ACX_TX_DESCRIPTORS);
> +	if (id >= ACX_TX_DESCRIPTORS)
> +		return -EBUSY;
> +
> +	set_bit(id, wl->tx_frames_map);
> +	wl->tx_frames[id] = skb;
> +	wl->tx_frames_cnt++;

This is all under some lock, right? (If that isn't the case, it's racy)
Therefore, you need not use atomic bitops which will be fairly
expensive...

Have you actually measured this? It seems that it con't have a huge
effect, and the atomic bitops you use now might even negate it.

> +	if (test_and_clear_bit(id, wl->tx_frames_map)) {

There too.

johannes

