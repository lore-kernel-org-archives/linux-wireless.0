Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52536 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649AbYFDDKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 23:10:21 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
Subject: [GIT PATCH] rkfill improvements for -next
Date: Wed,  4 Jun 2008 00:10:05 -0300
Message-Id: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br> (sfid-20080604_051029_761719_9AA9A561)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello John,

This patch series contains what is ready so far of my rfkill rework
effort, all of them fully ack'ed by Ivo.

It enhances rfkill to the point that it is actually completely useable
by platform drivers such as thinkpad-acpi, and it also fixes some issues
that plague the way some drivers like b43 use rfkill.

Note that some of these patches are preparatory work.  No drivers are
broken by it, but currently broken drivers are not fixed either (drivers
like b43 need to be reworked to take advantage of the now proper
read-write rfkill device support, and notifier chain support).

These patches went through a lot of discursion already, available at
http://thread.gmane.org/gmane.linux.kernel/664500 and a more recent
thread at http://thread.gmane.org/gmane.linux.kernel/682233.

This series is available as a git branch at:
git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git rfkill

It is based on top of Linus mainline.  It requires commit
5adad0133907790c50283bf03271d920d6897043, which was recently merged.

Here's the shortlog:

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

I'd very much like to see this merged in the -next tree, so that it can
make it to mainline for 2.6.27 when the merge window opens again.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
