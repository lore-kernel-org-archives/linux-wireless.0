Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62365 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab0KEJpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 05:45:31 -0400
Received: by fxm16 with SMTP id 16so2170196fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Nov 2010 02:45:30 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 03/13] rt2x00: Wait up to one second on rt2800 for WPDMA to be ready
Date: Fri, 5 Nov 2010 10:44:37 +0100
Cc: linux-wireless@vger.kernel.org
References: <201011042037.00178.IvDoorn@gmail.com> <201011042037.23442.IvDoorn@gmail.com> <201011042037.47939.IvDoorn@gmail.com>
In-Reply-To: <201011042037.47939.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011051044.37167.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Am Donnerstag 04 November 2010 schrieb Ivo van Doorn:
> From: Helmut Schaa <helmut.schaa@googlemail.com>
> 
> At least some devices need such a long time to inititalize WPDMA. This
> only increases the maximum wait time and shouldn't affect devices that
> have been working before.
> 
> Reported-by: Joshua Smith <jesmith@kaon.com>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---

Ivo, the patch context looks different then in the version I've send to you.

The 
	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
should be
	for (i = 0; i < 100; i++) {

Otherwise we don't wait up to one second as in the comment but just 50ms :P

However, that change was part of a previous patch that was already merged into
the rt2x00 git tree. Seems like that change got lost during the merge ...

Helmut

>  drivers/net/wireless/rt2x00/rt2800lib.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index b1738bb..dcd3a89 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -277,13 +277,17 @@ int rt2800_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev)
>  	unsigned int i;
>  	u32 reg;
>  
> +	/*
> +	 * Some devices are really slow to respond here. Wait a whole second
> +	 * before timing out.
> +	 */
>  	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
>  		rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
>  		if (!rt2x00_get_field32(reg, WPDMA_GLO_CFG_TX_DMA_BUSY) &&
>  		    !rt2x00_get_field32(reg, WPDMA_GLO_CFG_RX_DMA_BUSY))
>  			return 0;
>  
> -		msleep(1);
> +		msleep(10);
>  	}
>  
>  	ERROR(rt2x00dev, "WPDMA TX/RX busy, aborting.\n");
> 

