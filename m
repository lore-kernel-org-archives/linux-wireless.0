Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Bass.Opus1.COM ([192.245.12.9]:2718 "EHLO bass.opus1.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757779AbYDDUB5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 16:01:57 -0400
Received: from egdell.wetwork.net ([204.17.34.178])
 by Opus1.COM (PMDF V6.2-X27 #9830)
 with ESMTPSA id <01MT8744B9ZU8ZQVGB@Opus1.COM> for
 linux-wireless@vger.kernel.org; Fri, 04 Apr 2008 13:01:54 -0700 (MST)
Date: Fri, 04 Apr 2008 13:01:53 -0700
From: gavron@wetwork.net
Subject: Re: [PATCH RFT] b43: We need lots of regression testing
In-reply-to: <200804041612.18840.mb@bu3sch.de>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Message-id: <47F68931.4040205@wetwork.net> (sfid-20080404_210159_458526_56ACED8C)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
References: <200804041612.18840.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Works great on my 4311 rev 01.
E

Michael Buesch wrote:
> Hi b43 users,
>
> Please be so kind to run lots of regression tests on the following
> patch. This patch is supposed to make the LO calibration a _lot_ more
> lightweight and avoid a long MAC-disable period every 120 seconds.
>
> We need a lot of regression testing with this patch on lots of different
> devices to make sure we don't introduce regressions.
>
> I tested this on a 4306 and a 4318 card. So far it seems to work great
> on these cards.
>
> Thanks.
>
>
> ----------  Forwarded Message  ----------
>
> Subject: Re: b43: 1 second "freeze" every 2 minutes - works with bcm43xx
> Date: Friday 04 April 2008
> From: Michael Buesch <mb@bu3sch.de>
>
> Can you try the following patch?
> http://bu3sch.de/patches/wireless-testing/20080404-1408/patches/010-b43-calibrate-lo-on-demand.patch
>
> This patch is supposed to distribute the calibration bursts over time,
> so that calibration only happens when it's actually needed.
> So instead of disabling the MAC every 120 secs and recalibrating the
> whole calibration tables, we assign a timeout to each calibration value
> and only recalibrate it if it's
> a) expired and
> b) currently used.
> Recalibration might also happen on TX power adjustment, if the corresponding
> calibration item is no longer in the cache because it has expired. That
> actually happens most of the time, but we can live with it, as power adjustment
> doesn't happen that often and calibration is a _lot_ cheaper.
>
> This patch also reduced overall memory consumption by nuking the
> huge static calibration tables.
>
> Disclaimer:
> The algorithms in this patch are completely redesigned and have nothing in
> common with how broadcom does the stuff in the proprietary driver. So it's
> highly experimental and I'm not responsible in case this patch eats your cat.
>
> -------------------------------------------------------
>
>   
