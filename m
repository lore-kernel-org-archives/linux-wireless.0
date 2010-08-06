Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:35696 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761321Ab0HFX4g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 19:56:36 -0400
Date: Fri, 6 Aug 2010 16:56:31 -0700
From: Greg KH <greg@kroah.com>
To: Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
Cc: stable@kernel.org, Christoph Fritz <chf.fritz@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [stable] ssb: 2.6.34.1 -> 2.6.34.2 regression
Message-ID: <20100806235631.GA21827@kroah.com>
References: <4C5C9252.7040007@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4C5C9252.7040007@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 07, 2010 at 12:53:06AM +0200, Michael Büsch wrote:
> Hi,
> 
> The SPROM changes applied to SSB in 2.6.34.2 completely broke SPROM
> extraction. This leads to broken wireless for my BCM4306 card.
> All other BCM43xx and BCM44xx most likely are affected, too.
> Symptoms should be wrong MAC addresses and broken transmission (for 43xx).
> 
> The patch changed the SPEX() macro and removed the offset subtraction,
> but did not remove the actual 0x1000 offset from the SPROM defines.
> This results in random memory poking rather than proper SPROM data
> extraction.
> 
> I applied the following to my kernel to get it working again. However
> this is not a proper fix. I suggest that the -stable SSB patch
> is dropped and mainline patches being applied. They seem to
> be correct (However I did not test mainline, yet).

That's already done, can you please test the 2.6.34.3-rc1 kernel that
was announced a few hours ago?  I should have fixed all of the issues
there, if not, please let me know.

thanks,
greg k-h
