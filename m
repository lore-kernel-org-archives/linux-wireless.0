Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab0BETVh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 14:21:37 -0500
Subject: Re: [PATCH] airo: fix WEP key clearing after
 c0380693520b1a1e4f756799a0edc379378b462a
From: Dan Williams <dcbw@redhat.com>
To: Chris Siebenmann <cks@cs.toronto.edu>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>,
	Stanislaw Gruszka <sgruszka@redhat.com>
In-Reply-To: <20100205162620.0B2632B0054@apps0.cs.toronto.edu>
References: <20100205162620.0B2632B0054@apps0.cs.toronto.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 11:20:49 -0800
Message-ID: <1265397649.16621.48.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-02-05 at 11:26 -0500, Chris Siebenmann wrote:
> | The firmware apparently needs the WEP key RID touched when turning
> | WEP off, otherwise it gets angry and refuses to return scan results.
> | The firmware doesn't handle zero-length WEP keys so quite the warning
> | message that was inadvertently printed when disabling WEP, which
> | wpa_supplicant could trigger repeatedly.
> |
> | Signed-off-by: Dan Williams <dcbw@redhat.com>
> 
>  This patch does *not* work for me; with it applied to the 2.6.33-rc6
> from-git that I have been using as the testing basis, the resulting
> kernel does not see any wireless networks. dmesg has multiple reports

Yes, I know it may have worked in earlier kernels.  And we should find
out why that is, and hopefully fix the regression if any.  But
understand that airo has always been problematic and has never worked as
well as other fullmac cards like orinoco.

I booted up RHEL5 today, which uses a 2.6.18 kernel and of course does
not have the patch-in-question.  That behavior is:

1) stop NetworkManager and wpa_supplicant
2) insert airo card
3) iwlist scan returns many results
4) connect to WEP-enabled AP
5) iwlist scan returns *only* the connected ap
6) iwconfig eth1 essid any key off
7) iwlist scan returns no results

remember, that's without any of the patches we're talking about, using a
kernel from 2007.  Which is about the same behavior you get, correct?

> of:
> 
> 	airo(eth1): cmd:103 status:7f03 rsp0:0 rsp1:ff10 rsp2:c0f0
> 	airo(eth1): cmd:103 status:7f03 rsp0:0 rsp1:ff10 rsp2:c0f0

CMD 0x0103 is the LISTBSS command, which is sent to trigger a scan.
What firmware version do you have?  It should get printed out in 'dmesg'
when loading the driver.

Dan


