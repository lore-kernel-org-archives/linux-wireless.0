Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:31555 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759493Ab0JZKSZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 06:18:25 -0400
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id o9QAINT6030051
	for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 13:18:23 +0300
Subject: Re: [PATCH] wl1271: Fix RX path stall
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1287998669-27209-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1287998669-27209-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 13:18:10 +0300
Message-ID: <1288088290.27698.0.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-25 at 11:24 +0200, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> The wl1271_rx function loops through packets in an aggregated buffer. Each
> packet in the buffer is handled by a call to wl1271_rx_handle_data, which will
> fail if skb memory allocation fails or production mode is enabled. These
> failures currently prevent the rx counters to be incremented, thus causing the
> rx loop to run forever.
> 
> Fix this by ignoring error codes reported wl1271_rx_handle_data function.
> This essentially means that frames will be dropped in production mode, which
> is the intetion, and frames will be dropped if memory allocation fails, which
> is a decent way to recover from that situation.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>

And applied to the wl12xx tree.  Thank you!

-- 
Cheers,
Luca.

