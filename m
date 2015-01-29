Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:56243 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbbA2Iaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 03:30:35 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: b43: Fix locking FIXME in beacon update top half
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20150126182617.521f58b5@wiggum>
To: =?utf-8?q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20150129083034.A6A7313FF8F@smtp.codeaurora.org> (sfid-20150129_093038_567720_6922D9D7)
Date: Thu, 29 Jan 2015 08:30:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> b43 has a FIXME about locking in the mac80211 set-beacon-int callback for a long time.
> As it turns out there actually is a tiny race window that could result in
> a use-after-free bug of the 'current_beacon' memory.
> Nobody ever reported this, so it probably never happened.
> 
> Fix this by adding a spin lock that protects the current_beacon access.
> We must not be in atomic context while accessing hardware (due to SDIO),
> so the beacon update bottom half has to clone the skb and release the lock
> before writing it to hardware.
> 
> Let's all hope that this stops the troll who is trying to submit incorrect
> fixes for this issue repeatedly.
> And let's hope that I'm not a troll, too, who just hides even more evil code
> in an even more complex attempt to fix the issue.
> 
> Signed-off-by: Michael Buesch <m@bues.ch>
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
