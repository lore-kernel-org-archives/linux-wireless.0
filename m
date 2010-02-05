Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cliff.cs.toronto.edu ([128.100.3.120]:46158 "EHLO
	cliff.cs.toronto.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933352Ab0BEXMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 18:12:42 -0500
To: Dan Williams <dcbw@redhat.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] airo: fix WEP key clearing after c0380693520b1a1e4f756799a0edc379378b462a 
In-reply-to: dcbw's message of Fri, 05 Feb 2010 11:20:49 -0800.
             <1265397649.16621.48.camel@localhost.localdomain>
Date: Fri, 05 Feb 2010 18:12:39 -0500
From: Chris Siebenmann <cks@cs.toronto.edu>
Message-Id: <20100205231239.F1FDA2B0054@apps0.cs.toronto.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

| Yes, I know it may have worked in earlier kernels.  And we should find
| out why that is, and hopefully fix the regression if any.  But
| understand that airo has always been problematic and has never worked as
| well as other fullmac cards like orinoco.
| 
| I booted up RHEL5 today, which uses a 2.6.18 kernel and of course does
| not have the patch-in-question.  That behavior is:
| 
| 1) stop NetworkManager and wpa_supplicant
| 2) insert airo card
| 3) iwlist scan returns many results
| 4) connect to WEP-enabled AP
| 5) iwlist scan returns *only* the connected ap
| 6) iwconfig eth1 essid any key off
| 7) iwlist scan returns no results
| 
| remember, that's without any of the patches we're talking about, using a
| kernel from 2007.  Which is about the same behavior you get, correct?

 I don't get quite this behavior, although I'm not doing exactly these
steps; instead, I do:
	- boot machine
	- use 'iwlist scan' and see multiple APs
	- use NetworkManager to connect to our WEP-enabled AP
	- 'iwlist scan' returns only the single AP
	- turn things off with:
		iwconfig eth1 essid ANY key off
	- 'iwconfig eth1' and NetworkManager both show no connected AP
	- 'iwlist scan' returns only the ex-connected AP

(I do not know the right commands to connect to our WEP-enabled AP and
verify that everything is working right without using NetworkManager,
so I used it for the connection phase.)

	- cks
