Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:40115 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917Ab0CVTkM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 15:40:12 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1NtnTp-0000GY-EF
	for linux-wireless@vger.kernel.org; Mon, 22 Mar 2010 20:40:05 +0100
Received: from p54A74390.dip.t-dialin.net ([84.167.67.144])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 22 Mar 2010 20:40:05 +0100
Received: from m1kes by p54A74390.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 22 Mar 2010 20:40:05 +0100
To: linux-wireless@vger.kernel.org
From: Michael Stahn <m1kes@web.de>
Subject: Re: [Proposal]TX flags
Date: Mon, 22 Mar 2010 19:32:21 +0000 (UTC)
Message-ID: <loom.20100322T194108-874@post.gmane.org>
References: <69e28c910904141733m72ce521ap8f1865bec991fff7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Regarding to this proposal I suggest this additional Radiotap feature
to be standardised:

- Duration field shall not be recalculated ("No-Dur").

The approbiate mask for the Radiotap-Header would be 0x0020.
The No-Dur flag is used when sending frames from the userspace
to indicate that the frame already has its duration time
preconfigured and should not be recalculated by low-level.
This is useful for testing porpuses or tools like
aireplay which trust on the "send out what you put in"-behaviour,
especialliy on RTS-Frames, where duration-fields are reset to 0.
If fragmentation is set (Bit 1, mask 0x08), duration-recalculation
should be done after all because this would imply the given
duration is reused for every subsequent fragment and there
isn't an easy way to set different durations for all of them.


--Michael Stahn

