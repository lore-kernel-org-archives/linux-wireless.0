Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:52857 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423115AbcFMNTn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 09:19:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] staging: wilc1000: Replace semaphore txq_add_to_head_cs with mutex
Date: Mon, 13 Jun 2016 15:20:57 +0200
Message-ID: <4729653.WB7hDso2I6@wuerfel> (sfid-20160613_152004_008850_729E6ACD)
In-Reply-To: <1465814259-3009-3-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org> <1465814259-3009-3-git-send-email-binoy.jayan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, June 13, 2016 4:07:34 PM CEST Binoy Jayan wrote:
> The semaphore 'txq_add_to_head_cs' is a simple mutex, so it should be
> written as one. Semaphores are going away in the future.

Looks good to me.

> Also, removing
> the timeout scenario as the error handling code does not propagate the
> timeout properly.

Good catch! I guess wilc_wlan_handle_txq() running into a timeout 
would end putting the semaphore in a state in which we never again
block on it because the count is now one higher than it should be.

	Arnd
