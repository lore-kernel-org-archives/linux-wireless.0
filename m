Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbbHOCBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 22:01:50 -0400
Date: Fri, 14 Aug 2015 19:01:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Tony Cho <tony.cho@atmel.com>, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	jude.lee@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 2/5] staging: wilc1000: change void pointer type to real
 type
Message-ID: <20150815020149.GA14400@kroah.com> (sfid-20150815_040159_709510_AE5067AF)
References: <1439440883-16061-1-git-send-email-tony.cho@atmel.com>
 <1439440883-16061-3-git-send-email-tony.cho@atmel.com>
 <20150814062613.GB421@sudip-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20150814062613.GB421@sudip-pc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 14, 2015 at 11:56:13AM +0530, Sudip Mukherjee wrote:
> On Thu, Aug 13, 2015 at 01:41:20PM +0900, Tony Cho wrote:
> > From: Johnny Kim <johnny.kim@atmel.com>
> > 
> > This patch changes the void pointer member of the tstrHostIFmsg to the
> > real data type because the void pointer type is ambiguous and not
> > readable.
> > 
> > Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
> > Signed-off-by: Tony Cho <tony.cho@atmel.com>
> > ---
> This patch is introducing some new warnings like:
> 
> drivers/staging/wilc1000/host_interface.c: In function ‘host_int_set_wfi_drv_handler’:
> drivers/staging/wilc1000/host_interface.c:5817:66: warning: assignment
> makes integer from pointer without a cast [enabled by default]
>   strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler.u32Address = u32address;

That warning doesn't seem to have anything to do with this patch, odd...
