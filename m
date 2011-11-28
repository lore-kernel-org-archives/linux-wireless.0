Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40038 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab1K1CfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 21:35:14 -0500
Received: by wwp14 with SMTP id 14so8039135wwp.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2011 18:35:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmomQL+eXypH+t_rA53jg_g_M5RVahMZ4ciVoA2GzC-Tw+A@mail.gmail.com>
References: <1322439734-14520-1-git-send-email-mar.kolya@gmail.com>
	<CAJ-Vmok08evQX-iZ3H2F3gmBGv2rfavp+4L3tezt-Rvp9Zu68A@mail.gmail.com>
	<CAJ-VmomQL+eXypH+t_rA53jg_g_M5RVahMZ4ciVoA2GzC-Tw+A@mail.gmail.com>
Date: Sun, 27 Nov 2011 21:35:12 -0500
Message-ID: <CALGY4ft4H_1EfSfAhnzfzuPFO7A-G6mZ3N-f0bp+ad3R3KHusw@mail.gmail.com> (sfid-20111128_033524_392305_D37ED2D0)
Subject: Re: [PATCH v2 0/4] Fix the way ANI is being handled for ar9100 and ar9340
From: Nikolay Martynov <mar.kolya@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

  I have a router with ar9102 and I did some logging on ANI before. It
does display some changing values overtime (an it is actually possible
to turn on this logging via debug sysfs file). Moreover, as I've
mentioned in comments to patch - ANI was always enabled for those
devices in ath9k driver, but it was not initialized properly during
card initialization. So I think my patch should not make things worse
then it was before for any hardware. And it might make them better for
some. I personally was running my router with this patch for more then
week now without any problems, so I do not think I can tell that ANI
part is missing from my hardware. Also, openwrt recently incorporated
similar thing as a separate patch for 9100 devices.
  I'll try to do a bit more extensive logging later.

2011/11/27 Adrian Chadd <adrian@freebsd.org>:
> .. thinking about it, can you please log some data with ANI disabled
> and enabled, so we can see exactly what is going on?
>
> Something missing (from both freebsd and linux) is visibility into
> exactly what the ANI code is doing. You can turn on logging to see
> when the parameters are twiddled, but there's no easy way to log and
> graph what effect the ANI parameters are having.
>
> FreeBSD is slightly ahead here - I can log the tx/rx frames, ofdm/cck
> phy error rate and then when the parameters are changed; but the
> driver/HAL doesn't (currently) export what those values are to the
> athstats program.
>
> I think we'd all be better off if we had some tools to graph/analyse
> this kind of stuff; we could then figure out if it's having any kind
> of effect.
>
> Thanks for chasing this up! I'm currently hacking on my openwrt (sort
> of) inspired build system for FreeBSD, targetting an AR913x device. So
> this is quite relevant to me at the present moment. :)
>
>
>
> Adrian
>



-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
