Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.ukrpost.ua ([195.5.6.22]:59697 "EHLO relay2.ukrpost.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab1BIOVL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:21:11 -0500
Received: from mail.academy.zt.ua ([82.207.120.245])
	by relay2.ukrpost.ua with esmtp (Exim 4.72)
	(envelope-from <george@znau.edu.ua>)
	id 1PnALx-0007P9-4C
	for linux-wireless@vger.kernel.org; Wed, 09 Feb 2011 15:45:05 +0200
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000019954.msg
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 15:43:22 +0200
Subject: SSB AI support code
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Wed, 09 Feb 2011 15:36:30 +0200
Message-Id: <1297258590.17400.37.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys.

Starting this thread in order to discuss SSB AI support. Recently there
were discussion on this matter but unfortunately missed it therefore
starting new thread.

Recently was playing around making new kernels work on ASUS RT-N16
(bcm4716-based with AI style bus). Started with commits by Bernhard Loos
early 2010, and finally managed to get things work.
Currently with code modified/added mine bcm4716 have working usb
ehci/ohci and ethernet. Well, its pretty much everything the box have,
except wifi - currently i'm half-way done with porting bcm80211 nphy
code changes to b43 (Hopefully recent commits by Rafal Milecki will save
me from porting more, but haven't tried it yet).

All changes made were tested on SB-based hardware (two old bcm5354-based
boxes). Unfortunately have no access to other BCM hw I could test things
on, but I'm pretty much sure old hardware should not be affected by code
changes while newer ones have some chance to get supported.
Changes made are based on ASUS GPL sourcecodes for N16, bcm80211 staging
code and bcm-v4.sipsolutions.net researches.

I will post patches here as soon as get this message back in my emailer
to keep things in single thread.

Please note these changes are how things work for me. It's not commit
request or anything alike. Most of the changes are easy, while some
(well, actually just one - 5th patch with core state/control management
propagation) should be well thought of before applying. Actually things
with 5th patch could be done in completely backwards way - keep existing
TMSLOW/TMSHIGH defines intact with flags in two high bytes and do ">>
16" things in AI code instead of "<< 16" in SB code but again - its just
the way things work for me currently, not the way I could insist or
something on.

This is partial subset of changes to get newer BCM4716s' to work with
linux. If anyone is interested the whole set of patches will be
accessible in few hours via http - just left few things to manage with
them.


