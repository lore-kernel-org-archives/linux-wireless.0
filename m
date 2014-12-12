Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32799 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757969AbaLLLDq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 06:03:46 -0500
Message-ID: <1418382219.2470.10.camel@sipsolutions.net> (sfid-20141212_120350_165398_D0ADF25C)
Subject: Re: [PATCH 1/1] wireless: mac80211: Avoid using uninitialized stack
 data
From: Johannes Berg <johannes@sipsolutions.net>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Dec 2014 12:03:39 +0100
In-Reply-To: <1418238847-3332-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1418238847-3332-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1418238847-3332-2-git-send-email-Jes.Sorensen@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-10 at 14:14 -0500, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> Avoid case where we would access uninitialized stack data if a driver
> advertises HT support without 40MHz channel support.

I've fixed the commit message (it's actually in the check for the *AP*,
not the driver!)

Also, this is complicated. We originally had the DISABLE_VHT, but then
found APs that were doing it wrong - see commit f3000e1b43f1 ("mac80211:
fix broken use of VHT/20Mhz with some APs"). That fix introduced the bug
here, going back now to the DISABLE_VHT as I'd suggested would break the
fix again ... I'm thus taking this version to just put the right data on
the stack, with the correct Fixes/Cc stable tags.

johannes


