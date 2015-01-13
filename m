Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:35989 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbbAMVG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 16:06:26 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21685.35179.110539.780864@gargle.gargle.HOWL> (sfid-20150113_220629_479496_B7F10A1D)
Date: Wed, 14 Jan 2015 02:38:59 +0530
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
In-Reply-To: <87r3uy4t9y.fsf@kamboji.qca.qualcomm.com>
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
	<87r3uy4t9y.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> I'm not sure if I really like this path of having interfaces to
> configure driver internals. I suspect that if we add this, we will have
> even more later. It's a lot more documenting for us and more work to the
> users to understand what parameters they should use. Also this means
> that testing will be more challenging as people will use different
> values and results won't be comparable.
> 
> Isn't there any other way to solve the problem? Like automatically
> changing the value somehow (no idea how) or some other means?

We are limiting performance by restricting the fill size. A user
will just use the default, which is still the same and remains
unchanged. But, having a way to adjust this based on the platform
seems reasonable to me and I think trying to change this value dynamically
is overkill.

> Or if nothing else helps, a crazy idea is to have some sort of platform
> profile parameter:
> 
> 0 = auto
> 1 = slow
> 2 = fast
> 3 = superfast (x86)
> 
> And then we would have preset values (not just htt_fill_size) within
> ath10k and they get chosen based on the profile configured.

I don't think a network driver should limit its performance with
such profiles. Moreover, x86 can be slow too - at least, my 4 year
old machine is. :-)

Sujith
