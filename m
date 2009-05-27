Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:25245 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763307AbZE0MuS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 08:50:18 -0400
Received: by yw-out-2324.google.com with SMTP id 5so2601558ywb.1
        for <linux-wireless@vger.kernel.org>; Wed, 27 May 2009 05:50:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090524222027.GA32198@god.dyndns.org>
References: <20090524222027.GA32198@god.dyndns.org>
Date: Wed, 27 May 2009 08:50:19 -0400
Message-ID: <b6c5339f0905270550y50a925fbk4b891db8bbb9d9b@mail.gmail.com>
Subject: Re: ath5k in AP mode works!! (but sometimes with an oops, and a
	panic)
From: Bob Copeland <me@bobcopeland.com>
To: henk <henk@god.dyndns.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 24, 2009 at 6:20 PM, henk <henk@god.dyndns.org> wrote:
>
> First of all great work! AP mode works almost flawlessly.
>
> The only things I encounter:
> - At hostapd shutdown the kernel panics frequently, freezing up the system.
> - At startup I encounter the trace below.
> - In between the WPA2 sessions seem to work flawlessly.

Hi,

Apologies for the slow response, just returning from vacation today.

Any chance you could capture the panic at hostapd shutdown via netconsole?

> [   37.939171] WARNING: at /home/henk/compat-wireless-2009-05-22/drivers/net/wireless/ath/ath5k/base.c:2167 ath5k_beacon_update_timers+0x42/0xcd [ath5k]()

WARN_ON(!intval) -- which has been reported already for IBSS as well.
I should have
a patch shortly.

-- 
Bob Copeland %% www.bobcopeland.com
