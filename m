Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stator.leun.net ([85.214.203.199]:35486 "EHLO stator.leun.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854AbaDVRBJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 13:01:09 -0400
Date: Tue, 22 Apr 2014 18:48:24 +0200
From: Michael Leun <lkml20140418@newton.leun.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arik@wizery.com>,
	Sander Eikelenboom <linux@eikelenboom.it>
Subject: Re: [PATCH 0/2] cfg80211: two reg fixes
Message-ID: <20140422184824.74973bb3@xenia.leun.net> (sfid-20140422_190249_150445_CBE9483F)
In-Reply-To: <CAB=NE6URp2S9rhVr2cqT+4VOj50m+q0o1rVRehCZvcUtNwTVVw@mail.gmail.com>
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com>
	<20140422180003.6438dbb7@xenia.leun.net>
	<CAB=NE6URp2S9rhVr2cqT+4VOj50m+q0o1rVRehCZvcUtNwTVVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 22 Apr 2014 09:32:03 -0700
"Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:

> On Tue, Apr 22, 2014 at 9:00 AM, Michael Leun
> <lkml20140418@newton.leun.net> wrote:
> > Did I get this correct, test-ariks-patch-for-314.patch is the same
> > thing as the two patches you posted and that got applied? If so,
> > that does not help for 3.14, I fear. I might try them on an current
> > 3.15-rc.
> 
> No its just one patch, the first one. I'll have another look at this,
> do you happen to have gdb? Can you do:
> 
> gdb net/wireless/cfg80211.ko
> l *reg_todo+0xc1

Do you prefer with or without test-ariks-patch-for-314.patch? This is
with, if you need anything else please let me know.

Note: I already had reversed the patch, I've put it back in and
recompiled - if that changes anything when correlating this with the
oops I posted...


ml@jill:/usr/src/kernel/linux1> gdb net/wireless/cfg80211.ko
GNU gdb (GDB; openSUSE 13.1) 7.6.50.20130731-cvs
Copyright (C) 2013 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-suse-linux".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://bugs.opensuse.org/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word".
..
Reading symbols from /usr/src/kernel/linux1/net/wireless/cfg80211.ko...done.
(gdb) l *reg_todo+0xc1
0x61f1 is in reg_todo (net/wireless/reg.c:1611).
1606                    /* Trust a Cell base station over the AP's country IE */
1607                    if (regdom_changes(country_ie_request->alpha2))
1608                            return REG_REQ_IGNORE;
1609                    return REG_REQ_ALREADY_SET;
1610            } else {
1611                    if (wiphy->regulatory_flags & REGULATORY_COUNTRY_IE_IGNORE)
1612                            return REG_REQ_IGNORE;
1613            }
1614
1615            if (unlikely(!is_an_alpha2(country_ie_request->alpha2)))
(gdb) quit
ml@jill:/usr/src/kernel/linux1>


-- 
MfG,

Michael Leun

