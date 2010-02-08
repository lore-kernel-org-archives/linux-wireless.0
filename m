Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f202.google.com ([209.85.216.202]:57740 "EHLO
	mail-px0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab0BHSdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 13:33:11 -0500
Received: by pxi40 with SMTP id 40so6716606pxi.21
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 10:33:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100207214837.027dfd3d@mycelium.queued.net>
References: <20100207214837.027dfd3d@mycelium.queued.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 8 Feb 2010 10:32:50 -0800
Message-ID: <43e72e891002081032i6e96ab08i345c911e44e95bd2@mail.gmail.com>
Subject: Re: [PATCH 2/2] mac80211: give warning if building w/out rate ctrl
	algorithm
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 7, 2010 at 6:48 PM, Andres Salomon <dilinger@collabora.co.uk> wrote:
>
> I discovered that if EMBEDDED=y, one can accidentally build a mac80211 stack
> w/ no rate control algorithm.  When RC_MINISTREL and RC_PID are both disabled,
> the RC_DEFAULT string (which rate.c uses as the fallback algorithm) will be
> "".  That'll cause the rate_control_alloc to fail, which will in turn cause
> ieee80211_register_hw to fail.  IOW, no driver will load.
>
> This will tell kconfig to provide a warning if no rate control algorithms
> have been selected.  That'll at least warn the user that they're about to
> build a broken wireless stack.


Please Cc: stable@kernel.org here as well, I think we've had this for a while.

> Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>

  Luis
