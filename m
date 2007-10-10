Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:38003 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbXJJOal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 10:30:41 -0400
Received: by nf-out-0910.google.com with SMTP id g13so189440nfb
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 07:30:39 -0700 (PDT)
Message-ID: <d120d5000710100730j243247e1te570ff57522693eb@mail.gmail.com> (sfid-20071010_153043_720854_9B8FD029)
Date: Wed, 10 Oct 2007 10:30:35 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH] b43: Use input-polldev for the rfkill switch
Cc: "John Linville" <linville@tuxdriver.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200709281422.34434.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200709281422.34434.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michael,

On 9/28/07, Michael Buesch <mb@bu3sch.de> wrote:
> This removes the direct call to rfkill on an rfkill event
> and replaces it with an input device. This way userspace is also
> notified about the event.
>
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
>
> Index: wireless-2.6/drivers/net/wireless/b43/Kconfig
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/b43/Kconfig  2007-09-27 21:31:15.000000000 +0200
> +++ wireless-2.6/drivers/net/wireless/b43/Kconfig       2007-09-28 12:34:23.000000000 +0200
> @@ -70,7 +70,7 @@ config B43_LEDS
>  # RFKILL support
>  config B43_RFKILL
>        bool
> -       depends on B43 && RFKILL
> +       depends on B43 && RFKILL && RFKILL_INPUT && INPUT_POLLDEV
>        default y

I don't think that broadcom driver should depend on RFKILL_INPUT...
RFKILL_INPUT is a default link between input and rfkill layers but it
is by no means a mandatory component.

I think proper dependency should be:

        depends on B43 && RFKILL && INPUT
        select INPUT_POLLDEV

-- 
Dmitry
