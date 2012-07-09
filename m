Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65076 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab2GIIOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 04:14:30 -0400
Received: by yenl2 with SMTP id l2so9801641yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 01:14:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341821025.4455.5.camel@jlt3.sipsolutions.net>
References: <1341732211-25871-1-git-send-email-coelho@ti.com>
 <1341732211-25871-8-git-send-email-coelho@ti.com> <1341740110.4987.4.camel@jlt3.sipsolutions.net>
 <CA+XVXfdEqQyiyDQoAddCjC9bhH+WqmANiqf_wUCEJFi7=xG5vQ@mail.gmail.com> <1341821025.4455.5.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 9 Jul 2012 11:14:14 +0300
Message-ID: <CA+XVXfdQCPTrEdDb1WY67rSKucjH=aU9S+zzkZ=xB+GW94Ty9A@mail.gmail.com> (sfid-20120709_101442_603545_C508F45D)
Subject: Re: [PATCH 7/8] wl18xx: don't send static global struct to FW
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 9, 2012 at 11:03 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2012-07-08 at 17:08 +0300, Arik Nemtsov wrote:
>
>> > kzalloc (which is pointless -- use kmemdup) alignment is sufficient,
>> > then most likely you could just put "__aligned(4)" or something on the
>> > conf.phy struct member and not allocate memory at all?
>>
>> Yea we need 4 bytes alignment. The kzalloc is a sort of convention in
>> the driver (see acx.c), but probably here we can use kmemdup.
>> We can't use fancy __aligned(4) notations most likely, since a
>> usermode tool also parses these header files, and it's not too smart
>> :)
>
> This seems like a rather bad excuse for making the runtime code more
> complex and less performant ... I'll let you sort it out with John
> though, I wouldn't let you get away with this though if I maintained the
> tree ;-)
>
> FWIW, I think your actual problem is that you mark wl18xx_priv_conf as
> packed unnecessarily. Otherwise it might actually get alignment, at
> least on ARM I hear.

It's not an excuse, we really have a usermode tool (called wlconf)
preparing binary conf files. And it usually runs on a different arch
(x86), so we mark everything packed to avoid errors.
I'm pretty sure __aligned(4) would screw up the parser there. It has
to build an internal representation of all the struct, and fill it out
using an ini file.
