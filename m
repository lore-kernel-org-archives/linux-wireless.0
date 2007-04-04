Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60715
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766922AbXDDULt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2007 16:11:49 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Marcus Glocker <mglocker@openbsd.org>,
	Jon Simola <jsimola@gmail.com>,
	Theo de Raadt <deraadt@theos.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Martin Langer <martin-langer@gmx.de>,
	Danny van Dyk <kugelfang@gentoo.org>,
	Andreas Jaggi <andreas.jaggi@waterwave.ch>,
	Larry Finger <larry.finger@lwfinger.net>, Quaker.Fang@sun.com
Subject: OpenBSD bcw: Possible GPL license violation issues
Date: Wed, 4 Apr 2007 22:08:13 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Joseph Jezak <josejx@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	Greg kh <greg@kroah.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	license-violation@gpl-violations.org
MIME-Version: 1.0
Message-Id: <200704041945.21447.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I, Michael Buesch, am one of the maintainers of the GPL'd Linux
wireless LAN driver for the Broadcom chip (bcm43xx).
The Copyright holders of bcm43xx (which includes me) want to talk
to you, OpenBSD bcw developers, about possible GPL license and therefore
Copyright violations in your bcw driver.

We believe that you might have directly copied code
out of bcm43xx (licensed under GPL v2), without our explicit permission,
into bcw (licensed under BSD license).
There are implementation details in bcm43xx that appear exactly
the same in bcw. These implementation details clearly don't come
from the open specifications at bcm-specs.sipsolutions.net
or bcm-v4.sipsolutions.net.

We have always made and still make a great effort to keep our code clean
of any Copyright issues (cleanroom design). Please make sure you also do.

A few examples follow of what we think might be GPL violations.
This list is far from being complete.

BCW_PHY_STACKSAVE()
BCW_ILT_STACKSAVE()
bcw_stack_save()
bcw_stack_restore()
These functions are a possible implementation of the specs when
they say "backup/restore a value".
Yet, it looks like you had exactly the same idea implementing this
generic description that I had.

bcw_set_opmode()
This function does not appear in the specifications.
I think Jiri Benc wrote it initially (and gave it its name) and
I extended it.

bcw_leds_switch_all()
is not in the specs, but a pure implementation detail of bcm43xx.

bcw_sprom_read()
This is obviously copied. Even the error message string is similiar.

bcw_phy_calc_loopback_gain()
I think it's no coincidence that you also decided to name the backup
variables like
	uint16_t backup_phy[15];
	uint16_t backup_radio[3];
	uint16_t backup_bband;

bcw_phy_init_pctl()
	uint16_t saved_batt = 0, saved_ratt = 0, saved_txctl1 = 0;
	int must_reset_txpower = 0;

bcw_phy_xmitpower()
Attenuation adjustment algorithms (while loops).

bcw_phy_lo_g_state()
This exactly matches bcm43xx, although the specs only have an abstract
description and diagram of the state machine.

bcw_phy_lo_g_deviation_subval()
/* XXX bcm43xx_voluntary_preempt() ? */
Nice comment there.
You might want to grep bcw for the string "bcm43xx"
and you will find more of them.


... and all the rest.


We'd like to have this issue resolved.
In general we are not against having a free (and BSD licensed) driver
in the BSD operating system. But you _have_ to cooperate with us if you'd
like to take our code and relicense it under BSD license. We intentionally
put the code under GPL license. We did _not_ do this, because "everybody
does this". We did this, among other reasons, because we
[citing Michael, Mon, 26 Dec 2005 13:03:44 +0100]
"don't think we should allow proprietary vendors to take our code
and close it again."

[citing Michael, Date unknown]
"What if Broadcom decides to take our LO measure state machine and
put it into the original driver? (The Rev Engineers told me they have
a very different weird solution for this in their code).
I really don't want to see this happen."

We'd like to offer you to start cooperating with us.
We respect you and your Copyright. You should also do so on our work.

We would not be opposed to relicensing parts of our code under the BSD
license on an explicit case-by-case base.
So if you ask "May I use this and that function" and if I own the
Copyright on that particular function, I will approve or deny your request.
Other Copyright holders of the bcm43xx code might act the same way.

We're not out for blood, just for a fair resolution.
We'd like you to start contacting us to resolve the issue now.

Have a nice day.

-- 
Greetings Michael.
