Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35135 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab1GBRJM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jul 2011 13:09:12 -0400
Received: by iyb12 with SMTP id 12so3537576iyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jul 2011 10:09:12 -0700 (PDT)
Message-ID: <4E0F50B4.3080805@lwfinger.net> (sfid-20110702_190916_299783_58C577EF)
Date: Sat, 02 Jul 2011 12:09:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: ali@internetdog.org
CC: linux-wireless@vger.kernel.org
Subject: Re: r8712u driver for the rtl8192su chip.
References: <BANLkTinw+jv8zBi29EKs2K2=tAJMYCEdgQ@mail.gmail.com> <4DC0669E.4040100@lwfinger.net> <BANLkTikxS_2wJEpijmYQy3nPy2-9pykxdA@mail.gmail.com> <4DC06BF3.6070208@lwfinger.net> <20110621124954.GA8462@internetdog.org> <4E011644.3070906@lwfinger.net> <20110622010057.GA12123@internetdog.org> <4E0154B7.2000204@lwfinger.net> <20110622025623.GC12547@internetdog.org> <4E015CE8.3000304@lwfinger.net> <20110627072351.GA4251@internetdog.org>
In-Reply-To: <20110627072351.GA4251@internetdog.org>
Content-Type: multipart/mixed;
 boundary="------------090601010707020408080402"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090601010707020408080402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 06/27/2011 02:23 AM, Ali Bahar wrote:
> Hi Larry,
>
>
> The cause is that the driver's handler for the Set expects that the
> interface is Up. In my case, it was not, and so it returns a -1. This
> pops back up the call-chain until it gets misinterpreted as an EPERM.
>
> I'll use this Set as an example, though the same pattern is seen
> elsewhere.
> Upon entry into r8711_wx_set_scan(), this check is done:
>
>     1090         if (padapter->bup == false)
>     1091                 return -1;
>
>
> The adapter structure has no comments as to what bup is (nor for
> bDriverStopped). Current usage suggests that bup indicates that the
> interface is Up (and bDriverStopped indicates that the driver has been
> cleanly stopped)

The meaning of "bup" is that it is a boolean indicating whether the interface is 
up or not, just as you surmised.

The attached patch has been floating around for a while. Does it help?

Larry


--------------090601010707020408080402
Content-Type: text/plain;
 name="r8712u_set_essid"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="r8712u_set_essid"

Index: linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
===================================================================
--- linux-2.6.orig/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -990,8 +990,6 @@ static int r8711_wx_set_wap(struct net_d
 	struct wlan_network *pnetwork = NULL;
 	enum NDIS_802_11_AUTHENTICATION_MODE	authmode;
 
-	if (padapter->bup == false)
-		return -1;
 	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY) == true)
 		return -1;
 	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING) == true)
@@ -1182,8 +1180,6 @@ static int r8711_wx_set_essid(struct net
 	struct list_head *phead;
 	u32 len;
 
-	if (padapter->bup == false)
-		return -1;
 	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY))
 		return -1;
 	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING))

--------------090601010707020408080402--
