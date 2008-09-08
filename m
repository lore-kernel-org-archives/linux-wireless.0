Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:8660 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbYIHMsd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 08:48:33 -0400
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
From: Pavel Roskin <proski@gnu.org>
To: jt@hpl.hp.com
Cc: Dan Williams <dcbw@redhat.com>, kilroyd@googlemail.com,
	linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
In-Reply-To: <20080902230621.GA28885@bougret.hpl.hp.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
	 <1217825304.10989.20.camel@dv>
	 <1217864060.3139.10.camel@localhost.localdomain>
	 <20080805162238.GA6294@bougret.hpl.hp.com>
	 <20080902230621.GA28885@bougret.hpl.hp.com>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 08:48:30 -0400
Message-Id: <1220878110.2369.3.camel@dv> (sfid-20080908_144838_599219_67C1E88C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-09-02 at 16:06 -0700, Jean Tourrilhes wrote:

> 	By the way, the breakage of iwlist scan in Wireless Tools 30
> on 64 bits should be fixed in 30.pre7.

No, it's still not fixed on x86_64.  scanflags in print_scanning_info()
in iwlist.c is 2, but srq->flags is 0 in orinoco_ioctl_setscan() in
orinoco.c.

On i386,  srq->flags is 2 as expected and the scan results are correctly
influenced by the ESSID.

-- 
Regards,
Pavel Roskin
