Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34590 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbbHNG0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 02:26:21 -0400
Received: by paccq16 with SMTP id cq16so9991724pac.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2015 23:26:21 -0700 (PDT)
Date: Fri, 14 Aug 2015 11:56:13 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	jude.lee@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 2/5] staging: wilc1000: change void pointer type to real
 type
Message-ID: <20150814062613.GB421@sudip-pc> (sfid-20150814_082624_887049_8341C41C)
References: <1439440883-16061-1-git-send-email-tony.cho@atmel.com>
 <1439440883-16061-3-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1439440883-16061-3-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 13, 2015 at 01:41:20PM +0900, Tony Cho wrote:
> From: Johnny Kim <johnny.kim@atmel.com>
> 
> This patch changes the void pointer member of the tstrHostIFmsg to the
> real data type because the void pointer type is ambiguous and not
> readable.
> 
> Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
This patch is introducing some new warnings like:

drivers/staging/wilc1000/host_interface.c: In function ‘host_int_set_wfi_drv_handler’:
drivers/staging/wilc1000/host_interface.c:5817:66: warning: assignment
makes integer from pointer without a cast [enabled by default]
  strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler.u32Address = u32address;


regards
sudip
