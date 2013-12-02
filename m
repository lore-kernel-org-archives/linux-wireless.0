Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43685 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab3LBMce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 07:32:34 -0500
Date: Mon, 2 Dec 2013 12:32:30 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] [stable back port for <= 3.8] staging: vt6656: [BUG] Fix
 for TX USB resets from vendors driver.
Message-ID: <20131202123230.GA1799@hercules.my.domain> (sfid-20131202_133237_469138_EDEEC8CE)
References: <1385888246.3121.3.camel@canaries32-MCP7A>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1385888246.3121.3.camel@canaries32-MCP7A>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 01, 2013 at 08:57:26AM +0000, Malcolm Priestley wrote:
> upstream commit
> 9df682927c2e3a92f43803d6b52095992e3b2ab8
> back port for 3.8 and less kernels.
> 
> This fixes resets on heavy TX data traffic.
> 
> Vendor driver
> VT6656_Linux_src_v1.21.03_x86_11.04.zip
> http://www.viaembedded.com/servlet/downloadSvl?id=1890&download_file_id=14704
> This is GPL-licensed code.
> 
> original code
> BBbVT3184Init
> ...
> //2007-0725, RobertChang add, Enable Squelch detect reset option(SQ_RST_Opt), USB (register4, bit1)
> CONTROLnsRequestIn(pDevice,
>                                  MESSAGE_TYPE_READ,
>                                  (WORD)0x600+4,     // USB's Reg4's bit1
>                                  MESSAGE_REQUEST_MEM,
>                                  1,
>                                  (PBYTE) &byData);
> byData = byData|2 ;
> CONTROLnsRequestOut(pDevice,
>                               MESSAGE_TYPE_WRITE,
>                               (WORD)0x600+4,     // USB's Reg4's bit1
>                               MESSAGE_REQUEST_MEM,
>                               1,
>                               (PBYTE) &byData);
> 
> return TRUE;//ntStatus;
> ....
> 
> A back port patch is needed for kernels less than 3.10.

Thank you, I'll queue it for the 3.5 kernel.

Cheers,
--
Luis

