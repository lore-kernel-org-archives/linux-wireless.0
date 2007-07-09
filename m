Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MGW2.Sony.CO.JP ([137.153.0.14]:61495 "EHLO mgw2.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbXGIMAS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 08:00:18 -0400
Received: from mail36.sony.co.jp (localhost [127.0.0.1])
	by mail36.sony.co.jp (R8/Sony) with ESMTP id l69C0Gct025129
	for <linux-wireless@vger.kernel.org>; Mon, 9 Jul 2007 21:00:16 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
	by mail36.sony.co.jp (R8/Sony) with ESMTP id l69C0GKu025121
	for <linux-wireless@vger.kernel.org>; Mon, 9 Jul 2007 21:00:16 +0900 (JST)
Date: Mon, 09 Jul 2007 21:00:16 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: alignment issue between 32bit userland and 64bit kernel
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	geoffrey.levand@am.sony.com
Message-Id: <20070709201037.D02C.MOKUNO@sm.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi,

While developing the wireless support for PS3, I'd noticed there were alignment
issues if we issued some wireless ioctl from 32bit userland to 64bit
kernel (ppc64 PS3 does have). 

 - IW_EV_LCP_LEN in 32bit userland and 64bit kernel differ
 - offsetof(struct iw_point, length) differ

The former issue could be fixed if we added 'packed' attribute to
iw_event structure, but it would break existing 64bit userland.  I have
no idea to resolve latter issue because the first member of struct
iw_point is a pointer.

Does anyone have idea to fix these issues?
(except compiling all userland apps in 64bit mode...)

The following is the output from a test code on my PS3.

> # cat test.c
> #include <stdio.h>
> #include <netdb.h>
> #include <linux/wireless.h>
> /* packed version */
> struct iw_event_p {
>   __u16         len;
>   __u16         cmd;
>   union iwreq_data      u;
> } __attribute__((packed));
> 
> int main(void)
> {
>   printf("IW_EV_LCP_LEN=%d offset=%d,%d\n",
>          IW_EV_LCP_LEN,
>          offsetof(struct iw_event, u),
>          offsetof(struct iw_event_p, u));
>   printf("iw_event=%d iw_event_p=%d iwreq_data=%d\n",
>          sizeof(struct iw_event),
>          sizeof(struct iw_event_p),
>          sizeof(union iwreq_data));
> 
>   /* --- */
> 
>   printf("iw_point=%d length=%d flags=%d\n",
>          sizeof(struct iw_point),
>          offsetof(struct iw_point, length),
>          offsetof(struct iw_point, flags));
>   return 0;
> }
> # cc -m64 -o test_64 test.c; cc -o test_32  test.c
> # ./test_64
> IW_EV_LCP_LEN=8 offset=8,4
> iw_event=24 iw_event_p=20 iwreq_data=16
> iw_point=16 length=8 flags=10
> # ./test_32
> IW_EV_LCP_LEN=4 offset=4,4
> iw_event=20 iw_event_p=20 iwreq_data=16
> iw_point=8 length=4 flags=6
> # 

regards

--
Masakazu MOKUNO

