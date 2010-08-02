Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar-3.linta.de ([188.40.101.200]:48028 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754178Ab0HBUMK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 16:12:10 -0400
Date: Mon, 2 Aug 2010 21:52:21 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Komuro <komurojun-mbn@nifty.com>
Cc: Michael Buesch <mb@bu3sch.de>, netdev@vger.kernel.org,
	linux-pcmcia@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-serial@vger.kernel.org
Subject: Re: [PATCH 01/11] pcmcia: use pcmica_{read,write}_config_byte
Message-ID: <20100802195221.GA21063@comet.dominikbrodowski.net>
References: <1280667550-3040-1-git-send-email-linux@dominikbrodowski.net>
 <20100801125749.GA2564@comet.dominikbrodowski.net>
 <15238373.192661280750366920.komurojun-mbn@nifty.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <15238373.192661280750366920.komurojun-mbn@nifty.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

On Mon, Aug 02, 2010 at 08:59:26PM +0900, Komuro wrote:
> >--- a/drivers/net/pcmcia/xirc2ps_cs.c
> >+++ b/drivers/net/pcmcia/xirc2ps_cs.c
> 
> 
> >+	if (err)
> > 	    goto config_error;
> >-	reg.Action = CS_WRITE;
> >-	reg.Offset = CISREG_IOBASE_1;
> >-	reg.Value = (link->io.BasePort2 >> 8) & 0xff;
> >-	if ((err = pcmcia_access_configuration_register(link, &reg)))
> >+
> >+	err = pcmcia_write_config_byte(link, CISREG_IOBASE_1,
> >+				link->io.BasePort2 & 0xff);
> 
> It should be
> 
> 	err = pcmcia_write_config_byte(link, CISREG_IOBASE_1,
> 				(link->io.BasePort2 >> 8) & 0xff);
> 

Fixed, thanks.

Best,
	Dominik
