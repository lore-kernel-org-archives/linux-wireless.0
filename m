Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49390 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964856Ab1GOGNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 02:13:24 -0400
Received: by pzk3 with SMTP id 3so1193743pzk.5
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 23:13:23 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 15 Jul 2011 01:13:23 -0500
Message-ID: <CABRmwPszXW5+7GqzXV2Cpp7FhDE095d8iGiOe1dvhb8pynQZaw@mail.gmail.com> (sfid-20110715_081327_590327_518EE3D8)
Subject: Control beacon transmission
From: Duc Anh Truong Tan <ducanhtt@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm doing a project on power saving for adhoc network, using ATIM
window. However, the transmission of beacons at each beacon interval
makes TSF timers unstable in IBSS environment. Then, our first task is
to stabilize the TSF timer. We do this by letting only the faster
stations compete for transmitting beacon at beacon intervals. At those
intervals, the stations with slower TSF timers need not send beacon.

I would like to ask where in ath9k we could change the code to disable
or enable beacon transmission (i.e., turn on\off beacon transmission)
as wanted? As far as I found from ath9k, ath9k_hw_dissable_interrupts
defined in mac.c stops sending a beacon and ath9k_hw_set_interrupts
restarts transmitting beacon as normal. Is it true in ath9k?

If we cannot change beacon transmission in ath9k, could we stop
hardware's beaconing and use software to describe the desired beacon
transmission mechanism (as our own way) ?
Any comment or suggestion would be appreciated.
Thank you,
Anh
