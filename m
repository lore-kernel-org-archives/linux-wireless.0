Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:49287 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbYJMWvZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 18:51:25 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
Date: Tue, 14 Oct 2008 00:55:33 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <48EE20FB.4060700@lwfinger.net> <1223936680.10113.7.camel@johannes.berg> <1223937392.27118.2.camel@dv>
In-Reply-To: <1223937392.27118.2.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810140055.34065.chunkeey@web.de> (sfid-20081014_005131_036303_920B3DAB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 October 2008 00:36:32 Pavel Roskin wrote:
> On Tue, 2008-10-14 at 00:24 +0200, Johannes Berg wrote:
> > On Mon, 2008-10-13 at 17:44 -0400, Pavel Roskin wrote:
> > > On Thu, 2008-10-09 at 08:19 -0700, Larry Finger wrote:
> > > > This patch is meant for testing on big-endian hardware. Every indication
> > > > is that the data in the bootrec structure is little endian. This patch fixes
> > > > a usage of the u32 data array as a string of u8's.
> > > 
> > > I'm sorry, I didn't test your patch yet, but I could capture the output
> > > on the serial console.  It doesn't appear to be related to p54 specific
> > > data structures.  The driver is initialized correctly.  I can bring the
> > > interface up.  But once I try scanning, I get a sequence of the
> > > following messages in the kernel log:
> > > 
> > > Badness at /home/proski/src/linux-2.6/net/mac80211/rx.c:2200
> > 
> > That _is_ the driver's fault, it's not setting the rate index correctly.
> 
> I put a printk() there, and it shows:
> status->rate_idx = 12, sband->n_bitrates = 8
> 
> status->rate_idx should be less or equal sband->n_bitrates.
> 
> I don't get that on i386.  But the values don't seem to be corrupted by
> byte-swapping.
>
Hmm, this should be impossible since:
"p54: report appropriate rate and band values for 802.11a"
5f840304b5f7dff0028407fa9b284aecb85a94aa

regards,
	Chr
