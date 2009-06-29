Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:49995 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZF2NUu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2009 09:20:50 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MLGmx-0002AB-Rx
	for linux-wireless@vger.kernel.org; Mon, 29 Jun 2009 13:20:52 +0000
Received: from d5153017D.access.telenet.be ([81.83.1.125])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jun 2009 13:20:51 +0000
Received: from Gert.Boddaert by d5153017D.access.telenet.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jun 2009 13:20:51 +0000
To: linux-wireless@vger.kernel.org
From: Gert Boddaert <Gert.Boddaert@Boditec.be>
Subject: Re: rt73usb (rt2x00) crash bug on (big-endian) ARM
Date: Mon, 29 Jun 2009 13:20:39 +0000 (UTC)
Message-ID: <loom.20090629T131526-620@post.gmane.org>
References: <loom.20090625T114232-539@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


We found the culprit of the 'crash' for problem 1: 
our watchdog implementation.
The high load on the device, stops the watchdog refresh... hence crash and reset.

We disabled the watchdog to do further testing... next.

However, when the load on the RX side gets to high, after a while (a few seconds
of sustained RX load), 
the connection is not dropped but we are unable to get
any more packets through. This state does not resolve itself.




