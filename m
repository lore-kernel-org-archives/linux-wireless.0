Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:50705 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbXJPA67 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 20:58:59 -0400
Date: Mon, 15 Oct 2007 17:57:11 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jean Tourrilhes <jt@hpl.hp.com>, Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlist and network-manager bug report
Message-ID: <20071016005711.GA10957@bougret.hpl.hp.com> (sfid-20071016_015902_383886_1F10BCFB)
Reply-To: jt@hpl.hp.com
References: <1189526874.6161.30.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1189526874.6161.30.camel@johannes.berg>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 11, 2007 at 06:07:53PM +0200, Johannes Berg wrote:
> Hi Jean,

	Hi again,

> Anyhow, the problem is that my landlord has an AP that broadcasts an
> SSID with a 0xFC byte in it (supposedly an "=FC" in windows). iwlist,
> however, just prints
>=20
> 		ESSID:"B

	You remember that problem ? Well, we now have a new version of
Wireless Tools that support that. However, this is blocked because the
necessary kernel patch has not gone yet in the kernel.
	I've sent the patch to John twice, with you in cc for the last
occurence. It seems that John for some reason does not receive e-mail
from me, or something else. This was the last time :
		http://marc.info/?l=3Dlinux-wireless&m=3D119022849315111&w=3D2
	So, would you mind pushing yourself this patch to John ?
	Thanks in advance...

	Jean

Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>

-----------------------------------------------------------

--- linux/net/wireless/wext.j1.c	2007-07-09 13:19:22.000000000 -0700
+++ linux/net/wireless/wext.c	2007-07-09 13:19:59.000000000 -0700
@@ -741,39 +741,11 @@ static int ioctl_standard_call(struct ne
 		int	extra_size;
 		int	user_length =3D 0;
 		int	err;
-		int	essid_compat =3D 0;
=20
 		/* Calculate space needed by arguments. Always allocate
 		 * for max space. Easier, and won't last long... */
 		extra_size =3D descr->max_tokens * descr->token_size;
=20
-		/* Check need for ESSID compatibility for WE < 21 */
-		switch (cmd) {
-		case SIOCSIWESSID:
-		case SIOCGIWESSID:
-		case SIOCSIWNICKN:
-		case SIOCGIWNICKN:
-			if (iwr->u.data.length =3D=3D descr->max_tokens + 1)
-				essid_compat =3D 1;
-			else if (IW_IS_SET(cmd) && (iwr->u.data.length !=3D 0)) {
-				char essid[IW_ESSID_MAX_SIZE + 1];
-
-				err =3D copy_from_user(essid, iwr->u.data.pointer,
-						     iwr->u.data.length *
-						     descr->token_size);
-				if (err)
-					return -EFAULT;
-
-				if (essid[iwr->u.data.length - 1] =3D=3D '\0')
-					essid_compat =3D 1;
-			}
-			break;
-		default:
-			break;
-		}
-
-		iwr->u.data.length -=3D essid_compat;
-
 		/* Check what user space is giving us */
 		if (IW_IS_SET(cmd)) {
 			/* Check NULL pointer */
@@ -811,7 +783,6 @@ static int ioctl_standard_call(struct ne
 		}
=20
 		/* Create the kernel buffer */
-		/*    kzalloc ensures NULL-termination for essid_compat */
 		extra =3D kzalloc(extra_size, GFP_KERNEL);
 		if (extra =3D=3D NULL)
 			return -ENOMEM;
@@ -830,8 +801,6 @@ static int ioctl_standard_call(struct ne
 		/* Call the handler */
 		ret =3D handler(dev, &info, &(iwr->u), extra);
=20
-		iwr->u.data.length +=3D essid_compat;
-
 		/* If we have something to return to the user */
 		if (!ret && IW_IS_GET(cmd)) {
 			/* Check if there is enough buffer up there */

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
