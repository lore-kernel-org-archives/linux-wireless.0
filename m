Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099Ab0BHXr7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 18:47:59 -0500
Subject: Re: [PATCH] airo: fix WEP key clearing after
 c0380693520b1a1e4f756799a0edc379378b462a
From: Dan Williams <dcbw@redhat.com>
To: Chris Siebenmann <cks@cs.toronto.edu>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>,
	Stanislaw Gruszka <sgruszka@redhat.com>
In-Reply-To: <20100205231239.F1FDA2B0054@apps0.cs.toronto.edu>
References: <20100205231239.F1FDA2B0054@apps0.cs.toronto.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 15:47:11 -0800
Message-ID: <1265672831.15235.43.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-02-05 at 18:12 -0500, Chris Siebenmann wrote:
> | Yes, I know it may have worked in earlier kernels.  And we should find
> | out why that is, and hopefully fix the regression if any.  But
> | understand that airo has always been problematic and has never worked as
> | well as other fullmac cards like orinoco.
> | 
> | I booted up RHEL5 today, which uses a 2.6.18 kernel and of course does
> | not have the patch-in-question.  That behavior is:
> | 
> | 1) stop NetworkManager and wpa_supplicant
> | 2) insert airo card
> | 3) iwlist scan returns many results
> | 4) connect to WEP-enabled AP
> | 5) iwlist scan returns *only* the connected ap
> | 6) iwconfig eth1 essid any key off
> | 7) iwlist scan returns no results
> | 
> | remember, that's without any of the patches we're talking about, using a
> | kernel from 2007.  Which is about the same behavior you get, correct?
> 
>  I don't get quite this behavior, although I'm not doing exactly these
> steps; instead, I do:
> 	- boot machine
> 	- use 'iwlist scan' and see multiple APs
> 	- use NetworkManager to connect to our WEP-enabled AP
> 	- 'iwlist scan' returns only the single AP
> 	- turn things off with:
> 		iwconfig eth1 essid ANY key off
> 	- 'iwconfig eth1' and NetworkManager both show no connected AP
> 	- 'iwlist scan' returns only the ex-connected AP

These are the results you get on the older kernel without the commit
we're all talking about here?

> (I do not know the right commands to connect to our WEP-enabled AP and
> verify that everything is working right without using NetworkManager,
> so I used it for the connection phase.)

iwconfig ethX essid 'foobar' key <your hex wep key>

Then run 'iwconfig ethX' over and over until you see a valid AP BSSID
listed in the result, and then you can run 'dhclient -1 -v -d ethX' to
try and DHCP.

Also, what firmware version do you have?

Dan


