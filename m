Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59024 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab0JOKLB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 06:11:01 -0400
Received: by mail-bw0-f46.google.com with SMTP id 15so819562bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 03:11:00 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Joshua Smith <JoshuaESmith@charter.net>
Subject: Re: Question about starting up an AP
Date: Fri, 15 Oct 2010 11:46:53 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, Ivo van Doorn <ivdoorn@gmail.com>
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com> <201010010742.07605.helmut.schaa@googlemail.com> <B3E6C8F9-24E4-4F12-B19C-15A474E5BCFA@charter.net>
In-Reply-To: <B3E6C8F9-24E4-4F12-B19C-15A474E5BCFA@charter.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010151146.53640.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 14 Oktober 2010 schrieb Joshua Smith:
> OK, I finally got a chance to run the test.  Before doing the revert, I
> tried just using the current drivers, but with a ridiculously large
> number of retries.

Thanks for testing.

> Lo and behold: no error.  So I think this is the reason the old drivers
> were working for me, not anything that happened between July and September. 
> When I went back to the old drivers, I had made this change, and they
> worked.  I figured it was because I was using the old drivers, but now I
> realize it is because of this change.
> 
> Also, I can see the behavior pretty clearly.  Sometimes when I start up
> hostapd, it starts right up, and sometimes it takes about a second, and then
> starts up.  So it looks like this retry number just needs to be really,
> really big.  (Note that with this change in the old drivers, on very rare
> occasions, I still see the "busy, aborting" error.  So perhaps it should
> be even bigger than 1000?)
> 
> Not sure how you want to proceed with this, but this is the code that makes my AP work:
> 
>  nl compat-wireless-2010-09-20/drivers/net/wireless/rt2x00/rt2800lib.c | grep -C 10 1000/
> 
>    225	int rt2800_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev)
>    226	{
>    227		unsigned int i;
>    228		u32 reg;
>        
>    229		for (i = 0; i < 1000/*REGISTER_BUSY_COUNT*/; i++) {
>    230			rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
>    231			if (!rt2x00_get_field32(reg, WPDMA_GLO_CFG_TX_DMA_BUSY) &&
>    232			    !rt2x00_get_field32(reg, WPDMA_GLO_CFG_RX_DMA_BUSY))
>    233				return 0;
>        
>    234			msleep(1);
>    235		}
>        
>    236		ERROR(rt2x00dev, "WPDMA TX/RX busy, aborting.\n");
>    237		return -EACCES;

I'll let Ivo decide on this. At least if we really want to wait more then one
second for DMA to be ready we should increase the msleep(1) to msleep(10) and
keep the maximum number of retries at 100.

Joshua, did you ever ran the ralink legacy driver? Because that one also waits
a maximum of 100ms and thus would also fail sometimes ...

Helmut
