Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34116 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502Ab1INL1P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 07:27:15 -0400
Received: by wwn22 with SMTP id 22so5144031wwn.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 04:27:14 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 14 Sep 2011 06:19:59 -0500
Message-ID: <CAJ8GFOgNRAr7LvnO8f0Y8uvkQdwhz7uUXRQ6BXomjO05RiiYjg@mail.gmail.com> (sfid-20110914_132718_792679_1050373D)
Subject: Latency and connection problems with a carl9170-based AP
From: Harshal Chhaya <harshal@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am working on a TI-OMAP3 + AR9170 based AP. The carl9170 driver is
version 1.9.2 and the firmware is version 1.9.4. The rest of the
system is a couple of months old compat-wireless configuration on a
2.6.37 kernel.

The network is pretty usable when no clients enable WLAN power save.
However, when power save is enabled, I see lots of disconnects and
instability in the system. The clients are using legacy power save
mechanisms (using 'null' packets to indicate going in and coming out
of power save to the AP).

Most of the disconnects seem to be caused by beacons that update the
TIM IE but not the overall length. The result is a corrupted RSN IE
(e.g. the IE length says 20 bytes but the IE is only 19 bytes in size)
which causes the clients to disconnect. This problem lasts for only
one beacon (i.e. the next beacon has the right size) but it is enough
to cause the clients to disconnect. Is there a way to fix this?

Another problem when power save is enabled is the large and
unpredictable latency. I understand how enabling power save can
increase latency but my ping times go from 3-4 ms without power save
to a wide range of 3 ms - 3 s after I enable power save. I am trying
smaller beacon intervals to reduce this latency but even at a beacon
interval of 25ms, I get ping times of up to ~400 ms. How do I reduce
this wide variation in latency.

Thanks for your help.

Regards,
- Harshal
