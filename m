Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbbLSAoe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 19:44:34 -0500
Date: Fri, 18 Dec 2015 14:50:10 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	ldv-project@linuxtesting.org
Subject: Re: [PATCH] staging: wilc1000: fix double mutex_unlock on failure
 path in wilc_wlan_cleanup()
Message-ID: <20151218225010.GA26812@kroah.com> (sfid-20151219_014455_903442_B5F1F3EF)
References: <1449266674-6642-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1449266674-6642-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 05, 2015 at 01:04:34AM +0300, Alexey Khoroshilov wrote:
> If hif_read_reg() or hif_write_reg() fail in wilc_wlan_cleanup(),
> it calls release_bus() and continues execution. But it leads to double
> release_bus() call that means double unlock of g_linux_wlan->hif_cs mutex.
> 
> The patch adds return in case of failure.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/staging/wilc1000/wilc_wlan.c | 2 ++
>  1 file changed, 2 insertions(+)

No longer applies to my tree, can you rebase it against staging-testing
and resend?

thanks,

greg k-h
