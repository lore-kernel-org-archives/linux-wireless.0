Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56045 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755497AbYGOTcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 15:32:13 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: [GIT PATCH] rfkill fixes, set 2
Date: Tue, 15 Jul 2008 16:32:03 -0300
Message-Id: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br> (sfid-20080715_213217_834300_3B08C8FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Here is a small set of fixes for rfkill, mostly stuff I noticed while I
was working on other patches that I will send in for RFC and testing,
later.

It does include the documentation change requested by Ivo that makes
rfkill_force_state non-optional where applicable (devices that get
external state changes).

Shortlog:

Henrique de Moraes Holschuh (4):
      rfkill: document rfkill_force_state as required
      rfkill: fix led-trigger unregister order in error unwind
      rfkill: document the rfkill struct locking
      rfkill: mutex fixes

Please consider for merging for 2.6.26, as they are fixes and not
enhancements.  Ivo, please be specially hard on the last patch, I did
test it here, but locking is always tricky...

Patches based on wireless-testing master.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
