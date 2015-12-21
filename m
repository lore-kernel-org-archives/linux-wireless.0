Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbbLUVWS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 16:22:18 -0500
Date: Mon, 21 Dec 2015 13:22:02 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: devel@driverdev.osuosl.org, ldv-project@linuxtesting.org,
	Chris Park <chris.park@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	linux-wireless@vger.kernel.org, Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Leo Kim <leo.kim@atmel.com>
Subject: Re: [PATCH] staging: wilc1000: fix double mutex_unlock on failure
 path in wilc_wlan_cleanup()
Message-ID: <20151221212202.GA11670@kroah.com> (sfid-20151221_222234_286517_B0CD04A7)
References: <20151218225010.GA26812@kroah.com>
 <1450648011-1381-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1450648011-1381-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 21, 2015 at 12:46:51AM +0300, Alexey Khoroshilov wrote:
> If hif_read_reg() or hif_write_reg() fail in wilc_wlan_cleanup(),
> it calls release_bus() and continues execution. But it leads to double
> release_bus() call that means double unlock of g_linux_wlan->hif_cs mutex.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Doesn't apply to my tree anymore, can you rebase this on the
staging-testing branch of staging.git?

thanks,

greg k-h
