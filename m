Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:58529 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758509AbZFSUbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 16:31:39 -0400
Received: by gxk10 with SMTP id 10so3248457gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 13:31:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090619212419.2f3626d7@mjolnir.ossman.eu>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
	 <1244685780-28930-8-git-send-email-me@bobcopeland.com>
	 <20090613132144.6c7783bc@mjolnir.ossman.eu>
	 <87bposnmxi.fsf@litku.valot.fi>
	 <20090613220908.271865cd@mjolnir.ossman.eu>
	 <20090613205737.GA30439@hash.localnet>
	 <20090618022524.GC10014@hash.localnet>
	 <20090619212419.2f3626d7@mjolnir.ossman.eu>
Date: Fri, 19 Jun 2009 16:31:41 -0400
Message-ID: <b6c5339f0906191331x6c360d63wec431fc9d35b38c0@mail.gmail.com>
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
From: Bob Copeland <me@bobcopeland.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	san@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 19, 2009 at 3:24 PM, Pierre Ossman<pierre@ossman.eu> wrote:
> I'm afraid I don't understand the problem. If you power up the card
> before the MMC system has started, it should still properly find the
> card and activate the wl12xx driver once things are in sync.

Okay a little more background:

This is with the out-of-tree Android msm_sdcc host driver.  There are
various implicit assumptions in module ordering.  For example, one of
the platform callbacks sets a "virtual card select" flag, and then
tries to notify the MMC host via another callback to do
mmc_detect_change().  But that code runs before the MMC driver is
loaded so the callback isn't yet registered and no one gets the
notification.

The Android loads the TI wifi module whenever someone uses it and
then unloads it afterwards, so the current use of the msm_wifi platform
driver is always after MMC is running.  And that's why the set_power()
callbacks exist in the first place: they enable the phone to turn off
the module via gpios, disconnect external oscillators, etc. when the
person isn't actively using the wifi (i.e. module is unloaded).  A
separate platform driver could still manage all of that.

(The above is just from my reading the source, San can correct any
errors.)

IOW, this particular issue isn't related to the core in-tree code, I
was just describing why my first try failed.  I believe you that it will
work fine once the Android specifics are worked out.

> Do you want me to merge it?

It can go via the wireless tree if that's ok with you, since the
SPI driver already lives there and this all needs to be rebased
on Kalle Valo's latest changes anyway.

It'd be nice to get msm_sdcc upstream though.

-- 
Bob Copeland %% www.bobcopeland.com
