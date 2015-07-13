Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53113 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbbGMXGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2015 19:06:21 -0400
Message-ID: <55A4446C.4090803@candelatech.com> (sfid-20150714_010624_652443_1E2C0951)
Date: Mon, 13 Jul 2015 16:06:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: Don't enable PROMISC when adding AP to a bridge?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I notice some of my WLE900VX cards will lock up and not receive any packets
after a few seconds of being in PROMISC mode.  This happens on my own
CT firmware as well as stock firmware-2.bin.  This breaks monitor mode, of
course, but it also breaks bridged AP mode.

So, I found this patch from way back when:
http://lists.celinuxforum.org/pipermail/bridge/2008-June/005906.html

I hacked a similar thing into my 4.0.4 kernel, and now bridged mode
AP seems much more stable (and the radio does not go into PROMISC mode,
so it should be more efficient in a busy RF environment).

Maybe this feature could be revisited?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

