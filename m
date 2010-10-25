Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:18305 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab0JYMhK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 08:37:10 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o9PCauqN006906
	for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 07:37:09 -0500
Subject: Re: [PATCH] wl1271: Fix RX path stall
From: Tuomas Katila <ext-tuomas.2.katila@nokia.com>
To: "ext juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1287998669-27209-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1287998669-27209-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 15:31:05 +0300
Message-ID: <1288009865.17497.347.camel@tukatila-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-25 at 11:24 +0200, ext juuso.oikarinen@nokia.com wrote:
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

Tested-by: Tuomas Katila <ext-tuomas.2.katila@nokia.com>

I tested this with production mode in the scenario where it was
previously failing, and it is not getting stuck anymore.

-Tuomas


