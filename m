Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:3128 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbZG1XC4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 19:02:56 -0400
Received: from [192.168.0.22] (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by smtprelay1.cesmail.net (Postfix) with ESMTPSA id 343B334C6D
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 19:02:55 -0400 (EDT)
Subject: ath5k does multicast filtering in monitor mode
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 28 Jul 2009 19:02:54 -0400
Message-Id: <1248822174.5206.26.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

It turns out ath5k doesn't receive multicast packets while in monitor
mode.  Multicast packets are only received on the interface if it's set
to a promiscuous or allmulti mode of if the multicast address I need is
added by "ip maddr add".

Wireshark puts interfaces in promiscuous mode, but some utility I wrote
wasn't doing that, so it could not capture multicast packets with ath5k.

Do we have any standard whether multicast filtering is allowed in
monitor mode?  Should I fix ath5k or the userspace program?

-- 
Regards,
Pavel Roskin
