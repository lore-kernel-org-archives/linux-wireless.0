Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58026 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933180AbcFIH5P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 03:57:15 -0400
Message-ID: <1465459030.3442.1.camel@sipsolutions.net> (sfid-20160609_095719_889205_B9391DC7)
Subject: Re: [PATCH] wext: Fix 32 bit iwpriv compatibility issue with 64 bit
 Kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Prasun Maiti <prasunmaiti87@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Dibyajyoti Ghosh <dibyajyotig@gmail.com>,
	Ujjal Roy <royujjal@gmail.com>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Date: Thu, 09 Jun 2016 09:57:10 +0200
In-Reply-To: <1465223659-11530-1-git-send-email-prasunmaiti87@gmail.com> (sfid-20160606_163426_530582_81940E1D)
References: <1464690345.3076.17.camel@sipsolutions.net>
	 <1465223659-11530-1-git-send-email-prasunmaiti87@gmail.com>
	 (sfid-20160606_163426_530582_81940E1D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-06-06 at 20:04 +0530, Prasun Maiti wrote:
> iwpriv app uses iw_point structure to send data to Kernel. The
> iw_point
> structure holds a pointer. For compatibility Kernel converts the
> pointer
> as required for WEXT IOCTLs (SIOCIWFIRST to SIOCIWLAST). Some drivers
> may use iw_handler_def.private_args to populate iwpriv commands
> instead
> of iw_handler_def.private. For those case, the IOCTLs from
> SIOCIWFIRSTPRIV to SIOCIWLASTPRIV will follow the path
> ndo_do_ioctl().
> Accordingly when the filled up iw_point structure comes from 32 bit
> iwpriv to 64 bit Kernel, Kernel will not convert the pointer and
> sends
> it to driver. So, the driver may get the invalid data.
> 
Applied.

johannes
