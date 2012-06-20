Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:40712 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753865Ab2FTPHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 11:07:20 -0400
Received: by eaaa12 with SMTP id a12so3404710eaa.30
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 08:06:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340181992.4655.39.camel@jlt3.sipsolutions.net>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
	<1340111463-4554-3-git-send-email-victorg@ti.com>
	<1340181856.4655.37.camel@jlt3.sipsolutions.net>
	<1340181992.4655.39.camel@jlt3.sipsolutions.net>
Date: Wed, 20 Jun 2012 18:06:44 +0300
Message-ID: <CAK80WHYbM5sBX-pPtPZncMVgUR=-pBPUH_o9dnyhV0MvsFXz0g@mail.gmail.com> (sfid-20120620_170731_598977_53DB6F1E)
Subject: Re: [PATCH v2 3/7] nl80211/cfg80211: add ability to enable TX on op-channel
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2012 at 11:46 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Also, it seems that the value should be reset eventually ... at least on
> interface down or so. Otherwise you can start CAC, then bring the
> interface down to stop the device, and then bring it back up (CAC check
> is no longer running) and then you can use the channel after some time
> even though you never really checked for radar...
>

np, will also reset both the timestamp + new flag during interface down.

> And if you start CAC on two different devices on the same channel, but
> they happen to share channel structs in the driver then this will all
> conflict quite badly.
>

We can just return EBUSY if the radar detection has already started on
this specific channel. Btw, this is another argument why the
"radar_detect_timeout" should be per channel.


-- 
Thanks,
Victor.
