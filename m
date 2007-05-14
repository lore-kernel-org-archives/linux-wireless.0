Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:44685 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbXENPCB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2007 11:02:01 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1358713uga
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2007 08:01:53 -0700 (PDT)
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH v3 1/2] Add 93cx6 eeprom library
Date: Mon, 14 May 2007 17:00:21 +0200
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200705140138.52596.flamingice@sourmilk.net> <a32f33a40705132349h367ba18aoa046d5583329ead@mail.gmail.com> <200705141056.01199.flamingice@sourmilk.net>
In-Reply-To: <200705141056.01199.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200705141700.21900.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 May 2007 16:55, Michael Wu wrote:
> On Monday 14 May 2007 02:49, Ivo Van Doorn wrote:
> > For the record: I am still not happy with the removal of the udelay() from
> > the pulse methods as they were indicated by the original Ralink code.
> > But since I cannot test the effect on Ralink eeprom reading at this time,
> > and I could otherwise just add it to the register_write handler if
> > required, I am signing this off anyway.
> >
> The udelay is necessary to set a limit on how fast the eeprom is operated.. 
> but not on all hardware, apparently. adm8211 just uses a read from the eeprom 
> register to perform the delay.

Ok, then I'll update rt2x00 to perform the delay during register_write as well. :)

Ivo
