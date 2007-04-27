Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:40895 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755966AbXD0PTn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 11:19:43 -0400
Date: Fri, 27 Apr 2007 17:20:04 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Dan Williams <dcbw@redhat.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
Message-ID: <20070427172004.32b7bf4a@griffin.suse.cz>
In-Reply-To: <1177685793.21025.52.camel@localhost.localdomain>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	<200704251634.16604.flamingice@sourmilk.net>
	<46312067.9090005@linux.intel.com>
	<200704262023.52833.flamingice@sourmilk.net>
	<1177684132.21025.36.camel@localhost.localdomain>
	<20070427164208.25434f11@griffin.suse.cz>
	<1177685793.21025.52.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Apr 2007 10:56:33 -0400, Dan Williams wrote:
> My point is that things are not black and white.  It's not fullmac vs.
> softmac, there's a spectrum of parts in between.  I'm not advocating
> making mac80211 work with every part under the sun, but it seems that
> we're not being open enough to functionality that might be in hardware.
> Holding a 100% software line with mac80211 is just IMHO wrong and
> short-sighted.  The stack needs to be flexible WRT to the hardware
> capabilities of the parts that we expect to use it.  Saying no to
> hardware scanning just because it can also be done in software too is
> wrong.

Agreed.

> We're not trying to limit the capabilities of hardware artificially, but
> at the same time we're not going to allow crackpot hardware stuff to
> clutter up the stack.  Hardware scan is far from crackpot hardware
> stuff; it's a simple, discrete function that shouldn't be hard work
> with.  It's already in, right?  Ripping it out for a 100% software
> agenda is wrong.  Let's take out crypto offload then too if we're going
> to take a consistently 100% software line.  Again, it's not either
> software or hardware; it's a spectrum of capabilities and we shouldn't
> be making the stack _less_ flexible.

The problem is that Michael during fixing of the stack for mainline
inclusion encountered a problem with the current implementation of the
hw scanning. We need to fix that problem.

The proposed solution (removing of the hw_scan callback) obviously
fixes the problem. Now, let's find something that fixes the problem as
well but doesn't remove the functionality. James already proposed a
solution that could work if a support for user space MLME is added. Do
you have an idea how to add it?

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
