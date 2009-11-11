Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:35168 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbZKKUqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 15:46:00 -0500
Subject: Re: [PATCH 13/13] pcmcia: rework the irq_req_t typedef
From: Marcel Holtmann <marcel@holtmann.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-pcmcia@lists.infradead.org, netdev@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
	alsa-devel@alsa-project.org, Jaroslav Kysela <perex@perex.cz>,
	Jiri Kosina <jkosina@suse.cz>,
	Karsten Keil <isdn@linux-pingi.de>
In-Reply-To: <1257971899-9274-13-git-send-email-linux@dominikbrodowski.net>
References: <20091111203303.GA7939@comet.dominikbrodowski.net>
	 <1257971899-9274-13-git-send-email-linux@dominikbrodowski.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Nov 2009 21:46:03 +0100
Message-ID: <1257972363.21467.7.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dominik,

> Most of the irq_req_t typedef'd struct can be re-worked quite
> easily:
> 
> (1) IRQInfo2 was unused in any case, so drop it.
> 
> (2) IRQInfo1 was used write-only, so drop it.
> 
> (3) Instance (private data to be passed to the IRQ handler):
> 	Most PCMCIA drivers using pcmcia_request_irq() to actually
> 	register an IRQ handler set the "dev_id" to the same pointer
> 	as the "priv" pointer in struct pcmcia_device. Modify the two
> 	exceptions (ipwireless, ibmtr_cs) to also work this waym and
> 	set the IRQ handler's "dev_id" to p_dev->priv unconditionally.
> 
> (4) Handler is to be of type irq_handler_t.
> 
> (5) Handler != NULL already tells whether an IRQ handler is present.
> 	Therefore, we do not need the IRQ_HANDLER_PRESENT flag in
> 	irq_req_t.Attributes.
> 
> CC: netdev@vger.kernel.org
> CC: linux-bluetooth@vger.kernel.org
> CC: linux-ide@vger.kernel.org
> CC: linux-wireless@vger.kernel.org
> CC: linux-scsi@vger.kernel.org
> CC: alsa-devel@alsa-project.org
> CC: Jaroslav Kysela <perex@perex.cz>
> CC: Jiri Kosina <jkosina@suse.cz>
> CC: Karsten Keil <isdn@linux-pingi.de>
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
> ---
>  drivers/ata/pata_pcmcia.c                        |    1 -
>  drivers/bluetooth/bluecard_cs.c                  |    4 +---
>  drivers/bluetooth/bt3c_cs.c                      |    4 +---
>  drivers/bluetooth/btuart_cs.c                    |    4 +---
>  drivers/bluetooth/dtl1_cs.c                      |    4 +---

for the Bluetooth parts:

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


