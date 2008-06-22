Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:42828 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710AbYFVPi5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 11:38:57 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>,
	Thomas Renninger <trenn@suse.de>
Subject: [GIT PATCH] rfkill rework for 2.6.27 (v2)
Date: Sun, 22 Jun 2008 12:38:36 -0300
Message-Id: <1214149128-5913-1-git-send-email-hmh@hmh.eng.br> (sfid-20080622_173904_587907_708CA413)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello John,

Here is the revised patchset to bring rfkill up to shape enough that it
becomes useable for platform drivers like thinkpad-acpi.

There are some very minor changes:
 * Added a check for illegal states on rfkill_force_state() since
   it is an exported function and someone might call it with wrong
   parameters;
 * Fix use of %u instead of %d on uevent generation for RFKILL_STATE
   to match the type for enum rfkill_state;
 * Minor documentation wording changes;

All the patches in this patchset have been ACKed by Ivo, the rfkill
maintainer.  They're based on wireless-testing master branch, but they
apply cleanly on top of 2.6.26-rc7 as well.

No real problem was found on any of the patches in the thread they
generated last time I posted, AFAIK all doubts regarding these patches
have been explained to the satisfaction of everyone involved, and they
dealt far more with the rfkill subsystem itself than with anything any
of the patches was doing.

True, there are still shortcomings in the rfkill subsystem even after
this patchset, but that's not a problem with the patches but rather
missing features and changes that should be done on further patches.
Some of these patches are ready (e.g. extra documentation) and others (a
new hardlocked rfkill state for rfkill-state) are being tested, and will
be send to linux-wireless soon.

Please merge this patchset on wireless-testing to get it on its way to
linux-next, so that it can go to 2.6.27 when the merge window opens.
This patchset is extremely important for my thinkpad-acpi work, and for
other drivers like hp-wmi.

Note that these patches are backwards-compatible in API and ABI.  No
in-tree drivers are broken by it, but it doesn't magically fixes their
rfkill support either.  It just makes it possible to write drivers using
rfkill that actually work properly.

These patches went through a lot of discursion already, available at
http://thread.gmane.org/gmane.linux.kernel/664500 and a more recent
thread at http://thread.gmane.org/gmane.linux.kernel/682233 and
http://thread.gmane.org/gmane.linux.kernel.wireless.general/15677.


This series is available as a git branch at:
git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git for-upstream/rfkill

Shortlog:

Henrique de Moraes Holschuh (12):
      rfkill: clarify meaning of rfkill states
      rfkill: fix minor typo in kernel doc
      rfkill: handle SW_RFKILL_ALL events
      rfkill: add parameter to disable radios by default
      rfkill: add read-write rfkill switch support
      rfkill: add the WWAN radio type
      rfkill: rework suspend and resume handlers
      rfkill: add notifier chains support
      rfkill: add type string helper
      rfkill: add uevent notifications
      rfkill: do not allow userspace to override ALL RADIOS OFF
      rfkill: document rw rfkill switches and clarify input subsystem interactions

Thank you.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
