Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:65458 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821AbXLDRz7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 12:55:59 -0500
Date: Tue, 4 Dec 2007 09:55:52 -0800
To: Sunny Kim <sungyi.kim@samsung.com>
Cc: ????????? <trukhin.vladimir@samsung.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [wireless.c bug report] 32 character ESSID not displayed in iwconfig
Message-ID: <20071204175552.GA12545@bougret.hpl.hp.com> (sfid-20071204_175625_068061_051A16DB)
Reply-To: jt@hpl.hp.com
References: <0JSI00BH8E2H36@ms2.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0JSI00BH8E2H36@ms2.samsung.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 04, 2007 at 05:03:53AM +0000, Sunny Kim wrote:
> Hi, I'm Sunny Kim from SAMSUNG Electro-Mechanics.
> I want to give you a bug report.
> Please, see my pdf doc attached.
> I hope you find this helpful.
> 
> < the first part of pdf doc >
> Title: 32 character ESSID not displayed in iwconfig
> Reported by: Sunny Kim (sungyi.kim@samsung.com)
> Detail descriptions:
> I found the problem in net/core/wireless.c when ESSID was 32 character long.
> This problem prevents iwconfig from displaying ESSID correctly when ESSID is 32 character long. 
> 
> Regards,
> Sunny Kim

	Hi,

	Thanks for the bug report. This bug is well known and has been
reported to me many times over the last 6 months. The kernel
maintainers don't want to fix it. The patch for the 2.6.22 and later
is attached to this e-mail.
	Have fun...

	Jean

----------------------------------------------------------

--- linux/net/wireless/wext.j1.c	2007-07-09 13:19:22.000000000 -0700
+++ linux/net/wireless/wext.c	2007-07-09 13:19:59.000000000 -0700
@@ -741,39 +741,11 @@ static int ioctl_standard_call(struct ne
 		int	extra_size;
 		int	user_length = 0;
 		int	err;
-		int	essid_compat = 0;
 
 		/* Calculate space needed by arguments. Always allocate
 		 * for max space. Easier, and won't last long... */
 		extra_size = descr->max_tokens * descr->token_size;
 
-		/* Check need for ESSID compatibility for WE < 21 */
-		switch (cmd) {
-		case SIOCSIWESSID:
-		case SIOCGIWESSID:
-		case SIOCSIWNICKN:
-		case SIOCGIWNICKN:
-			if (iwr->u.data.length == descr->max_tokens + 1)
-				essid_compat = 1;
-			else if (IW_IS_SET(cmd) && (iwr->u.data.length != 0)) {
-				char essid[IW_ESSID_MAX_SIZE + 1];
-
-				err = copy_from_user(essid, iwr->u.data.pointer,
-						     iwr->u.data.length *
-						     descr->token_size);
-				if (err)
-					return -EFAULT;
-
-				if (essid[iwr->u.data.length - 1] == '\0')
-					essid_compat = 1;
-			}
-			break;
-		default:
-			break;
-		}
-
-		iwr->u.data.length -= essid_compat;
-
 		/* Check what user space is giving us */
 		if (IW_IS_SET(cmd)) {
 			/* Check NULL pointer */
@@ -811,7 +783,6 @@ static int ioctl_standard_call(struct ne
 		}
 
 		/* Create the kernel buffer */
-		/*    kzalloc ensures NULL-termination for essid_compat */
 		extra = kzalloc(extra_size, GFP_KERNEL);
 		if (extra == NULL)
 			return -ENOMEM;
@@ -830,8 +801,6 @@ static int ioctl_standard_call(struct ne
 		/* Call the handler */
 		ret = handler(dev, &info, &(iwr->u), extra);
 
-		iwr->u.data.length += essid_compat;
-
 		/* If we have something to return to the user */
 		if (!ret && IW_IS_GET(cmd)) {
 			/* Check if there is enough buffer up there */
