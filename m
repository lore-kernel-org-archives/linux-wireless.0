Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757871Ab0BDWTL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 17:19:11 -0500
Subject: Re: [PATCH] airo: fix setting zero length WEP key
From: Dan Williams <dcbw@redhat.com>
To: Chris Siebenmann <cks@cs.toronto.edu>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
In-Reply-To: <20100204221049.717A72B0054@apps0.cs.toronto.edu>
References: <20100204221049.717A72B0054@apps0.cs.toronto.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 14:18:20 -0800
Message-ID: <1265321900.4290.20.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-02-04 at 17:10 -0500, Chris Siebenmann wrote:
> | >  That mentioned commit broke wireless on a Thinkpad T42 (running Fedora
> | > 11); from that commit onwards, the wireless system appeared to see no
> | > networks. The patch makes things work again.
> | > 
> | >  More details are in the Fedora bugzilla:
> | > 	https://bugzilla.redhat.com/show_bug.cgi?id=522530
> | 
> | You mean with iwlist?  That's quite odd because setting WEP keys
> | doesn't have anything to do with the scanning stuff, even in the
> | firmware.  Note that Airo has always been somewhat tempermental for
> | scans and you may or may not see any or all APs in any given scan.
> 
>  All I know is that the failure is total; in all situations I've
> tried where a good kernel sees one or more networks and APs, a bad
> kernel sees none at all (and 'iwlist wifi0 scanning' reports 'No
> scan results'). A good kernel sometimes reports different numbers of
> networks and sometimes has quality problems, but a bad kernel never sees
> anything.
> 
> (Well, has never seen anything within a relatively modest amount of
> time.  I have not let it sit for, say, an hour in order to see if
> something magically gets better; I have always rebooted into a kernel
> with working wireless.)

When are you attempting to scan?  Is anything like wpa_supplicant or
NetworkManager running in the background when you do this?

Dan

