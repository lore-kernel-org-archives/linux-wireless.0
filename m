Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43822 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab0JZJgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 05:36:19 -0400
Received: by fxm16 with SMTP id 16so3873908fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 02:36:17 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: Question about starting up an AP
Date: Tue, 26 Oct 2010 11:35:31 +0200
Cc: Joshua Smith <JoshuaESmith@charter.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com> <B3E6C8F9-24E4-4F12-B19C-15A474E5BCFA@charter.net> <201010151146.53640.helmut.schaa@googlemail.com>
In-Reply-To: <201010151146.53640.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010261135.31232.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag 15 Oktober 2010 schrieb Helmut Schaa:
> Am Donnerstag 14 Oktober 2010 schrieb Joshua Smith:
> > Not sure how you want to proceed with this, but this is the code that makes my AP work:
> > 
> >  nl compat-wireless-2010-09-20/drivers/net/wireless/rt2x00/rt2800lib.c | grep -C 10 1000/
> > 
> >    225	int rt2800_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev)
> >    226	{
> >    227		unsigned int i;
> >    228		u32 reg;
> >        
> >    229		for (i = 0; i < 1000/*REGISTER_BUSY_COUNT*/; i++) {
> >    230			rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
> >    231			if (!rt2x00_get_field32(reg, WPDMA_GLO_CFG_TX_DMA_BUSY) &&
> >    232			    !rt2x00_get_field32(reg, WPDMA_GLO_CFG_RX_DMA_BUSY))
> >    233				return 0;
> >        
> >    234			msleep(1);
> >    235		}
> >        
> >    236		ERROR(rt2x00dev, "WPDMA TX/RX busy, aborting.\n");
> >    237		return -EACCES;
> 
> I'll let Ivo decide on this. At least if we really want to wait more then one
> second for DMA to be ready we should increase the msleep(1) to msleep(10) and
> keep the maximum number of retries at 100.

Ping.

Ivo, do we want to add the excessive waiting (up to one second) for DMA on
rt2800 as it fixes Joshuas device? At the moment we're waiting 100ms.

Helmut
