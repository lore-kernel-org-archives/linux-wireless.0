Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cliff.cs.toronto.edu ([128.100.3.120]:55260 "EHLO
	cliff.cs.toronto.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab0BIRRj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 12:17:39 -0500
To: Dan Williams <dcbw@redhat.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] airo: fix WEP key clearing after c0380693520b1a1e4f756799a0edc379378b462a 
In-reply-to: dcbw's message of Mon, 08 Feb 2010 15:47:11 -0800.
             <1265672831.15235.43.camel@localhost.localdomain>
Date: Tue, 09 Feb 2010 12:17:36 -0500
From: Chris Siebenmann <cks@cs.toronto.edu>
Message-Id: <20100209171736.A77642B0067@apps0.cs.toronto.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

| >  I don't get quite this behavior, although I'm not doing exactly these
| > steps; instead, I do:
| > 	- boot machine
| > 	- use 'iwlist scan' and see multiple APs
| > 	- use NetworkManager to connect to our WEP-enabled AP
| > 	- 'iwlist scan' returns only the single AP
| > 	- turn things off with:
| > 		iwconfig eth1 essid ANY key off
| > 	- 'iwconfig eth1' and NetworkManager both show no connected AP
| > 	- 'iwlist scan' returns only the ex-connected AP
| 
| These are the results you get on the older kernel without the commit
| we're all talking about here?

 I have been testing on the kernel with working wireless,
specifically Fedora 11's 2.6.29.6-217.2.8.fc11 kernel.

 I have to amend my testing results, however. I have now managed to get
the network live with iwconfig, not NetworkManager, and when I do this
and do 'iwconfig eth1 essid ANY key off', I actually see *multiple*
APs with 'iwlist scan' if I catch it at the right time. (In fact, I
sometimes associate with an unprotected network in range.)

(There is only one good network in range, which is ours, but I'm on
the edge of a number that sometimes show up in normal scan output and
sometimes don't.)

 So this doesn't match the behavior you were seeing with your old kernel
and machine.

	- cks
