Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35643 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751Ab1JZMfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 08:35:07 -0400
Received: by pzk36 with SMTP id 36so4303365pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2011 05:35:06 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 26 Oct 2011 14:35:06 +0200
Message-ID: <CAMG6FYh6dPVQuvoTQsOAqbe_WrMMj7qji8T45DWmdrk-RNb-Bw@mail.gmail.com> (sfid-20111026_143512_029933_B08076E9)
Subject: How to enable clock/power from a wlan device driver
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear community,

Could you please give me an advise how to implement properly (in terms
of architecture design)
enabling / disabling of external functional clock and power of a WLAN
device from a (mac80211-based)
device driver?

We have a device on a board which needs to be powered on and clocked
before driver can use it.
There are several options:
1. Driver can call clk_get()/clk_enable() itself using name of the clock.
2. Driver can get struct clk* from platform data and call clk_enable()
3. Driver can call platform callback and request platform code to
enable the clock.

What is preferable way of doing it? I see there is no
clk_get()/regulator_get() calls from the
drivers/net/wireless/ code, nor *_enable(). For my understanding
clocks and power are platform-specific.
Other boards/platform using the same chip can require other clocks or
not require them at all in case
of self-clocked design. Same with power.

Thank you and with best regards,
Dmitry Tarnyagin
