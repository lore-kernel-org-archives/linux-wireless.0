Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:52118 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbXLJKjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 05:39:20 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: b43 regression
Date: Mon, 10 Dec 2007 11:36:48 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200712101136.48669.mb@bu3sch.de> (sfid-20071210_103956_787497_4E9B6807)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have identified another regression introduced by
commit f04b3787bbce4567e28069a9ec97dcd804626ac7.

On my device it shows up as broken transmission after
a suspend/resume cycle. The workaround for it is to boot
a known good driver (in my case the vendor driver in OSX)
and then reboot (without turning the machine off) into the
broken driver.

It seems like we unintentionally removed some significant
initialization step in that patch. I could not identify it, yet.
The patch I sent yesterday did fix two other bugs, but not this one.

I am trying to find the reason for this.
If someone wants to help searching, the best way would be to look
at that patch I mentioned above and compare the stuff that it
removes to the stuff that it adds. There must be some tiny line
that it removes but does not re-add it at another place.
Four eyes see more than two.

I have no idea how this bug could be related to the few bugreports
in the redhat bugzilla. Though, one could test that by trying a
kernel that does not include the patch.

Sorry for the inconvenience.

-- 
Greetings Michael.
