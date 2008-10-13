Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:10891 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbYJMWgf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 18:36:35 -0400
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Chr <chunkeey@web.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223936680.10113.7.camel@johannes.berg>
References: <48EE20FB.4060700@lwfinger.net>  <1223934261.26245.4.camel@dv>
	 (sfid-20081013_234428_358947_F23DF3A7)  <1223936680.10113.7.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 18:36:32 -0400
Message-Id: <1223937392.27118.2.camel@dv> (sfid-20081014_003643_662984_B3BE2F59)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-14 at 00:24 +0200, Johannes Berg wrote:
> On Mon, 2008-10-13 at 17:44 -0400, Pavel Roskin wrote:
> > On Thu, 2008-10-09 at 08:19 -0700, Larry Finger wrote:
> > > This patch is meant for testing on big-endian hardware. Every indication
> > > is that the data in the bootrec structure is little endian. This patch fixes
> > > a usage of the u32 data array as a string of u8's.
> > 
> > I'm sorry, I didn't test your patch yet, but I could capture the output
> > on the serial console.  It doesn't appear to be related to p54 specific
> > data structures.  The driver is initialized correctly.  I can bring the
> > interface up.  But once I try scanning, I get a sequence of the
> > following messages in the kernel log:
> > 
> > Badness at /home/proski/src/linux-2.6/net/mac80211/rx.c:2200
> 
> That _is_ the driver's fault, it's not setting the rate index correctly.

I put a printk() there, and it shows:
status->rate_idx = 12, sband->n_bitrates = 8

status->rate_idx should be less or equal sband->n_bitrates.

I don't get that on i386.  But the values don't seem to be corrupted by
byte-swapping.

-- 
Regards,
Pavel Roskin
