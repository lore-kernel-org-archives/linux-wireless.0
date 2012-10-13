Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36180 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab2JMFlY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2012 01:41:24 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	hch@lst.de, s.L-H@gmx.de
Subject: Re: [PATCH 2/4] ar5523: Add driver header file
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com>
	<1349985702-21322-3-git-send-email-pontus.fuchs@gmail.com>
Date: Sat, 13 Oct 2012 08:41:23 +0300
In-Reply-To: <1349985702-21322-3-git-send-email-pontus.fuchs@gmail.com>
	(Pontus Fuchs's message of "Thu, 11 Oct 2012 22:01:40 +0200")
Message-ID: <87626f0vzw.fsf@purkki.adurom.net> (sfid-20121013_074130_742281_36164E9C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pontus Fuchs <pontus.fuchs@gmail.com> writes:

> +#define ar5523_err(ar, format, arg...) \
> +do { \
> +	if (!test_bit(AR5523_USB_DISCONNECTED, &ar->flags)) { \
> +		dev_err(&(ar)->dev->dev, format, ## arg); \
> +	} \
> +} while (0)

This looks suspicious and might hide something important. It's better to
fix the real cause than to workaround it in the error log printer. Do
you know why this was added?

-- 
Kalle Valo
