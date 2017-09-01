Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37776 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdIAFJG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 01:09:06 -0400
Date: Fri, 1 Sep 2017 07:09:10 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Jens Axboe <axboe@fb.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/31] timer: Remove meaningless .data/.function
 assignments
Message-ID: <20170901050910.GB2584@kroah.com> (sfid-20170901_070922_097266_E2796AD8)
References: <1504222183-61202-1-git-send-email-keescook@chromium.org>
 <1504222183-61202-14-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1504222183-61202-14-git-send-email-keescook@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 31, 2017 at 04:29:25PM -0700, Kees Cook wrote:
> Several timer users needlessly reset their .function/.data fields during
> their timer callback, but nothing else changes them. Some users do not
> use their .data field at all. Each instance is removed here.
> 
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Cc: Aditya Shankar <aditya.shankar@microchip.com>
> Cc: Ganesh Krishna <ganesh.krishna@microchip.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: devel@driverdev.osuosl.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/block/amiflop.c                           | 3 +--
>  drivers/net/wan/hdlc_cisco.c                      | 2 --
>  drivers/net/wan/hdlc_fr.c                         | 2 --
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 +---
>  4 files changed, 2 insertions(+), 9 deletions(-)

For the staging driver:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
