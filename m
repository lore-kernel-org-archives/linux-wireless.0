Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52457 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753499AbYHBSLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 14:11:10 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>
Subject: [GIT PATCH] rfkill changes for 2.6.28, set 1
Date: Sat,  2 Aug 2008 15:10:56 -0300
Message-Id: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> (sfid-20080802_201114_671704_34CE8F1D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patchset contains rfkill changes that have a chance of being good
enough to be considered for inclusion in wireless-testing.  Their target
is the next merge window (2.6.28).

Please comment/ask for changes, or ACK as appropriate.

Henrique de Moraes Holschuh (8):
      rfkill: detect bogus double-registering (v2)
      rfkill: add default global states (v2)
      rfkill: add __must_check annotations
      rfkill: introduce RFKILL_STATE_MAX
      rfkill: add WARN_ON and BUG_ON paranoia
      rfkill: use the new WARN()
      rfkill: rename rfkill_mutex to rfkill_global_mutex
      rfkill: add support for wake-on-wireless-packet

I have removed from the stack the changes dealing with rfkill-input
global operations and "master_switch_mode" for refactoring.  They will
be back at a later patchset.

For some reason, I got this idea that the new Intel iwl5k cards are
capable of WoWL.  The last patch (rfkill: add support for
wake-on-wireless-packet) was added because of that (possibly incorrect)
idea.  Should we keep it, or just drop it?  Is it of any use or just
some useless rfkill feature nobody will need?

Thanks.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
