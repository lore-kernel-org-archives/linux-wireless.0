Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58400 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab1JLIbC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 04:31:02 -0400
Subject: Re: [RFC 04/07] compat-wireless: p2p power save support
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: "linux-wireless.vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bartosz MARKOWSKI <bartosz.markowski@tieto.com>,
	Janusz DZIEDZIC <janusz.dziedzic@tieto.com>
In-Reply-To: <op.v27ruwj6ya27un@edmitar> (sfid-20111012_030253_319878_2BE5AA16)
References: <op.v27ruwj6ya27un@edmitar>
	 (sfid-20111012_030253_319878_2BE5AA16)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 10:30:58 +0200
Message-ID: <1318408258.3933.27.camel@jlt3.sipsolutions.net> (sfid-20111012_103108_662052_572EBD75)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-10-12 at 03:02 +0200, Dmitry Tarnyagin wrote:
> From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> Date: Thu, 4 Aug 2011 11:42:16 +0200
> 
> P2P power save support:
>   - Opportunistic Power Save
>   - Notice Of Absence

More explanation please. I know I sound like a broken record but for
such a big change you really need more text.

I'm not even going to bother to review the patch in detail. You need to
explain why you need to set NoA. There are three reasons this would be
used:
1) actually save power
2) do scanning, multi-channel operation, etc.
3) P2P certification testing

Only 3) seems to be useful from userspace, and then maybe it shouldn't
be full-blown nl80211 API.


Similarly for the P2P power save stuff. Since you generally lack
documentation updates in your patches (read this as criticism) there's
no way reason to even look through your patches since they don't explain
anything.

FWIW, a very brief glance over this patch tells me that there's at least
one obvious, glaring bug in it.

johannes

