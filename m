Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f181.google.com ([209.85.216.181]:47601 "EHLO
	mail-px0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab0CEDsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 22:48:33 -0500
Received: by pxi11 with SMTP id 11so124737pxi.15
        for <linux-wireless@vger.kernel.org>; Thu, 04 Mar 2010 19:48:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1267760678-5421-1-git-send-email-lrodriguez@atheros.com>
References: <1267760678-5421-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 4 Mar 2010 19:48:13 -0800
Message-ID: <43e72e891003041948m5854a11fy168c275912d803d5@mail.gmail.com>
Subject: Re: [RFC 0/3] ath9k: initial work for ar9003 support
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: kevin@atheros.com, doug.dahlby@atheros.com,
	cliff.holden@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 4, 2010 at 7:44 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> We are working on supporting the AR9003 chipset family.
> This is the new 802.11n family of chipset by Atheros,
> it will include 2-stream chipsets and the new shiny 3-stream
> chipsets. The plan of attack is to support the 2-stream
> chipsets first and then move on the the 3-stream devices.
>
> The new family of chipsets are supported in the same traditional
> Atheros way of using code on the host, however the register map
> for the new chipset is now defined through an alternative approach [1].
> This essentially requires new routines for every read/write operation
> and as such requires an abstraction layer for hardware support.
>
> This first patch series illustrates the direction I'm taking so far
> for the abstraction. Please review and let me know what you think.
> Fortunately I believe we will be able to re-use some core harware
> code by implementing both generic harware callbacks and also some
> private callbacks, to be used only by hardware code itself. I
> intend on stuffing the generic harware code on hw.c and moving
> chipset specific stuff into their own files.
>
> Let me know what you think so far. If this seems peachy I'll
> continue with this strategy and complete the abstraction for
> the AR5008/AR9001/AR9002 family first. We can then work on
> the AR9003 family support by simply adding new callbacks for
> it.
>
> There are some cases where I think its pointless to keep using
> callbacks where the code is exactly the same and although we are
> using a different register definition for some families they are
> ikely 100% identical. A case I found so far was ath9k_hw_chip_test()
> and in fact I noticed we can even share this same call with
> the legacy family, through ath5k. So I think in cases like those
> where not many registers are being picked at it makes sense to
> standardize the calls accross the board, and sometimes this may
> mean sharing for all the chipset families, legacy, and all 802.11n
> including the new ar9003 family.
>
> [1] http://wireless.kernel.org/en/users/Drivers/ath9k/todo/ar93xx#Register_offset_definitions
>

I also forgot to mention that I see two advantages with this new
approach. With this abstraction in place if we really wanted to we
could try to unify ath5k/ath9k some more, although it is not one of my
own goals. Another neat advantage we can take from the new changes is
add a tracer on hw-ops.h.

  Luis
