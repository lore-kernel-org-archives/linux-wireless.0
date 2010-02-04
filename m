Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cliff.cs.toronto.edu ([128.100.3.120]:52149 "EHLO
	cliff.cs.toronto.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660Ab0BDXgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 18:36:10 -0500
To: Dan Williams <dcbw@redhat.com>
cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
Subject: Re: [PATCH] airo: fix setting zero length WEP key 
In-reply-to: dcbw's message of Thu, 04 Feb 2010 15:26:11 -0800.
             <1265325971.4290.38.camel@localhost.localdomain>
Date: Thu, 04 Feb 2010 18:36:08 -0500
From: Chris Siebenmann <cks@cs.toronto.edu>
Message-Id: <20100204233608.90E172B0054@apps0.cs.toronto.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

| >  In the GUI, no wireless networks show up/are listed in the usual
| > dropdown menu; this means that I can't go as far as even trying to
| > connect to anything.  From the command line, 'iwlist wifi0 scanning'
| > lists nothing.
|
| Wait, wifi0?  You need to be using 'eth0' or 'eth1', whichever eth
| device that 'iwconfig' reports. wifi0 is a historical airo anomaly
| that's only used for packet capture and sniffing of the 802.11 frames.
| It should not be used for anything other than Wireshark basically.
|
| Do you get the same behavior if you use the normal ethX interface of
| the airo device?

 Yes; on a 'bad' kernel, 'iwlist eth1 scanning' lists nothing, and on a
good kernel it lists the networks that I expect (with some variability;
where I have the machine at the moment is on the edge of visibility for
some networks, and they appear and disappear periodically).

| Note that just because wifi0 may return scan results doesn't mean it
| should be used with iwconfig...
|
| But also, you're doing the iwlist scan as root, correct?

 Yes (on both the good and the bad kernels).

 I haven't been trying to use iwconfig for anything; all of my actual
use of the wireless networks has been done through the Fedora 11 GUI.

	- cks
