Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16491 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416AbaAEAIY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jan 2014 19:08:24 -0500
Date: Sun, 5 Jan 2014 01:08:04 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Thierry Escande <thierry.escande@linux.intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] NFC: port100: fix leak of usb_device
Message-ID: <20140105000804.GD6003@zurbaran> (sfid-20140105_010906_064804_66297884)
References: <1388866085-11007-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1388866085-11007-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alexey,

On Sun, Jan 05, 2014 at 12:08:05AM +0400, Alexey Khoroshilov wrote:
> port100_probe() calls usb_get_dev(), but there is no usb_put_dev()
> in port100_disconnect(). The patch adds one.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/nfc/port100.c | 1 +
>  1 file changed, 1 insertion(+)
Patch applied to nfc-next, thanks.
I wonder if we really need to refcount the port100 USB interface, but
dev->in_urb does reference it for the whole driver life cycle, so I
think it all makes sense.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
