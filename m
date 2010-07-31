Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hyde.gogi.tv ([87.106.167.24]:51184 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab0GaM4s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 08:56:48 -0400
Received: from pippo.localnet (p5B1733E6.dip.t-dialin.net [91.23.51.230])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by hyde.gogi.tv (Postfix) with ESMTPSA id 9524E4800B
	for <linux-wireless@vger.kernel.org>; Sat, 31 Jul 2010 12:48:09 +0000 (UTC)
From: Daniel Haid <d.haid@gogi.tv>
To: linux-wireless@vger.kernel.org
Subject: iw reg set does not work because udev and crda do not respond to boot-time request.
Date: Sat, 31 Jul 2010 14:48:06 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201007311448.06959.d.haid@gogi.tv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

the driver of my wireless card seems to ask for "US"
regulatory data during boot, but since udev is not
running at that point (I think not even the root filesystem
is mounted) crda does not respond.

The effect is that "iw reg set" does not work, because
the kernel seems to be still waiting for the "US"
regulatory data. Running
COUNTRY="US" crda
manually once fixes the problem (until the next reboot).

What is the correct way of solving this? Should udev not
pick up the request later when it is started?
