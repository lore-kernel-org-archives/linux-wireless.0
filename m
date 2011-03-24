Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34121 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab1CXNTz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 09:19:55 -0400
Subject: Re: Aggregation problem with rt2800 AP and Intel 5100 STA
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <201103241409.03170.helmut.schaa@googlemail.com>
References: <201103232358.29966.helmut.schaa@googlemail.com>
	 <AANLkTi=BLTJhxYf552GLW1zG-AvVdeKj86e2K-vEm_Wy@mail.gmail.com>
	 <201103240836.45753.helmut.schaa@googlemail.com>
	 <201103241409.03170.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 14:19:53 +0100
Message-ID: <1300972793.26265.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-03-24 at 14:09 +0100, Helmut Schaa wrote:

> Ok, found out some more. The problem now seems to trigger only if the Intel STA
> leaves powersave and mac80211 dropped a frame while the STA was sleeping (either
> due to the size of the STA PS buffer or due to a race between rx/tx processing).

Why do we even have aggregation sessions active while the station goes
to sleep? Is it scanning?

Maybe the PS buffer should be larger then? I don't see how we can lose a
frame due to rx/tx processing races either, how does that happen? I
thought we had the ability to avoid all those races now.

> This can also cause a sequence number hole in the STAs rx reordering buffer but
> we won't send a BAR in that case ending in the same situation that the Intel STA
> BlockAcks AMPDUs to it but doesn't pass them to the user space.
> 
> Johannes, does it make sense to always send a BAR when a STA wakes up from
> sleep and we've got an active aggregation session?

I don't know, you tell me, does it? :)

joahnnes

