Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:45127 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab3EaJbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 May 2013 05:31:11 -0400
Date: Fri, 31 May 2013 11:31:05 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Solomon Peachy <pizza@shaftnet.org>
cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: cw1200 "sbus" conflicts with SPARC "sbus"
Message-ID: <alpine.DEB.2.00.1305311127200.4645@ayla.of.borg> (sfid-20130531_113126_634375_6FB765CE)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


sparc64/allmodconfig:

drivers/net/wireless/cw1200/hwio.c:51:21: error: macro "sbus_memcpy_fromio" passed 4 arguments, but takes just 3
drivers/net/wireless/cw1200/hwio.c:66:19: error: macro "sbus_memcpy_toio" passed 4 arguments, but takes just 3

http://kisskb.ellerman.id.au/kisskb/buildresult/8846508/

At first I thought it was a bad/old implementation of a real SPARC sbus
driver.  but it seems the two sbusses are completely unrelated.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
