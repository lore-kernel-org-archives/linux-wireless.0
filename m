Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36413 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbbFPHJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 03:09:58 -0400
Received: by pdjm12 with SMTP id m12so7936249pdj.3
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2015 00:09:58 -0700 (PDT)
Date: Tue, 16 Jun 2015 12:39:50 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Dean Lee <dean.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, rachel.kim@atmel.com,
	chris.park@atmel.com, johnny.kim@atmel.com
Subject: Re: [PATCH] staging: wilc1000: modify type casting warning
Message-ID: <20150616070950.GC3943@sudip-PC> (sfid-20150616_091002_704216_1509334B)
References: <1434437164-4345-1-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434437164-4345-1-git-send-email-dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2015 at 03:46:04PM +0900, Dean Lee wrote:
> modify message "warning: cast from pointer to integer of different size".
> add type cast 'uintptr_t'.
> ---
[]
> @@ -620,7 +621,7 @@ static s32 Handle_SetChannel(void *drvHandler, tstrHostIFSetChan *pstrHostIFSetC
>  
>  	PRINT_D(HOSTINF_DBG, "Setting channel\n");
>  	/*Sending Cfg*/
> -	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
> +	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
two typecasts??? there has to be a better solution than this.

regards
sudip
