Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:47164 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756925Ab2AREf4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 23:35:56 -0500
Message-ID: <1326861354.20922.30.camel@joe2Laptop> (sfid-20120118_053559_382983_3B125F12)
Subject: Re: [PATCH V2] rtlwifi: Move pr_fmt macros to a single location
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 17 Jan 2012 20:35:54 -0800
In-Reply-To: <4f16485c.snp+nOwfRpOtSbfu%Larry.Finger@lwfinger.net>
References: <4f16485c.snp+nOwfRpOtSbfu%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-17 at 22:19 -0600, Larry Finger wrote:
> Although the rtlwifi family of devices contains 11 copies of the pr_fmt
> macro, the macro is not defined for all routines that need it. By moving
> the macro to wifi.h, a single copy is available for all routines.
> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
> @@ -43,6 +40,9 @@
>  #include "trx.h"
>  #include "led.h"
>  
> +#include <linux/vmalloc.h>
> +#include <linux/module.h>

You might try sorting out what's actually
necessary to have #included in each file.

vmalloc.h, usb.h and lots of others are already
#included via wifi.h

Another possibility is to add -I..
to the Makefiles so the #includes aren't
specified by relative path.

