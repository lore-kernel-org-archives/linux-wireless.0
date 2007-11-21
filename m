Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:53242 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbXKUSq2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 13:46:28 -0500
Date: Wed, 21 Nov 2007 10:44:59 -0800
To: Shaddy Baddah <shaddy_baddah@hotmail.com>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Message-ID: <20071121184459.GA17199@bougret.hpl.hp.com> (sfid-20071121_184632_575060_66C95853)
Reply-To: jt@hpl.hp.com
References: <4740DF47.4040206@hotmail.com> <20071119.002755.77617097.davem@davemloft.net> <1195484582.8642.18.camel@johannes.berg> <20071119180423.GA19250@bougret.hpl.hp.com> <47443035.1070702@hotmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
In-Reply-To: <47443035.1070702@hotmail.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 22, 2007 at 12:18:45AM +1100, Shaddy Baddah wrote:
> Hi Jean
> 

	Hi,

	I decided to reorganise things a bit... Here are my answers...

> >	Definitely, it sounds familiar.
> >	This is that I need :
> >		o version of the kernel
> 
> Debian sparc64 2.6.22 (built myself, using make-kpg, to include the driver)

	The patch from Masakazu Mokuno I was talking about is not in
your kernel. It defintely would explain why you would get the
"Encryption key:<too big>". Basically the length of any variable field
is not properly return to user space. This patch would fix that
problem.
	The patch from Masakazu Mokuno is not in 2.6.22, and it not
either in 2.6.14. The patch is only included in 2.6.23 and later. I
would suggest upgrading to 2.6.23 to get that patch. Alternatively,
I've included the patch as attachement, and you can use it with
2.6.22.
	I would like you to try that patch and report.

> >	Can you give me the exact error text as reported by iwconfig ?
> >I'll probably have to send you a test version to see what's happening
> >under the cover.
> 
> Please find this in-lined below (with key protected):
> 
> # iwconfig eth2
> eth2      IEEE 802.11b/g  ESSID:off/any  Nickname:"zd1211"
>           Mode:Managed  Frequency:2.462 GHz  Access Point: Invalid
>           Bit Rate=1 Mb/s
>           Encryption key:<too big>

	Note that under Wireless Tools 30, you will notice that it
won't return too bug but will print an absurdly long encryption
key. Two symptoms of the same bug.

> >		o version of Wireless Tools (iwconfig --version).
> >	Most likely, you need to upgrade your Wireless Tools to
> >version 29 which fixes this 32/64 interop problem.
> >	With the latest kernel and the latest wireless tools, the only
> >known bugs are the two ESSID bugs.
> 
> I think I'm right for version:
> # iwconfig --version
> iwconfig  Wireless-Tools version 29
>           Compatible with Wireless Extension v11 to v22.
> 
> Kernel    Currently compiled with Wireless Extension v22.
> 
> eth2      Recommend Wireless Extension v20 or later,
>           Currently compiled with Wireless Extension v22.

	Yep, that's the correct version. I was afraid you were running
Debian stable. I'll need to dig up a little bit more in this.
	Note that the patch above *may* help with this issue as well.

> Hope that helps.
> 
> Regards,
> Shaddy

	Have fun...

	Jean

--jI8keyz6grp/JLjh
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="iw262_return_compat_ioctl.diff"

As struct iw_point is bi-directional payload, we should copy back the content
on return from ioctl calls

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 fs/compat_ioctl.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -2311,8 +2311,10 @@ static int do_wireless_ioctl(unsigned in
 	struct iwreq __user *iwr_u;
 	struct iw_point __user *iwp;
 	struct compat_iw_point __user *iwp_u;
-	compat_caddr_t pointer;
+	compat_caddr_t pointer_u;
+	void __user *pointer;
 	__u16 length, flags;
+	int ret;
 
 	iwr_u = compat_ptr(arg);
 	iwp_u = (struct compat_iw_point __user *) &iwr_u->u.data;
@@ -2330,17 +2332,29 @@ static int do_wireless_ioctl(unsigned in
 			   sizeof(iwr->ifr_ifrn.ifrn_name)))
 		return -EFAULT;
 
-	if (__get_user(pointer, &iwp_u->pointer) ||
+	if (__get_user(pointer_u, &iwp_u->pointer) ||
 	    __get_user(length, &iwp_u->length) ||
 	    __get_user(flags, &iwp_u->flags))
 		return -EFAULT;
 
-	if (__put_user(compat_ptr(pointer), &iwp->pointer) ||
+	if (__put_user(compat_ptr(pointer_u), &iwp->pointer) ||
 	    __put_user(length, &iwp->length) ||
 	    __put_user(flags, &iwp->flags))
 		return -EFAULT;
 
-	return sys_ioctl(fd, cmd, (unsigned long) iwr);
+	ret = sys_ioctl(fd, cmd, (unsigned long) iwr);
+
+	if (__get_user(pointer, &iwp->pointer) ||
+	    __get_user(length, &iwp->length) ||
+	    __get_user(flags, &iwp->flags))
+		return -EFAULT;
+
+	if (__put_user(ptr_to_compat(pointer), &iwp_u->pointer) ||
+	    __put_user(length, &iwp_u->length) ||
+	    __put_user(flags, &iwp_u->flags))
+		return -EFAULT;
+
+	return ret;
 }
 
 /* Since old style bridge ioctl's endup using SIOCDEVPRIVATE

--jI8keyz6grp/JLjh--
