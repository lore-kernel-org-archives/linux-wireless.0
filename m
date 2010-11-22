Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36577 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab0KVVdt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 16:33:49 -0500
Received: by fxm13 with SMTP id 13so3089015fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 13:33:48 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 1/4] ath: Add a driver_info bitmask field
Date: Mon, 22 Nov 2010 22:33:30 +0100
Cc: Rajkumar Manoharan <rmanoharan@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1290165802-3566-1-git-send-email-rmanoharan@atheros.com> <AANLkTimTGAr5aA-CkuvezH4FXTs2SD4MnYTmWo7Ru44p@mail.gmail.com>
In-Reply-To: <AANLkTimTGAr5aA-CkuvezH4FXTs2SD4MnYTmWo7Ru44p@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011222233.31346.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 November 2010 22:23:36 Bob Copeland wrote:
> On Fri, Nov 19, 2010 at 6:23 AM, Rajkumar Manoharan
> <rmanoharan@atheros.com> wrote:
> > The driver_info stores the device category information which
> > is used to load appropriate device firmware, select firmware offset
> > and eeprom starting location. The driver_info is accessed across
> > ath9k_htc and ath9k_hw. Hence placed under common structure.
> 
> >  /**
> >  * struct ath_ops - Register read/write operations
> >  *
> > @@ -147,6 +152,7 @@ struct ath_common {
> >        u8 rx_chainmask;
> >
> >        u32 rx_bufsize;
> > +       u32 driver_info;
> 
> 
> u32 for 2 bits?
 
well, if you take in account that mod_devicetable.h specifies
driver_info to be kernel_ulong_t... (to store pointers of course)

I would say we need "even" more.

Best regards,
	Chr
