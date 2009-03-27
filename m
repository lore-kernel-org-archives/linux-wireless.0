Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39048 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205AbZC0P6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 11:58:11 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>
Subject: [RFC] rfkill/rfkill-input userspace API
Date: Fri, 27 Mar 2009 12:58:01 -0300
Message-Id: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br> (sfid-20090327_165815_381528_72AF136C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set is being posted for comments and ideas.

It implements a sysfs API for the rfkill core that allows userspace to
completely implement the operations that rfkill-input is capable of.

I am not too happy about it, I think it looks ugly.  But I had no
better ideas.  Comments and ideas for a better one are welcome.

Note: unless something is done to change the way X.org deals with
input devices, rfkill-input is _useless_ in a large number of setups
as far as input event handling goes, because it will never get any
events after X.org evdev grabs the input device.

This patch set applies on top of the rfkill update patchset I just
posted, which is, in turn, based on current wireless-testing master.

Henrique de Moraes Holschuh (4):
      rfkill: prepare to export global states to userspace
      rfkill: expose global switches through sysfs
      rfkill: expose global state to sysfs
      rfkill: export events for global state changes

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

