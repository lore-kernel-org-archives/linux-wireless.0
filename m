Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:38708 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755983AbXD0PQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 11:16:44 -0400
Message-ID: <463213D7.9070604@warmcat.com>
Date: Fri, 27 Apr 2007 16:16:39 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>	 <200704251634.16604.flamingice@sourmilk.net>	 <46312067.9090005@linux.intel.com>	 <200704262023.52833.flamingice@sourmilk.net>	 <1177684132.21025.36.camel@localhost.localdomain>	 <20070427164208.25434f11@griffin.suse.cz> <1177685793.21025.52.camel@localhost.localdomain>
In-Reply-To: <1177685793.21025.52.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:

> we're not being open enough to functionality that might be in hardware.
> Holding a 100% software line with mac80211 is just IMHO wrong and
> short-sighted.  The stack needs to be flexible WRT to the hardware

Yeah but this isn't "in hardware" -- it's in firmware: software that
runs of a different, vendor-specific, CPU.  Let's not talk about magic
and impressive "hardware" when the truth is we only talk about the same
software action on another CPU.  The problems with this particular
offload to firmware:

 - it is vendor-specific

 - it is not time-critical.  In fact it just sits there for tens of ms.
 The extra us lost going through mac80211 when it wants to change the
frequency should not be measurable.  It's not like it is some special
DSP in there that is computing PI faster than the main CPU in the box
can.  It is just changing the frequency now and then, which can
perfectly well be done in the stack

 - it is not exploitable in other ways.  If we want to talk about
"short-sighted", let's talk about managing what can be very generic RF
hardware in a way that can never do anything but IEEE802.11a/b/g actions

> capabilities of the parts that we expect to use it.  Saying no to
> hardware scanning just because it can also be done in software too is
> wrong.

To be clear, this isn't a "hardware" action, just an opaque software API
specific to that chipset, and that runs on a CPU in the chipset.

> with.  It's already in, right?  Ripping it out for a 100% software
> agenda is wrong.  Let's take out crypto offload then too if we're going

The iwlwifi proposal is for an opaque vendor-specific firmware API, that
is also "100% software".  Don't get confused by the bogus magic alleged
"hardware" nomenclature.

> to take a consistently 100% software line.  Again, it's not either
> software or hardware; it's a spectrum of capabilities and we shouldn't
> be making the stack _less_ flexible.

Yeah let's make the stack completely flexible and either keep control of
the scan action in the stack, or eventually move it to usermode, in both
cases doing the scan action well ONCE for ALL drivers.

-Andy
