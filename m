Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45742 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754497AbZEUDEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 23:04:33 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: rfkill v9: fixes and thinkpad-acpi conversion
Date: Thu, 21 May 2009 00:04:16 -0300
Message-Id: <1242875059-9627-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Here are two patches for the rfkill core rewrite, plus the thinkpad-acpi
conversion.

Just fold them into your latest rfkill rewrite patch.

HOWEVER, the thing doesn't work right.  Now, I am pretty sure I might have
done something wrong somewhere in the thinkpad-acpi conversion (for
example: the UWB switch never registers with its hw-block state right, but
all others do), and I would appreciate if you could look it over and tell
me what I am doing that upsets the core.

The core might have some bugs left, too.  It seems to ignore set_sw_state
changes, I can't see it reflected on rfkill/state, and it is _not_ because
it is trying to set it back to whatever it wanted properly (or I'd get
calls to the set_block hook).  Maybe it is something in my thinkpad-acpi
conversion, though.

Anyway, the core needs proper coverage testing of its full functionality
before it can be merged in mainline.  Just like you found that the old core
never worked right for LEDs, the new rewrite was not processing any KEY_*
input events, which is a quite important functionality...

Regardless of that, the rewrite is likely good enough for wireless-testing,
now.  At least it will compile cleanly now that thinkpad-acpi is converted.
But PLEASE don't let it go to mainline before:

1. It is gets good coverage testing, and

2. Write support to let userspace change the switch status is implemented.
It is a show-stopper for platform drivers.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
