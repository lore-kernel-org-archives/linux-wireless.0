Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534AbcBCXEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 18:04:30 -0500
Date: Wed, 3 Feb 2016 15:04:29 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Johnny Kim <johnny.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	ldv-project@linuxtesting.org
Subject: Re: [PATCH v3] staging: wilc1000: fix double mutex_unlock on failure
 path in wilc_wlan_cleanup()
Message-ID: <20160203230429.GA17828@kroah.com> (sfid-20160204_000449_141306_46DF19B4)
References: <20151221212202.GA11670@kroah.com>
 <1450805966-9193-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1450805966-9193-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 22, 2015 at 08:39:26PM +0300, Alexey Khoroshilov wrote:
> If hif_read_reg() or hif_write_reg() fail in wilc_wlan_cleanup(),
> it calls release_bus() and continues execution. But it leads to double
> release_bus() call that means double unlock of g_linux_wlan->hif_cs mutex.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/staging/wilc1000/wilc_wlan.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Why is this 'v3'?  What changed from the other versions?  Please always
document it below the --- line so that we have a chance when reviewing
them.

Please fix up and resend with that information.

thanks,

greg k-h
