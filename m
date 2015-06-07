Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pegasus.erg.abdn.ac.uk ([139.133.204.173]:36958 "EHLO
	pegasus.erg.abdn.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbbFGCrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2015 22:47:16 -0400
Received: from localhost (S0106001ee52ef802.ed.shawcable.net [50.65.115.34])
	by pegasus.erg.abdn.ac.uk (Postfix) with ESMTPSA id 029C81B0014F
	for <linux-wireless@vger.kernel.org>; Sun,  7 Jun 2015 03:37:31 +0100 (BST)
Date: Sat, 6 Jun 2015 20:37:21 -0600
From: Gerrit Renker <gerrit@erg.abdn.ac.uk>
To: linux-wireless@vger.kernel.org
Subject: [WEXT]: multiple calls for SIOCGIWSTATS return same value
Message-ID: <20150606203721.28791bb3@erg.abdn.ac.uk> (sfid-20150607_044726_833751_BC9D05B3)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A problem has been found in recent kernels where multiple
calls using SIOCGIWSTATS return the same, identical value.

This behaviour is observable both using 'iwconfig <dev>'
and wavemon info screen, where it was reported in [1].

It looks as if this is a WEXT issue, since on the same 
system multiple 'iw dev <devname> station dump' calls
return different signal level values.

I can confirm the behaviour on davem 4.1.0-rc6 net tree
at commit c46a024ea5, it has been reported on [1] for 
fedora 21 with kernel-4.0.4-201/2 as well.

That report also stated that the behaviour does not occur
on kernel-3.19.7-200. Have not had time to bisect yet.

Thanks for any hints that can help resolve this.

[1] https://github.com/uoaerg/wavemon/issues/10
