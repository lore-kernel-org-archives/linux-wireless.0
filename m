Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122AbXK0QNM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 11:13:12 -0500
Subject: Re: [PATCH] libertas: let more than one MAC event through
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200711260935.44469.hs4233@mail.mn-solutions.de>
References: <200711260935.44469.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 27 Nov 2007 11:08:38 -0500
Message-Id: <1196179718.5194.2.camel@localhost.localdomain> (sfid-20071127_161325_584572_5BBCDCFC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-11-26 at 09:35 +0100, Holger Schurig wrote:
> lbs_mac_event_disconnected() was called once and then never again
> upon a hardware MAC event.
> 
> The reason was that the driver didn't clean the correct bit in the interrupt
> cause register of the chip.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-2.6/drivers/net/wireless/libertas/if_cs.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/if_cs.c	2007-11-26 10:18:05.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/if_cs.c	2007-11-26 10:18:32.000000000 +0100
> @@ -170,7 +170,8 @@ static int if_cs_poll_while_fw_download(
>  #define IF_CS_H_IC_TX_OVER		0x0001
>  #define IF_CS_H_IC_RX_OVER		0x0002
>  #define IF_CS_H_IC_DNLD_OVER		0x0004
> -#define IF_CS_H_IC_HOST_EVENT		0x0008
> +#define IF_CS_H_IC_POWER_DOWN		0x0008
> +#define IF_CS_H_IC_HOST_EVENT		0x0010
>  #define IF_CS_H_IC_MASK			0x001f
>  
>  #define IF_CS_H_INT_MASK		0x00000004

