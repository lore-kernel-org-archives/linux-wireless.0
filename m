Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33668
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbYAZNWL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 08:22:11 -0500
Date: Sat, 26 Jan 2008 05:22:24 -0800 (PST)
Message-Id: <20080126.052224.193711536.davem@davemloft.net> (sfid-20080126_132227_484398_8B59871A)
To: torvalds@linux-foundation.org
Cc: dcbw@redhat.com, mb@bu3sch.de, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0801251011590.14161@hp.linux-foundation.org>
References: <1201282027.3422.15.camel@localhost.localdomain>
	<alpine.LFD.1.00.0801250934030.14161@hp.linux-foundation.org>
	<alpine.LFD.1.00.0801251011590.14161@hp.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Jan 2008 10:22:13 -0800 (PST)

> With ethernet, there were chips that could only do DMA at certain
> alignments etc, together with various other headers being involved,
> making it impossible to require alignment without memcpy(), and I
> don't think we've had any issues there.

Yes, we could do a copy in the input path in the Intel drivers.

But then Intel is going to say "see it's fixed" and will never make
the 2 or 3 line fix to their firmware necessary to cure this
efficiently on all platforms.

To be honest I am in the camp of putting pressure on people
to do the right thing, and Intel fixing their firmware is
definitely the right thing to do here especially since it
is so easy for them to do so.

As for the "get another maintainer to step up" argument, nobody has
access to Intel's firmware source besides them, otherwise I can assure
you people would jump out of the woodwork by the handful to take over
several of Intel's drivers.

Many people are un-buggering up the Intel driver source bits that
people do have access to and can edit.

Intel controls the situation and that's just the way they like it.
It's not really a community thing because of the firmware issue,
so it's not possible to apply the same sort of "if you don't like
it, stand up and do the work to fix it" arguments.

We would if we could :-)

FWIW, I do agree with cpus should do unaligned accesses transparently,
without traps.  But unfortunately I don't think all the cell phones,
wireless access points, building key-card entry systems and the like
are going to switch over to x86 any time soon.  And in a scary sense
this is becomming the dominant space for Linux by at least some
measures :-)
