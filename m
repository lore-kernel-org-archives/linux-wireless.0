Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-am1on0147.outbound.protection.outlook.com ([157.56.112.147]:61204
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757321AbbEEJxY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 05:53:24 -0400
From: "Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Julia.Lawall@lip6.fr" <Julia.Lawall@lip6.fr>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
	"Babu, Viswanathan (V.)" <vbabu3@visteon.com>,
	"wlanfae@realtek.com" <wlanfae@realtek.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2] staging: rtl8192e: fix wrong assignment
Date: Tue, 5 May 2015 09:38:50 +0000
Message-ID: <20150505093330.GA3654@IND12F0122> (sfid-20150505_115328_610116_8C8F6791)
References: <20150504092347.GA6742@IND12F0122> <5547D3C5.50902@gmail.com>
 <20150505091957.GM16501@mwanda>
In-Reply-To: <20150505091957.GM16501@mwanda>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 05, 2015 at 12:19:57PM +0300, Dan Carpenter wrote:
> On Mon, May 04, 2015 at 10:17:09PM +0200, Mateusz Kulikowski wrote:
> > As far as I know (radio) noise is rarely above 0 dBm - if it is, you're doing something wrong.
> > This means we can just change rtllib_rx_stats::noise to s8.
> 
> I think it's hard to do that because these definitions are part of the
> user space API.
> 
> include/uapi/linux/wireless.h
> 
> linux-wireless is not on the CC list so we will never know for sure.
> 
> There are still a bunch of these warnings.
> 
> drivers/staging/rtl8192u/r8192U_wx.c:271 rtl8180_wx_get_range() warn: assigning (-78) to unsigned variable 'range->avg_qual.level'
> drivers/staging/rtl8712/rtl871x_ioctl_linux.c:914 r8711_wx_get_range() warn: assigning (-78) to unsigned variable 'range->avg_qual.level'
> drivers/net/wireless/ipw2x00/ipw2100.c:6817 ipw2100_wx_get_range() warn: assigning (-78) to unsigned variable 'range->avg_qual.level'
> drivers/net/wireless/hostap/hostap_ioctl.c:1023 prism2_ioctl_giwrange() warn: assigning (-60) to unsigned variable 'range->avg_qual.level'
> drivers/net/wireless/prism54/isl_ioctl.c:451 prism54_get_range() warn: assigning (-80) to unsigned variable 'range->avg_qual.level'
> 
> drivers/staging/rtl8192u/r8192U_core.c:4493 rtl8192_rx_nomal() warn: assigning (-98) to unsigned variable 'stats.noise'
> drivers/staging/rtl8192u/r8192U_core.c:4605 rtl8192_rx_cmd() warn: assigning (-98) to unsigned variable 'stats.noise'
> drivers/staging/rtl8192u/r8192U_wx.c:266 rtl8180_wx_get_range() warn: assigning (-98) to unsigned variable 'range->max_qual.noise'
> drivers/staging/rtl8192e/rtl8192e/rtl_wx.c:1323 r8192_get_wireless_stats() warn: assigning (-100) to unsigned variable 'wstats->qual.noise'
> drivers/staging/rtl8192e/rtl8192e/rtl_core.c:2322 rtl8192_rx_normal() warn: assigning (-98) to unsigned variable 'stats.noise'
> drivers/net/wireless/hostap/hostap_ioctl.c:1024 prism2_ioctl_giwrange() warn: assigning (-95) to unsigned variable 'range->avg_qual.noise'
> 
> regards,
> dan carpenter
> 

Added the linux-wireless guys in the CC list so that they can comment on
this.