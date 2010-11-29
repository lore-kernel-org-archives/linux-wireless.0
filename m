Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50273 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab0K2Guj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 01:50:39 -0500
Received: by gyb11 with SMTP id 11so1829907gyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Nov 2010 22:50:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290759315.15341.2.camel@chilepepper>
References: <1290079951-16793-1-git-send-email-arik@wizery.com> <1290759315.15341.2.camel@chilepepper>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 29 Nov 2010 08:50:23 +0200
Message-ID: <AANLkTinD06Py==U5V2Lx2x1M_EZ0Lr1M_RuQ1hKRLrRR@mail.gmail.com>
Subject: Re: [PATCH 00/18] AP mode support for wl12xx
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Luca,

>
> Unfortunately I didn't have much time to look into your AP patches yet.
> We need to review this very carefully.  It touches so many parts of the
> code that I'm a bit worried that this would break normal STA
> functionality.

Most of the patches add AP related functionality without touching the
flow in STA mode.
In fact the only patch that touches STA is "[PATCH 06/18] wl1271: AP
mode - init sequence". The init sequence has been modified to unify
the STA and AP common parts and separate the different parts into
different functions.
For STA mode this means a slight change in the order of initialization.

Other changes are basically:
1. STA function renames
2. removing STA functionality when operating in AP mode by protecting
code segments with "if (!is_ap)"
3. adding AP mode only functionality. This includes code segments with
"if (is_ap)" in common STA/AP code.

>
> How well have you tested these patches in STA mode? Do you think there
> would be any possibility of making this Kconfigurable so that there
> would be no (or very little) binary difference in the code if AP is not
> enabled?

We have performed extensive stress tests on the init sequence part
(constant on/off for several days). Basic throughput and stress tests
were performed for STA mode operation (as well as AP mode operation).
A third kind of test was a stress test of the switch between STA and AP modes.

We feel making the AP mode Kconfigurable will make the code uglier and
hurt maintainability. We were hoping we could avoid it by structuring
the code as it is.

Regards,
Arik
