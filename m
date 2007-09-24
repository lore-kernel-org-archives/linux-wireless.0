Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:20558 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbXIXRYq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 13:24:46 -0400
Received: by py-out-1112.google.com with SMTP id u77so3031474pyb
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2007 10:24:45 -0700 (PDT)
Message-ID: <43e72e890709241024pd364c31k4a41c030f192cf0d@mail.gmail.com>
Date: Mon, 24 Sep 2007 13:24:45 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/2 try 2] Net: ath5k, split hw into hw, phy and initvals
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, "Christoph Hellwig" <hch@infradead.org>
In-Reply-To: <3175698652466923884@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <3175698652466923884@pripojeni.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/24/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> From: Nick Kossifidis <mickflemm@gmail.com>
>
> ath5k, split hw into hw, phy and initvals
>
> Separate the hw code into logical pieces hw, phy and initvals for better
> readability and maintainability.
>
> This include suggested file renames (_hw removal).
>
> Changes-licensed-under: ISC
> Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Luis R. Rodriguez <mcgrof@gmail.com>

<-- snip patch -->

> [Message clipped]
> http://mail.google.com/mail/?view=lg&msg=11536c180ed66ff1

I didn't want to take this approach before as it seemed we wanted to
try to keep drivers without their own directory and consolidate
drivers files into as many few files as necessary. Since it seems that
has changed and it has been made clear that we *can* use a directory
for each driver then I'd suggest we apply a similar patch but first
move ath5k* to ath5k/.

But anyway, I NACK this patch for the following reasons:

* Copyright (c) 2007 The MadWiFi Team

MadWifi is not a non-profit yet and as such it is advised to use
individual copyright notices.

* ath5k_hw_set_rfgain_opt() is defined once and used once, can we
instead make it inline? If we really are not going to re-use this
later why do we put it into a routine on its own?

* #if 0's need to go, lets just remove this code instead.

  Luis
