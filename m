Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60737 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390AbYGWBEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 21:04:15 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>
Subject: [GIT PATCH] RFC: next batch of rfkill changes
Date: Tue, 22 Jul 2008 22:04:00 -0300
Message-Id: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br> (sfid-20080723_030419_906860_3A021648)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This is my next batch of rfkill changes.  They add features and address
some shortcomings of rfkill-input, mostly.

Please comment.  One thing that is bothering me in the last patch is
what happens during suspend/resume to pending delayed rfkill state
changes.  Are pending scheduled jobs executed, cancelled, or frozen to
fire up when the system resumes itself?

Henrique de Moraes Holschuh (6):
      rfkill: detect bogus double-registering
      rfkill: add default global states
      rfkill: add master_switch_mode functionality
      rfkill: add EPO lock to rfkill-input
      rfkill: rename rfkill_mutex to rfkill_global_mutex
      rfkill: rate-limit rfkill-input workqueue usage

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
