Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:48128 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab2CNLzh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 07:55:37 -0400
Received: from postman.hrz.tu-chemnitz.de ([134.109.133.5] helo=mailbox.hrz.tu-chemnitz.de)
	by nick.hrz.tu-chemnitz.de with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <marco.porsch@etit.tu-chemnitz.de>)
	id 1S7mPW-0006pw-87
	for linux-wireless@vger.kernel.org; Wed, 14 Mar 2012 12:30:30 +0100
Received: from perseus.infotech.tu-chemnitz.de ([134.109.4.8] helo=X220marco)
	by mailbox.hrz.tu-chemnitz.de with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.76)
	(envelope-from <porma@mailbox.hrz.tu-chemnitz.de>)
	id 1S7mPW-0000hN-1Q
	for linux-wireless@vger.kernel.org; Wed, 14 Mar 2012 12:30:30 +0100
From: "Marco Porsch" <marco.porsch@etit.tu-chemnitz.de>
To: <linux-wireless@vger.kernel.org>
Subject: mesh powersave hardware sleep + wakeup
Date: Wed, 14 Mar 2012 12:30:30 +0100
Message-ID: <001801cd01d5$dc81fa60$9585ef20$@etit.tu-chemnitz.de> (sfid-20120314_125542_138342_E2602E6E)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

the  OSLL guys and me had started implementing the IEEE 802.11s powersave schemes in mac80211. We currently have power mode indication and state tracking and are working on powersave frame buffering and mesh synchronization.

A next topic will be to put the hardware to sleep to actually save energy.
Until now we only implemented in mac82011. I looked through mac80211 and ath9k and am unsure, how to actually manage sleep and wakeup in the mesh context. 

Maybe I should give a brief introduction to IEEE 802.11s powersave here:
- Each node has to send its own beacon
- Power mode is not global, but link-specific
- 3 power modes: active, light sleep, deep sleep
  - active = always on
  - light sleep = wake up for the neighbors beacon
  - deep sleep = only wake up for sending own beacon

So the critical point here is, that we need to put the hardware to sleep but wake up for: 
- sending own beacon
- TBTT of all neighbors towards we are in light sleep (or maybe all neighbors as proof-of-concept)
so it is a mixture of ad-hoc , station code and completely new stuff.

So, driver developers (I am especially looking at the ath9k guys), is it actually possible to send beacons, to have powersave in between and to wake up for scheduled events?

Regards
Marco Porsch


PS: 
A better explanation and a nice example of IEEE 802.11s powersave is given here:
http://dl.dropbox.com/u/31741282/11s_powersave.pdf

