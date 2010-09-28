Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43309 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab0I1Lf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 07:35:56 -0400
Received: by mail-fx0-f46.google.com with SMTP id 3so2492292fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Sep 2010 04:35:55 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Dale Turner <rx_guy@hotmail.com>
Subject: Re: carl9170 problem
Date: Tue, 28 Sep 2010 13:35:44 +0200
Cc: linux-wireless@vger.kernel.org
References: <SNT113-W182B461295E717BB27130BF1630@phx.gbl> <201009260057.38286.chunkeey@googlemail.com> <SNT113-W459FFC08EF0C4936BEDD5CF1660@phx.gbl>
In-Reply-To: <SNT113-W459FFC08EF0C4936BEDD5CF1660@phx.gbl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009281335.44475.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 28 September 2010 03:47:00 Dale Turner wrote:
> >> kernel: ieee80211 phy9: FW: MAC RESET
> > The device failed to send pending data for more than 150ms(HT40) - 300ms,
> > either because the medium was busy, or the AP failed to response at all
> > mostly because it has crashed first.
> > (check if your AP's TSF is no where near your AP's uptime)
> 
> I don't think there are any nearby networks on my channel.
> I purposely change it from default ( 6 ) to 11 (actually wide 9).
What's wide 9? HT40 with the primary channel on 11 and the extension
on 6?
 
> The access point is a Linksys wrt120n (probably not the best, I know).
Isn't this a 1-stream align-n (AR9285) platform? If so then there is
no advantage of using an AR9170 over the AR9271.

> To be honest, I don't know what a TSF is or how to check it.
The TSF keeps the timers for all STAs in the "network" synchronized.
http://en.wikipedia.org/wiki/Timing_Synchronization_Function_%28TSF%29

It can be easily check by: iw dev wlanX scan

e.g.: (sample output)
BSS 00:02:32:0d:d1:32 (on wlan13)
        TSF: 2669831323 usec (0d, 00:44:29) <-------
        freq: 2437

This will tell you that the "network" has an uptime of
0 days, 0 hours, 44 minutes and 29 seconds.

Regards,
	Chr
