Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47330 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab1K1BSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 20:18:47 -0500
Received: by vcbfk14 with SMTP id fk14so3249287vcb.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2011 17:18:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmok08evQX-iZ3H2F3gmBGv2rfavp+4L3tezt-Rvp9Zu68A@mail.gmail.com>
References: <1322439734-14520-1-git-send-email-mar.kolya@gmail.com>
	<CAJ-Vmok08evQX-iZ3H2F3gmBGv2rfavp+4L3tezt-Rvp9Zu68A@mail.gmail.com>
Date: Mon, 28 Nov 2011 09:18:47 +0800
Message-ID: <CAJ-VmomQL+eXypH+t_rA53jg_g_M5RVahMZ4ciVoA2GzC-Tw+A@mail.gmail.com> (sfid-20111128_021851_291659_DD33424A)
Subject: Re: [PATCH v2 0/4] Fix the way ANI is being handled for ar9100 and ar9340
From: Adrian Chadd <adrian@freebsd.org>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. thinking about it, can you please log some data with ANI disabled
and enabled, so we can see exactly what is going on?

Something missing (from both freebsd and linux) is visibility into
exactly what the ANI code is doing. You can turn on logging to see
when the parameters are twiddled, but there's no easy way to log and
graph what effect the ANI parameters are having.

FreeBSD is slightly ahead here - I can log the tx/rx frames, ofdm/cck
phy error rate and then when the parameters are changed; but the
driver/HAL doesn't (currently) export what those values are to the
athstats program.

I think we'd all be better off if we had some tools to graph/analyse
this kind of stuff; we could then figure out if it's having any kind
of effect.

Thanks for chasing this up! I'm currently hacking on my openwrt (sort
of) inspired build system for FreeBSD, targetting an AR913x device. So
this is quite relevant to me at the present moment. :)



Adrian
