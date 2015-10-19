Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31080 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbbJSO53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 10:57:29 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bob Copeland <me@bobcopeland.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: only advertise mesh support in raw mode
References: <1443445192-30464-1-git-send-email-me@bobcopeland.com>
Date: Mon, 19 Oct 2015 17:57:12 +0300
In-Reply-To: <1443445192-30464-1-git-send-email-me@bobcopeland.com> (Bob
	Copeland's message of "Mon, 28 Sep 2015 08:59:52 -0400")
Message-ID: <87r3kqgb3r.fsf@kamboji.qca.qualcomm.com> (sfid-20151019_165737_266037_13D38332)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> Rather than always advertising mesh support and then generating
> an error when the user attempts to bring up the device without
> rawmode, only advertise it when available: that is, if the module
> is loaded with rawmode=1, the firmware supports it, and the
> device/firmware supports an AP virtual interface internally.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> Actually, I think this is perhaps worse than just spitting out an
> error on interface up, but I'm sending anyway because it was requested
> a couple of times in review.
>
> The reason this is so ugly is that the structures in question are
> defined const in the API; when also declared const in the driver,
> they go into the .rodata section and the interface limit types
> cannot be changed without causing a fault.  So this patch removes
> const in a bunch of places and adds casts to const where required.
>
> Another approach might be changing cfg80211 to silently remove interface
> types from advertised combinations when the given mode is not also
> in interface_modes, instead of warning and failing registration as it
> does today.  But this would make errors here harder to spot.
>
> Or we can keep it the way it is with the driver failing and showing an
> error on add interface.  I'm okay with any of these approaches really.

Yeah, I'm with you. It would be nice to advertise the mesh feature on
when the firmware supports it, but I think this is just too complicated.
So I'm dropping this for now, but we can revisit later if there's a need
for that.

-- 
Kalle Valo
