Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:60545 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760640Ab2CPJmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 05:42:07 -0400
Message-ID: <4F630AEA.10703@etit.tu-chemnitz.de> (sfid-20120316_104211_952642_0478FF4A)
Date: Fri, 16 Mar 2012 10:42:02 +0100
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
MIME-Version: 1.0
To: mcgrof@qca.qualcomm.com
CC: linux-wireless@vger.kernel.org
Subject: [ath9k] mesh powersave hardware sleep + wakeup
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to implement the IEEE 802.11s power save schemes in mac80211.
In 11s it is defined that power save STA doze AND send beacons AND wake 
up periodically for multiple neighbors beacons.

Is this actually possible with current hardware/drivers (especially ath9k)?

Regards
Marco Porsch



PS: More details:

We currently have power mode indication and state
tracking and are working on powersave frame buffering and mesh
synchronization.

A next topic will be to put the hardware to sleep to actually save energy.
Until now we only implemented in mac82011. I looked through mac80211 and
ath9k and am unsure, how to actually manage sleep and wakeup in the mesh
context.
Maybe I should give a brief introduction to IEEE 802.11s powersave here:
- Each node has to send its own beacon
- Power mode is not global, but link-specific
- 3 power modes: active, light sleep, deep sleep
   - active = always on
   - light sleep = wake up for the neighbors beacon
   - deep sleep = only wake up for sending own beacon

So the critical point here is, that we need to put the hardware to sleep 
but wake up for:
- sending own beacon
- TBTT of all neighbors towards we are in light sleep (or maybe all 
neighbors as proof-of-concept)
so it is a mixture of ad-hoc , station code and completely new stuff.

A better explanation and a nice example of IEEE 802.11s powersave is 
given here:
http://dl.dropbox.com/u/31741282/11s_powersave.pdf
