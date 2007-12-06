Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:61027 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbXLFTCf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 14:02:35 -0500
Date: Thu, 6 Dec 2007 11:01:56 -0800
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] fixing the ap_scan and hidden SSID mess
Message-ID: <20071206190156.GA5237@bougret.hpl.hp.com> (sfid-20071206_190345_971903_00CDD3C2)
Reply-To: jt@hpl.hp.com
References: <20071205221119.GA28457@bougret.hpl.hp.com> <1196894672.14901.5.camel@localhost.localdomain> <20071205230507.GA28902@bougret.hpl.hp.com> <1196938955.3980.23.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1196938955.3980.23.camel@localhost.localdomain>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 06, 2007 at 06:02:35AM -0500, Dan Williams wrote:
> 
> It's a problem for backporting this fix to older kernels that are not
> 2.6.25.

	I think backporting would be a non starter, only bug fixes are
suppossed to be backported. For out-of-tree driver, a #ifdef will do
the trick trivially.

> So is the ANY_SSID_SCAN thing different from just calling SIOCSIWSCAN
> _without_ any options?  I was under the impression that just calling
> SIWSCAN would scan for all SSIDs.

	You are right. Actually, if you stuff a empty essid in
SIOCSIWSCAN, I doubt it would work.
	The purpose of the flag is different : identify audited from
non audited drivers.

> I've actually thought about your proposal, and decided that you're
> right.  I'll post another patch for more comments.
> 
> dan

	Regards,

	Jean
