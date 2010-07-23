Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:60846 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab0GWTbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 15:31:16 -0400
Received: by pxi14 with SMTP id 14so3768998pxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jul 2010 12:31:16 -0700 (PDT)
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 23 Jul 2010 15:30:56 -0400
Message-ID: <AANLkTimdDhHudW6_7Hwcf6UCumY_EgqGd7CLtmSgOzEz@mail.gmail.com>
Subject: regulatory hiccup
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is 2.6.35-rc4, but this bug (?) might exist in other versions ,too.

Early in boot, all was well:

[ 5524.214376] cfg80211: Calling CRDA to update world regulatory domain
[ 5524.219025] cfg80211: Calling CRDA for country: US
[ 5524.238440] cfg80211: Regulatory domain changed to country: US
[ 5524.238443]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 5524.238446]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[ 5524.238448]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[ 5524.238451]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 5524.238454]     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 5524.238456]     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 5524.238459]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)

Then, after fiddling with an AP for a bit, I got:

[11747.264221] cfg80211: Calling CRDA for country: US
[11747.282664] cfg80211: Current regulatory domain updated by AP to: US
[11747.282672]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[11747.282680]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1600 mBm)
[11747.282688]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 1600 mBm)

(Note lots of missing channels after that.)  iw phy phy0 info showed
all the channels above 5.33GHz disabled.  I didn't see some other APs
that were there.

Later on I disconnected, CRDA got called again, and all was well.

The AP that I had just connected to when everything broke was an
EnGenuis ESR7750 (brand new), and maybe it sent something wrong, but
surely if it says US it shouldn't disable other APs on US bands that
CRDA says is OK.
