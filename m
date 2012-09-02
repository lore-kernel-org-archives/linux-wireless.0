Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42608 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab2IBUoH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2012 16:44:07 -0400
Received: by vbbff1 with SMTP id ff1so4758338vbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 02 Sep 2012 13:44:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346433734-3337-7-git-send-email-gwingerde@gmail.com>
References: <1346433734-3337-1-git-send-email-gwingerde@gmail.com>
	<1346433734-3337-2-git-send-email-gwingerde@gmail.com>
	<1346433734-3337-3-git-send-email-gwingerde@gmail.com>
	<1346433734-3337-4-git-send-email-gwingerde@gmail.com>
	<1346433734-3337-5-git-send-email-gwingerde@gmail.com>
	<1346433734-3337-6-git-send-email-gwingerde@gmail.com>
	<1346433734-3337-7-git-send-email-gwingerde@gmail.com>
Date: Sun, 2 Sep 2012 22:44:07 +0200
Message-ID: <CAOZOX0UvKHoPrcQ8C15eeogknFexBmb1qeiGb0PC52nKMri=JQ@mail.gmail.com> (sfid-20120902_224412_358877_FC173043)
Subject: Re: [PATCH v2 6/6] rt2x00: rt2800 - Make probe_hw function common
 between PCI and USB.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index c3cae1d..2ad3b7a 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -44,6 +44,13 @@
>  #include "rt2800.h"
>
>  /*
> + * Allow hardware encryption to be disabled.
> + */
> +static bool modparam_nohwcrypt = false;
> +module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
> +MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");

I am not particularly fond of this change, I would like to have the
module parameters inside the actual drivers instead of inside one of
the
library modules. I don't know if there is a policy for modules which
says something about these situations, but my preference would be
that the module parameters are inside rt2800pci and rt2800usb, and
that the value would be passed to rt2800lib.

If there is isn't a simple and clean way to do that, then we can take
this patch though...

Ivo
