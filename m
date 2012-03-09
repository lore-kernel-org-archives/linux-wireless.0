Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.emlix.com ([193.175.82.238]:58603 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758599Ab2CISdD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 13:33:03 -0500
Message-ID: <4F5A4261.2090207@emlix.com> (sfid-20120309_193307_551166_AA6894B5)
Date: Fri, 09 Mar 2012 18:48:17 +0100
From: =?ISO-8859-15?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Problems with ath9k_htc / AR9271
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
we are currently evaluating Netgear WNA1100 USB sticks for use in
conjunction with an ARM based embedded device. For our tests we used
the ath9k_htc driver from compat-wireless 3.2.5-1. The sticks are
connected to a USB 1.1 OHCI controller.

Our tests consist of an endless loop of ping, iperf and wget to a
PC connected to the AP (AVM FRITZ!Box 7270 v3, 6m away) via ethernet.
The WPA2 connection uses TKIP for the group cipher and CCMP for the
pairwise cipher.

While the connections are stable over weeks when there is just one
device, the sticks tend to lock up after about 1-2 days when two
devices are competing for airtime. There are a handfull of networks
around, but there is little traffic besides our tests.

I have seen two different lock ups:
1. - USB analyzer shows all packets being NAK'ed by the stick
   - OHCI controller endlessly repeats the same packet
   - Driver queues more and more URBs
   - Kernel runs out of memory, OOM killer goes on a rampage
   - System sometimes recovers a few minutes after removing the stick

2. - Connection apparently dropped due to timeout
   - TCP connects fail with "no route to host"
   - scanning for networks yields no results
   - USB analyzer shows requests still being answered.
   - tcpdump/airodump-ng show not a single packet being received
   - reloading ath9k_htc.ko does not help

Are these known problems and can I do anything to help analyze and fix
them? Shall I create logs with a specific debugging mask?

The goal is to allow the end user to not have to touch the device for
years, so a lock up every two days is a no-go.

Is the AR9271 a good choice for stable connections?
Do you know of other current chipsets with better stability?

Best regards,

  Daniel


-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax +49 551 30664-11,
Bertha-von-Suttner-Straße 9, 37085 Göttingen, Germany
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160
Geschäftsführer: Dr. Uwe Kracke, Ust-IdNr.: DE 205 198 055

emlix - your embedded linux partner
