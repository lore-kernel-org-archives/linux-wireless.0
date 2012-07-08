Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36822 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2GHOIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 10:08:16 -0400
Received: by obbuo13 with SMTP id uo13so18892967obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 07:08:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341740110.4987.4.camel@jlt3.sipsolutions.net>
References: <1341732211-25871-1-git-send-email-coelho@ti.com>
 <1341732211-25871-8-git-send-email-coelho@ti.com> <1341740110.4987.4.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 8 Jul 2012 17:08:00 +0300
Message-ID: <CA+XVXfdEqQyiyDQoAddCjC9bhH+WqmANiqf_wUCEJFi7=xG5vQ@mail.gmail.com> (sfid-20120708_160855_104003_CE701872)
Subject: Re: [PATCH 7/8] wl18xx: don't send static global struct to FW
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 8, 2012 at 12:35 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> So the subject is wrong since "&priv->conf.phy" can hardly be "static
> global", but

Yea you're right. The static global pointer was used before, now it's
a different location we copy stuff into.

>
>> We get DMA alignment trouble if the beginning of the struct is
>> unaligned. Allocate memory and send it to FW.
>
> If this is all about alignment, and
>
>> +     params = kzalloc(sizeof(*params), GFP_KERNEL);
>
> kzalloc (which is pointless -- use kmemdup) alignment is sufficient,
> then most likely you could just put "__aligned(4)" or something on the
> conf.phy struct member and not allocate memory at all?

Yea we need 4 bytes alignment. The kzalloc is a sort of convention in
the driver (see acx.c), but probably here we can use kmemdup.
We can't use fancy __aligned(4) notations most likely, since a
usermode tool also parses these header files, and it's not too smart
:)

Anyway I'll fix the subject and use kmemdup. Thanks for the review.

Arik
