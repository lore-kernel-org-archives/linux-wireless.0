Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20541 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568AbaJHOZJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 10:25:09 -0400
Date: Wed, 8 Oct 2014 17:24:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: devel@driverdev.osuosl.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [patch] staging: rtl8723au: incorrect use of ether_addr_copy()
Message-ID: <20141008142451.GE26918@mwanda> (sfid-20141008_162523_628916_D0A22B00)
References: <20141008104014.GA23096@mwanda>
 <wrfj4mvezmpm.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <wrfj4mvezmpm.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 08, 2014 at 03:59:33PM +0200, Jes Sorensen wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
> > The return from myid() isn't aligned correctly for ether_addr_copy().
> >
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Sorry, this makes no sense, just fix it properly!
> 
> drivers/staging/rtl8723au/include/rtw_eeprom.h:
> 
> struct eeprom_priv {
>         u8              bautoload_fail_flag;
>         u8              bloadfile_fail_flag;
>         u8              bloadmac_fail_flag;
>         /* u8           bempty; */
>         /* u8           sys_config; */
>         u8              mac_addr[6];    /* PermanentAddress */
>         /* u8           config0; */
> 
> Move mac_addr[6] to the top of the struct and be done with it.
> 
> NACK

Oops.  I thought it was something from the hardware.  Actually can you
fix it and give me a reported-by tag?

regards,
dan carpenter
