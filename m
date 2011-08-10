Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cosmos.phy.tufts.edu ([130.64.83.16]:44107 "EHLO
	cosmos.phy.tufts.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1HJAsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 20:48:08 -0400
Date: Tue, 09 Aug 2011 20:29:18 -0400
Message-Id: <E1Qqwfe-0003TG-KL@cosmos.phy.tufts.edu> (sfid-20110810_024812_287408_201E3589)
From: Ken Olum <kdo@cosmos.phy.tufts.edu>
To: linux-wireless@vger.kernel.org
cc: kdo@cosmos.phy.tufts.edu
Subject: depmod doesn't prefer uncompressed file and updates directory
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First, thanks for all your work in making these drivers available.
Indeed, downloading a new atl1c driver solved a problem where my
Attansic 2062 would quit working when I tried to send a bunch of data.

I encountered a problem which is doubtless not your fault, but still
you could perhaps help out future users by warning of it in your
installation instructions.  I'm using Mandriva 2010.2.  When I said
"make install", my atl1c driver was installed in 
/lib/modules/.../updates/drivers/net/atl1c/atl1c.ko, just as you said
it would be.  But when I said depmod and modprobe, modprobe loaded my
old version from /lib/modules/.../kernel/drivers/net/atl1c/atl1c.ko.gz .
Apparently confusion resulted from the fact that the filenames were
different because one was compressed and the other wasn't.  When I
compressed the new driver, the problem was fixed.

                                        Ken Olum
