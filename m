Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35700 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbcAGQTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 11:19:46 -0500
Received: by mail-io0-f174.google.com with SMTP id 77so226201236ioc.2
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2016 08:19:46 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 7 Jan 2016 09:19:45 -0700
Message-ID: <CALnQHM3C=DVaTf58XDyh+rttVs-FSpc4ghozg9HJktEonq7w-g@mail.gmail.com> (sfid-20160107_172017_138652_5BA0D2A3)
Subject: lost connectivity until "wpa_cli reassociate" is issued
From: David Mosberger <davidm@egauge.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are seeing a curious issue where WLAN connectivity sometimes
gets stuck until a "wpa_cli reassociate" command is issued.

At the WPA level, everything appears to be working fine)
(see thread starting at
http://lists.infradead.org/pipermail/hostap/2016-January/034454.html).

What's truly odd is when connectivity is stuck, you can often "ping" the
network's gateway exactly once and then you either get no response anymore
or, after a long time (like 40-60 seconds), the floodgate opens and
(almost) all previously sent ping responses arrive all at the same time
(in the latter case, connectivity is fine afterwards again).

This makes me wonder if there may be a packet queue that somehow gets
stuck.

I have turned on mac80211 debugging but have not found anything
that seems to correlate with the loss of connectivity.  All I know is that
wpa_cli reassociate so far is the least intrusive workaround that seems
to reliably bring back connectivity.

We are based on kernel 3.7.0 but have back-ported the mac80211 fixes
from the linux-3.7.y stable branch.

I'm not very familiar with the wireless stack, so any tips or hints on how to
further debug this would be greatly appreciated.

Thanks and best regards,

  --david
-- 
eGauge Systems LLC, http://egauge.net/, 1.877-EGAUGE1, fax 720.545.9768
