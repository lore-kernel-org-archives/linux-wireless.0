Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54640 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbbIWLDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 07:03:45 -0400
Date: Wed, 23 Sep 2015 13:03:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@do-not-panic.com,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Low latency communication over wifi
Message-ID: <20150923110343.GA19160@amd> (sfid-20150923_130348_584090_91456CD1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I'm trying to transfer some audio data over wifi. Latency constrains
are such that if it would took more than 20msec to wait for
transmission, the packet should be dropped instead, and new one should
be transmitted.

My final hardware contains CSR6026 chip, but drivers are way too
ugly, I decided it would be easier to prototype on ath5k-based card.

I hacked qcu.c to limit latencies:

  	  qi->tqi_cw_min = ath5k_cw_validate(0);
          qi->tqi_cw_max = ath5k_cw_validate(20);

...but I don't think it did what I wanted. What am I missing?

(I could use Intel 3945ABG-based card instead, but I figured out ath5k
might be easier to hack?)

Is there way to manipulate type of service from userland to get
similar behaviour without patching kernel?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
