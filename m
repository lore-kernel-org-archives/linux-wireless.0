Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab0IOFoQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 01:44:16 -0400
Subject: Re: RFC:  mac80211/ath9k:  allow scanning single channel if other
 VIF is associated.
From: Dan Williams <dcbw@redhat.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4C9059DC.7060009@candelatech.com>
References: <4C8EB03D.7070808@candelatech.com>
	 <20100915030316.GB30253@jm.kir.nu>  <4C9059DC.7060009@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 00:46:53 -0500
Message-ID: <1284529613.10728.32.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-14 at 22:30 -0700, Ben Greear wrote:
> On 09/14/2010 08:03 PM, Jouni Malinen wrote:
> > On Mon, Sep 13, 2010 at 04:14:05PM -0700, Ben Greear wrote:
> >> This patch aims to decrease channel switching when there is at least one
> >> interface associated.  This should help multiple station interfaces co-exist
> >> on the same hardware, especially in WPA mode.
> >
> > If I understood the change correctly, it would prevent running full
> > scans when in associated state. That does not sound reasonable behavior
> > and scanning should not cause an association to be lost. Did I miss
> > something or what exactly is this trying to do?
> 
> That's pretty much what I'm trying to do.  We had similar code in
> our 2.6.31 kernel with ath5k. Imagine getting 50 virtual stations
> started with WPA and all of them trying to scan all channels at once!
> Most got timeouts, and one scanning would disrupt traffic on the others.
> And, the hardware can only associate on a single channel anyway, so getting
> scan results for other channels doesn't do a great deal of good.
> 
> With current ath9k, I see DMA timeouts and other nasty things (without
> that patch applied) when trying to bring up two VIFs with WPA.
> 
> I think for the multi-VIF scenario, it should scan the single associated
> channel by default, but it would be nice to allow full scans on demand.
> (I would very much like to work with standard wpa_supplicant, but if hacking it
> is the only way, then I can attempt that.)

Allowing full scans on demand (ie when userspace requests it) is a must.
Even in multi-VIF mode.

Dan

> > If you want to limit scans a single channel in some special use cases,
> > you should be able to do that in user space, too, at least for the
> > initial scan before connection. As a future optimization, we should
> > somehow be able to merge scan requests from multiple VIFs into a single
> > one, i.e., share the results from a single scan to multiple VIFs..
> 
> Merging would be nice.  Maybe store the results in the global hardware/phy
> structs and just return that to user-space so long as it's relatively fresh?
> 
> > It would be easier to comment on the changes if you were to inline them
> > instead of attaching the file..
> 
> Sorry about that..I'll inline it next time.  It will probably be white-space
> damaged, but I can re-send any official patches using git.
> 
> Thanks,
> Ben
> 
> 


