Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f211.google.com ([209.85.220.211]:46464 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab0BHJ16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 04:27:58 -0500
Received: by fxm3 with SMTP id 3so7331434fxm.39
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 01:27:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87vde8gjx8.fsf@purkki.valot.fi>
References: <20100207214837.027dfd3d@mycelium.queued.net> <87vde8gjx8.fsf@purkki.valot.fi>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 8 Feb 2010 10:27:37 +0100
Message-ID: <69e28c911002080127o11df1a5ie123bff0fbcdc01e@mail.gmail.com>
Subject: Re: [PATCH 2/2] mac80211: give warning if building w/out rate ctrl
	algorithm
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Andres Salomon <dilinger@collabora.co.uk>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 8, 2010 at 10:23 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Andres Salomon <dilinger@collabora.co.uk> writes:
>
>> I discovered that if EMBEDDED=y, one can accidentally build a
>> mac80211 stack w/ no rate control algorithm. When RC_MINISTREL and
>> RC_PID are both disabled, the RC_DEFAULT string (which rate.c uses
>> as the fallback algorithm) will be "". That'll cause the
>> rate_control_alloc to fail, which will in turn cause
>> ieee80211_register_hw to fail. IOW, no driver will load.
>
> There are devices that don't need rate control algorithm, for example
> wl1271 (see IEEE80211_HW_HAS_RATE_CONTROL). A better solution is
> instead to fix rate_control_alloc() to handle this, or something
> similar.
>
> --
> Kalle Valo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

There is also iwlwifi (and ath9k) which use their own RC algorithms.
AFAIK they need no external RC algo either.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
