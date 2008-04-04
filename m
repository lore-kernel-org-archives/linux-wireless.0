Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:44624 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbYDDUDD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 16:03:03 -0400
From: Michael Buesch <mb@bu3sch.de>
To: gavron@wetwork.net
Subject: Re: [PATCH RFT] b43: We need lots of regression testing
Date: Fri, 4 Apr 2008 22:02:39 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200804041612.18840.mb@bu3sch.de> <47F68931.4040205@wetwork.net>
In-Reply-To: <47F68931.4040205@wetwork.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804042202.39854.mb@bu3sch.de> (sfid-20080404_210307_238714_FC3F6E81)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 04 April 2008 22:01:53 gavron@wetwork.net wrote:
> Works great on my 4311 rev 01.

Thanks a lot for testing!

> Michael Buesch wrote:
> > Hi b43 users,
> >
> > Please be so kind to run lots of regression tests on the following
> > patch. This patch is supposed to make the LO calibration a _lot_ more
> > lightweight and avoid a long MAC-disable period every 120 seconds.
> >
> > We need a lot of regression testing with this patch on lots of different
> > devices to make sure we don't introduce regressions.
> >
> > I tested this on a 4306 and a 4318 card. So far it seems to work great
> > on these cards.
> >
> > Thanks.
> >
> >
> > ----------  Forwarded Message  ----------
> >
> > Subject: Re: b43: 1 second "freeze" every 2 minutes - works with bcm43xx
> > Date: Friday 04 April 2008
> > From: Michael Buesch <mb@bu3sch.de>
> >
> > Can you try the following patch?
> > http://bu3sch.de/patches/wireless-testing/20080404-1408/patches/010-b43-calibrate-lo-on-demand.patch
> >
> > This patch is supposed to distribute the calibration bursts over time,
> > so that calibration only happens when it's actually needed.
> > So instead of disabling the MAC every 120 secs and recalibrating the
> > whole calibration tables, we assign a timeout to each calibration value
> > and only recalibrate it if it's
> > a) expired and
> > b) currently used.
> > Recalibration might also happen on TX power adjustment, if the corresponding
> > calibration item is no longer in the cache because it has expired. That
> > actually happens most of the time, but we can live with it, as power adjustment
> > doesn't happen that often and calibration is a _lot_ cheaper.
> >
> > This patch also reduced overall memory consumption by nuking the
> > huge static calibration tables.
> >
> > Disclaimer:
> > The algorithms in this patch are completely redesigned and have nothing in
> > common with how broadcom does the stuff in the proprietary driver. So it's
> > highly experimental and I'm not responsible in case this patch eats your cat.
> >
> > -------------------------------------------------------

-- 
Greetings Michael.
