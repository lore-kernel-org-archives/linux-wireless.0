Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:51887 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbZFAUnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 16:43:09 -0400
Received: by fxm12 with SMTP id 12so6053614fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2009 13:43:10 -0700 (PDT)
Subject: Pending ath5k bugs
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath5k-devel <ath5k-devel@lists.ath5k.org>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 23:43:02 +0300
Message-Id: <1243888982.13273.21.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Just like ath9k thread, here is the list of bugs, I have seen on my
aspire one (with ath5k).

This is an AR2425 device.


#1) - Data transfer often stalls, sometimes for few seconds, sometimes
for much longer periods.

Transfer rate doesn't affect this, nether does network load (happens
much more often when it is high, but also happens, while it is medium to
low).

I observed that, resetting the phy by triggering a scan, sometimes help,
although running the scan inside a 2 second per iteration loop, doesn't
prevent this stall to occur.

Also encryption doesn't play any role in this, I have seen  same
scenario on open network configuration as well.


#2) - Driver sometimes doesn't wake the device up, after resume from
ram/disk. It happens not much often, but when it does, only a power
cycle (reboot or poweroff) helps to recover the device, and nether s2ram
nor s2disk do anything.



#3) Ath5k often panics the kernel when it is in ibss/ap mode. This
reported to be fixed, but I use latest wireless-testing (less that 3 day
old, on average)


#4) Ath5k doesn't send beacons, when hostapd is run for the first time.


#5) Can't send any frames between AP (ath5k) and a client.
But If I create a second monitor iface (in addition to the one hostapd
have created) I do see the frames from client on AP.


I especially hate bug #1, and would be happy to see bug #2 fixed.
I don't use AP mode much yet, but it would be nice if it were in working
state.



Best regards,
	Maxim Levitsky

