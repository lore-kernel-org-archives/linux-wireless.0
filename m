Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39969 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbZGANRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 09:17:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] ssb: Add support for 4318E
Date: Wed, 1 Jul 2009 15:17:33 +0200
Cc: John W Linville <linville@tuxdriver.com>, ccmcphe@verizon.net,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4a4ada7f.oItwGXurq7WMW+HE%Larry.Finger@lwfinger.net>
In-Reply-To: <4a4ada7f.oItwGXurq7WMW+HE%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907011517.34061.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 01 July 2009 05:39:43 Larry Finger wrote:
> From: Clyde McPherson <ccmcphe@verizon.net>
> 
> Added support for the Broadcom 4318E chipset on PCMCIA/CF cards. The 
> 4318E can do 802.11A/B/G, only B and G mode are supported in b43.
> 
> Signed-off-by: Clyde McPherson <ccmcphe@verizon.net>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

ack

> ---
> 
> Index: wireless-testing/drivers/ssb/pcmcia.c
> ===================================================================
> --- wireless-testing.orig/drivers/ssb/pcmcia.c
> +++ wireless-testing/drivers/ssb/pcmcia.c
> @@ -678,7 +678,8 @@ int ssb_pcmcia_get_invariants(struct ssb
>  			sprom->board_rev = tuple.TupleData[1];
>  			break;
>  		case SSB_PCMCIA_CIS_PA:
> -			GOTO_ERROR_ON(tuple.TupleDataLen != 9,
> +			GOTO_ERROR_ON((tuple.TupleDataLen != 9) &&
> +				      (tuple.TupleDataLen != 10),
>  				      "pa tpl size");
>  			sprom->pa0b0 = tuple.TupleData[1] |
>  				 ((u16)tuple.TupleData[2] << 8);
> @@ -718,7 +719,8 @@ int ssb_pcmcia_get_invariants(struct ssb
>  			sprom->antenna_gain.ghz5.a3 = tuple.TupleData[1];
>  			break;
>  		case SSB_PCMCIA_CIS_BFLAGS:
> -			GOTO_ERROR_ON(tuple.TupleDataLen != 3,
> +			GOTO_ERROR_ON((tuple.TupleDataLen != 3) &&
> +				      (tuple.TupleDataLen != 5),
>  				      "bfl tpl size");
>  			sprom->boardflags_lo = tuple.TupleData[1] |
>  					 ((u16)tuple.TupleData[2] << 8);
> 
> 



-- 
Greetings, Michael.
