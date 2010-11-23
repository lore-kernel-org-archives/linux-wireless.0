Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14012 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab0KWF1b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 00:27:31 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 21:27:17 -0800
Date: Tue, 23 Nov 2010 11:05:15 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath: Add a driver_info bitmask field
Message-ID: <20101123053515.GA2837@vmraj-lnx.users.atheros.com>
References: <1290165802-3566-1-git-send-email-rmanoharan@atheros.com>
 <AANLkTimTGAr5aA-CkuvezH4FXTs2SD4MnYTmWo7Ru44p@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <AANLkTimTGAr5aA-CkuvezH4FXTs2SD4MnYTmWo7Ru44p@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 23, 2010 at 02:53:36AM +0530, Bob Copeland wrote:
> On Fri, Nov 19, 2010 at 6:23 AM, Rajkumar Manoharan
> <rmanoharan@atheros.com> wrote:
> > The driver_info stores the device category information which
> > is used to load appropriate device firmware, select firmware offset
> > and eeprom starting location. The driver_info is accessed across
> > ath9k_htc and ath9k_hw. Hence placed under common structure.
> 
> >  /**
> >  * struct ath_ops - Register read/write operations
> >  *
> > @@ -147,6 +152,7 @@ struct ath_common {
> >        u8 rx_chainmask;
> >
> >        u32 rx_bufsize;
> > +       u32 driver_info;
> 
> 
> u32 for 2 bits?

Just to avoid a hole in 4-byte packing. Nothing spl.

--
Rajkumar
