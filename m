Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981AbYFEOHu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 10:07:50 -0400
Subject: Re: [PATCH 2/3] libertas: document register meanings
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200806051307.04908.hs4233@mail.mn-solutions.de>
References: <200806051307.04908.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 10:07:24 -0400
Message-Id: <1212674844.28545.25.camel@localhost.localdomain> (sfid-20080605_160753_638565_6AC35BC3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-05 at 13:07 +0200, Holger Schurig wrote:
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> --- linux.orig/drivers/net/wireless/libertas/if_cs.c
> +++ linux/drivers/net/wireless/libertas/if_cs.c
> @@ -159,7 +159,9 @@
>  
> 
> 
> -/* First the bitmasks for the host/card interrupt/status registers: */
> +/*
> + * First the bitmasks for the host/card interrupt/status registers:
> + */
>  #define IF_CS_BIT_TX			0x0001
>  #define IF_CS_BIT_RX			0x0002
>  #define IF_CS_BIT_COMMAND		0x0004
> @@ -167,35 +169,104 @@
>  #define IF_CS_BIT_EVENT			0x0010
>  #define	IF_CS_BIT_MASK			0x001f
>  
> -/* And now the individual registers and assorted masks */
> +
> +
> +/*
> + * It's not really clear to me what the host status register is for. It
> + * needs to be set almost in union with "host int cause". The following
> + * bits from above are used:
> + *
> + *   IF_CS_BIT_TX         driver downloaded a data packet
> + *   IF_CS_BIT_RX         driver got a data packet
> + *   IF_CS_BIT_COMMAND    driver downloaded a command
> + *   IF_CS_BIT_RESP       not used (has some meaning with powerdown)
> + *   IF_CS_BIT_EVENT      driver read a host event
> + */
>  #define IF_CS_HOST_STATUS		0x00000000
>  
> +/*
> + * With the host int cause register can the host (that is, Linux) cause
> + * an interrupt in the firmware, to tell the firmware about those events:
> + *
> + *   IF_CS_BIT_TX         a data packet has been downloaded
> + *   IF_CS_BIT_RX         a received data packet has retrieved
> + *   IF_CS_BIT_COMMAND    a firmware block or a command has been downloaded
> + *   IF_CS_BIT_RESP       not used (has some meaning with powerdown)
> + *   IF_CS_BIT_EVENT      a host event (link lost etc) has been retrieved
> + */
>  #define IF_CS_HOST_INT_CAUSE		0x00000002
>  
> +/*
> + * The host int mask register is used to enable/disable interrupt.  However,
> + * I have the suspicion that disabled interrupts are lost.
> + */
>  #define IF_CS_HOST_INT_MASK		0x00000004
>  
> +/*
> + * Used to send or receive data packets:
> + */
>  #define IF_CS_HOST_WRITE		0x00000016
>  #define IF_CS_HOST_WRITE_LEN		0x00000014
> -
> -#define IF_CS_HOST_CMD			0x0000001A
> -#define IF_CS_HOST_CMD_LEN		0x00000018
> -
>  #define IF_CS_READ			0x00000010
>  #define IF_CS_READ_LEN			0x00000024
>  
> +/*
> + * Used to send commands (and to send firmware block) and to
> + * receive command responses:
> + */
> +#define IF_CS_HOST_CMD			0x0000001A
> +#define IF_CS_HOST_CMD_LEN		0x00000018
>  #define IF_CS_CARD_CMD			0x00000012
>  #define IF_CS_CARD_CMD_LEN		0x00000030
>  
> +/*
> + * The card status registers shows what the card/firmware actually
> + * accepts:
> + *
> + *   IF_CS_BIT_TX        you may send a data packet
> + *   IF_CS_BIT_RX        you may retrieve a data packet
> + *   IF_CS_BIT_COMMAND   you may send a command
> + *   IF_CS_BIT_RESP      you may retrieve a command response
> + *   IF_CS_BIT_EVENT     the card has a event for use (link lost, snr low etc)
> + *
> + * When reading this register several times, you will get back the same
> + * results --- with one exception: the IF_CS_BIT_EVENT clear itself
> + * automatically.
> + *
> + * Not that we don't rely on BIT_RX,_BIT_RESP or BIT_EVENT because
> + * we handle this via the card int cause register.
> + */
>  #define IF_CS_CARD_STATUS		0x00000020
>  #define IF_CS_CARD_STATUS_MASK		0x7f00
>  
> +/*
> + * The card int cause register is used by the card/firmware to notify us
> + * about the following events:
> + *
> + *   IF_CS_BIT_TX        a data packet has successfully been sentx
> + *   IF_CS_BIT_RX        a data packet has been received and can be retrieved
> + *   IF_CS_BIT_COMMAND   not used
> + *   IF_CS_BIT_RESP      the firmware has a command response for us
> + *   IF_CS_BIT_EVENT     the card has a event for use (link lost, snr low etc)
> + */
>  #define IF_CS_CARD_INT_CAUSE		0x00000022
>  
> +/*
> + * This is used to for handshaking with the card's bootloader/helper image
> + * to synchronize downloading of firmware blocks.
> + */
>  #define IF_CS_CARD_SQ_READ_LOW		0x00000028
>  #define IF_CS_CARD_SQ_HELPER_OK		0x10
>  
> +/*
> + * The scratch register tells us ...
> + *
> + * IF_CS_SCRATCH_BOOT_OK     the bootloader runs
> + * IF_CS_SCRATCH_HELPER_OK   the helper firmware already runs
> + */
>  #define IF_CS_SCRATCH			0x0000003F
> -
> +#define IF_CS_SCRATCH_BOOT_OK		0x00
> +#define IF_CS_SCRATCH_HELPER_OK		0x5a
>  
> 
>  /********************************************************************/
> @@ -466,11 +537,11 @@
>  	/* "If the value is 0x5a, the firmware is already
>  	 * downloaded successfully"
>  	 */
> -	if (scratch == 0x5a)
> +	if (scratch == IF_CS_SCRATCH_HELPER_OK)
>  		goto done;
>  
>  	/* "If the value is != 00, it is invalid value of register */
> -	if (scratch != 0x00) {
> +	if (scratch != IF_CS_SCRATCH_BOOT_OK) {
>  		ret = -ENODEV;
>  		goto done;
>  	}

