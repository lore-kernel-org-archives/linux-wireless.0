Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932708Ab0BDVpm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 16:45:42 -0500
Subject: Re: [PATCH] airo: fix setting zero length WEP key
From: Dan Williams <dcbw@redhat.com>
To: Chris Siebenmann <cks@cs.toronto.edu>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
In-Reply-To: <20100203213109.B2D802B0054@apps0.cs.toronto.edu>
References: <20100203213109.B2D802B0054@apps0.cs.toronto.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 13:44:55 -0800
Message-ID: <1265319895.4290.4.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-02-03 at 16:31 -0500, Chris Siebenmann wrote:
> | > Patch prevents call set_wep_key() with zero key
> | > length. That fix long standing regression since commit
> | > c0380693520b1a1e4f756799a0edc379378b462a "airo: clean up WEP key
> | > operations". [...]
> |
> | What problem/regression does this actually fix? [...]
> 
>  That mentioned commit broke wireless on a Thinkpad T42 (running Fedora
> 11); from that commit onwards, the wireless system appeared to see no
> networks. The patch makes things work again.
> 
>  More details are in the Fedora bugzilla:
> 	https://bugzilla.redhat.com/show_bug.cgi?id=522530

You mean with iwlist?  That's quite odd because setting WEP keys doesn't
have anything to do with the scanning stuff, even in the firmware.  Note
that Airo has always been somewhat tempermental for scans and you may or
may not see any or all APs in any given scan.

Dan


