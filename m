Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405Ab2ADQ6H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 11:58:07 -0500
Subject: Re: APM6270 wireless driver
From: Dan Williams <dcbw@redhat.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAAfyv35teMwij7Bg=5b+sBGZt8UpDRQzfdbw2G0EmBW9vEjg+w@mail.gmail.com>
References: <CAAfyv35teMwij7Bg=5b+sBGZt8UpDRQzfdbw2G0EmBW9vEjg+w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jan 2012 10:58:05 -0600
Message-ID: <1325696285.2622.11.camel@d430> (sfid-20120104_175811_113905_751A05DF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-28 at 14:00 +0100, Belisko Marek wrote:
> Hi,
> 
> is there available any actual kernel driver which works with APM6270 chip?
> There is available some old sources which are currently not compilable
> (http://friendlyarm.net/forum/topic/3624)
> 
> Make sense to push existing driver to staging drivers? Seems to me
> little bit outdated ;)

The sources from the link you pasted make it appear that the APM card is
a rebranded Marvell SD8686 with PXA SDHC bus drivers.  There's already a
driver for the SD8686 which probably works with this part, although we
may need to add the vendor ID for the APM6270.

For the SDIO bus drivers, we'd need to see if the existing upstream bus
drivers already work for this hardware, and if not, the ones from that
package would then need to be ported.  I don't see a PXA270m SDIO driver
in the upstream tree, but there's a lot of support for the S3C2440
including an MMC driver which is a prerequisite for SD support.  I'm not
sure if the s3cmci MMC driver supports SDIO though.

Dan

