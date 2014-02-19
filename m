Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0066.hostedemail.com ([216.40.44.66]:47371 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753060AbaBSWPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 17:15:36 -0500
Message-ID: <1392848134.24844.16.camel@joe-AO722> (sfid-20140219_231545_389043_1BF2B3FE)
Subject: Re: [PATCH 4/4] staging: vt6656: Remove typedef enum _CONTEXT_TYPE
From: Joe Perches <joe@perches.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 14:15:34 -0800
In-Reply-To: <1392846993.20211.15.camel@canaries64-MCP7A>
References: <1392846993.20211.15.camel@canaries64-MCP7A>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-19 at 21:56 +0000, Malcolm Priestley wrote:
> Replace with enum
> assign as u8 type.
[]
> diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
[]
> @@ -180,7 +180,7 @@ struct vnt_usb_send_context {
>  	struct sk_buff *pPacket;
>  	struct urb *pUrb;
>  	unsigned int uBufLen;
> -	CONTEXT_TYPE Type;
> +	u8 type;

This doesn't really save any space in the struct.
You might move it immediately before or after bBoolInUse.

>  	struct ethhdr sEthHeader;
>  	void *Next;
>  	bool bBoolInUse;


