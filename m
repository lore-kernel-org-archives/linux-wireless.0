Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44216 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab0KQFdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 00:33:17 -0500
Received: by wwa36 with SMTP id 36so1628283wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 21:33:16 -0800 (PST)
MIME-Version: 1.0
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 17 Nov 2010 15:32:53 +1000
Message-ID: <AANLkTik_4HRwUUYnFLR6BwevQi6W+FK2rNN7Kph+dAWk@mail.gmail.com>
Subject: Unloading ath5k fails
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm not sure if this is a problem with ath5k, or with wireless-testing
in general. We have a fresh build of today's git pull. When trying to
unload ath5k with the interface still up, the rmmod command fails and
goes into a 'zombie' state with the following error coming up every 5s
or so:
unregister_netdevice: waiting for wlan0 to become free. Usage count = 1

Unfortunately, the interfaces and phys disappear and cannot be
unloaded and the only resolution to this is to ssh in with another
terminal and reboot the machine (as the terminal issuing the rmmod
command becomes unresponsive).

If the interface is not brought up, ath5k can be unloaded (and
reloaded) successfully.

Thanks,

--
Jonathan Guerin
