Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:34112 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578AbZBWWoL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 17:44:11 -0500
Received: by bwz5 with SMTP id 5so5287287bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2009 14:44:07 -0800 (PST)
Subject: [BUG] [REGRESSION] Hardware scanning broken in latest git
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain
Date: Tue, 24 Feb 2009 00:44:03 +0200
Message-Id: <1235429043.12816.14.camel@maxim-laptop> (sfid-20090223_234422_321223_E9D8BC07)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have just rebuilt a kernel (same kernel, but
I needed few drivers), and using this chance pulled latest
wireless-testing.

result - wifi doesn't work unless I use disable_hw_scan - my wifi
is iwl3945.

Trying to do 'sudo iwlist scan' tells that device is busy.
it seems that at first nm connects, as it receives first scan results.
but then it can't scan again - probably something in scanning code is
broken so it never finishes a scan.

My AP is WPA-2 protected.

Also I noticed long ago that wpa_suppicant doesn't connect to the
network at first try since ts wpa handshake fail. This is probably
its bug, but just for reference - this is very annoying.

(I use latest nm and wpa_supplicant from -git - but this problem have
always existed).


And of course I noticed another very strange bug with iwlwifi.
At my university often I can't connect to the wifi - usually because of
the week signal - but at some rooms I noticed that if I somehow manage
to connect (get dhcp address that is) - connection is very fast and
stable. 

In other words association usually works (forgot to say that they use
open network - duh ), then DHCP stalls - but if it succeeds and I move
to different part of the class - even where I never had any reception -
it continues to work well.
(It could be that transmission speed is lowered - but I tried to set low
speed - and never got any better results)


Thats all for bugs I have on my intel wireless - keep up the good work -
recently iwlwifi drivers improved a lot.
(even the led blinks correctly now in monitor mode)



Best regards,
	Maxim Levitsky



