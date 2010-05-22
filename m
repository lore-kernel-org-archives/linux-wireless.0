Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:52062 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809Ab0EVTIu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 May 2010 15:08:50 -0400
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Fix rx of mcast/bcast frames in PS mode with auto sleep
References: <1274229062-10412-1-git-send-email-vasanth@atheros.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 22 May 2010 22:08:48 +0300
In-Reply-To: <1274229062-10412-1-git-send-email-vasanth@atheros.com> (Vasanthakumar Thiagarajan's message of "Tue\, 18 May 2010 17\:31\:02 -0700")
Message-ID: <8739xjiwjj.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vasanth@atheros.com> writes:

> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Please describe more, this isn't very informative (if any). Especially
try to answer in the commit log:

o What was the original bug? How and why did it happen?
o How was it visible to the user?
o How does the fix actually fix the issue?
o In what version was the bug introduced? This helps backporters.

Powersave in 802.11 is very fragile and more information there is, the
easier it is to handle the issues.

> +#define ATH9K_CHECK_AUTO_SLEEP(__sc) \
> +	(__sc->ps_enabled && \
> +	(__sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP))

Like Andrew Morton says: use C instead of CPP. Meaning that this can
be an inline function instead of a macro.

-- 
Kalle Valo
