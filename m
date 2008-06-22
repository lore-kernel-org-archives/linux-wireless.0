Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58894 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755395AbYFVPvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 11:51:44 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>,
	Thomas Renninger <trenn@suse.de>
Subject: [RFC] rfkill rfkill_state enhancements and new docs
Date: Sun, 22 Jun 2008 12:51:37 -0300
Message-Id: <1214149899-8323-1-git-send-email-hmh@hmh.eng.br> (sfid-20080622_175208_509004_B7DC3168)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


These two patches apply on top of the new patchset I just sent to
linux-wireless.

They are NOT finished yet.  In particular, patch 1 was just
compile-tested so far, but I thought I should get early comments on it
to get it ready ASAP.

Patch 2 *really* improves the documentation of rfkill, please look at it
and tell me if it answered any lingering doubts about what rfkill can do
and how to use it.

So, please send me your comments about them.  I want to get them ready,
improved and tested to the point of sending a request for merge during
this week, so that they could conceivably also make it for 2.6.27.

Note: I have checked, and there is nothing technical that precludes a
wireless driver like ipw2200 to register many rfkill classes, one per
rfkill input line.  However, doing so is bad from an usability PoV, so
it is forbidden by "policy" (i.e. the docs tell you not to).  Platform
drivers, that often deal with various rfkill controllers, ARE expected
to register many rfkill classes.

I am still updating thinkpad-acpi to use the new functionality on these
two patches, but I think I have converted its bluetooth switch already
to the new functionality (warning: untested).  If you want to look at
the new code, it is at:
git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git devel

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
