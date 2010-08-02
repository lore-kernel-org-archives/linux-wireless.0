Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sv1.nifty.com ([220.209.183.60]:46294 "EHLO
	defg301.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0HBMM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 08:12:59 -0400
Message-ID: <15238373.192661280750366920.komurojun-mbn@nifty.com>
Date: Mon, 2 Aug 2010 20:59:26 +0900 (JST)
From: Komuro <komurojun-mbn@nifty.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH 01/11] pcmcia: use pcmica_{read,write}_config_byte
Cc: linux-pcmcia@lists.infradead.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-serial@vger.kernel.org,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <1280667550-3040-1-git-send-email-linux@dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
References: <1280667550-3040-1-git-send-email-linux@dominikbrodowski.net>
 <20100801125749.GA2564@comet.dominikbrodowski.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>--- a/drivers/net/pcmcia/xirc2ps_cs.c
>+++ b/drivers/net/pcmcia/xirc2ps_cs.c


>+	if (err)
> 	    goto config_error;
>-	reg.Action = CS_WRITE;
>-	reg.Offset = CISREG_IOBASE_1;
>-	reg.Value = (link->io.BasePort2 >> 8) & 0xff;
>-	if ((err = pcmcia_access_configuration_register(link, &reg)))
>+
>+	err = pcmcia_write_config_byte(link, CISREG_IOBASE_1,
>+				link->io.BasePort2 & 0xff);

It should be

	err = pcmcia_write_config_byte(link, CISREG_IOBASE_1,
				(link->io.BasePort2 >> 8) & 0xff);



