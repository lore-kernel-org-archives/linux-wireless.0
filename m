Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51464 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbcHQKb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 06:31:28 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
	gregkh@linuxfoundation.org, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	dinan.gunawardena@netronome.com,
	Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCHv6 1/2] add basic register-field manipulation macros
References: <1471360704-10507-1-git-send-email-jakub.kicinski@netronome.com>
	<1471360704-10507-2-git-send-email-jakub.kicinski@netronome.com>
Date: Wed, 17 Aug 2016 13:31:21 +0300
In-Reply-To: <1471360704-10507-2-git-send-email-jakub.kicinski@netronome.com>
	(Jakub Kicinski's message of "Tue, 16 Aug 2016 16:18:23 +0100")
Message-ID: <8737m3bsau.fsf@kamboji.qca.qualcomm.com> (sfid-20160817_123201_762066_2679F75F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Kicinski <jakub.kicinski@netronome.com> writes:

> Common approach to accessing register fields is to define
> structures or sets of macros containing mask and shift pair.
> Operations on the register are then performed as follows:
>
>  field = (reg >> shift) & mask;
>
>  reg &= ~(mask << shift);
>  reg |= (field & mask) << shift;
>
> Defining shift and mask separately is tedious.  Ivo van Doorn
> came up with an idea of computing them at compilation time
> based on a single shifted mask (later refined by Felix) which
> can be used like this:
>
>  #define REG_FIELD 0x000ff000
>
>  field = FIELD_GET(REG_FIELD, reg);
>
>  reg &= ~REG_FIELD;
>  reg |= FIELD_PUT(REG_FIELD, field);
>
> FIELD_{GET,PUT} macros take care of finding out what the
> appropriate shift is based on compilation time ffs operation.
>
> GENMASK can be used to define registers (which is usually
> less error-prone and easier to match with datasheets).
>
> This approach is the most convenient I've seen so to limit code
> multiplication let's move the macros to a global header file.
> Attempts to use static inlines instead of macros failed due
> to false positive triggering of BUILD_BUG_ON()s, especially with
> GCC < 6.0.
>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Dinan Gunawardena <dinan.gunawardena@netronome.com>

Are people ok with this? I think they are useful and I can take these
through my tree, but I would prefer to get an ack from other maintainers
first. Dave? Andrew?

Full patches here:

https://patchwork.kernel.org/patch/9284153/

https://patchwork.kernel.org/patch/9284155/

-- 
Kalle Valo
