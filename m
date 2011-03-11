Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10242 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab1CKIaF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 03:30:05 -0500
Subject: Re: bug: iwlwifi, aggregation, and mac80211's reorder buffer
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: "ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTi=taszKd9-kyijN100oEegnFi=0u5L4WCp7R_sJ@mail.gmail.com>
References: <AANLkTi=taszKd9-kyijN100oEegnFi=0u5L4WCp7R_sJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Mar 2011 00:13:58 -0800
Message-ID: <1299831238.5082.185.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

On Fri, 2011-03-11 at 00:11 -0800, Daniel Halperin wrote:
> I'm doing some performance debugging of iwlwifi.  My test setup has
> one machine with iwlwifi-5300 (3 TX streams) and ar9280 (2 TX streams)
> connected to a 3-stream iwl5300 AP.  There's no/not much external
> interference in my setup.  I'm doing bandwidth tests using iperf.
> Both cards gets something like 200 Mbps using UDP, and Atheros gets
> 130--150 Mbps using TCP while iwlwifi gets ~60 Mbps(!!).  This seems
> bad, especially since iwl5300 has 3 TX streams.  And they're
> connecting from the same computer to the same AP while getting similar
> UDP performance, so I don't think it's a hardware difference.
> 
> In looking at various TCP effects, I noticed that with
> ath9k+minstrel_ht, there are never any TCP retransmissions or
> selective acknowledgements.  However, with iwlwifi these are rampant
> and large bursts of these are highly correlated with network-layer
> dead time even up to ~100ms(!!).
> 
> I first suspected rate selection, so I hacked iwlwifi to only use MCS
> that work very well for my test link.  I confirmed that there is very
> little loss in my experiments.  I then moved on to aggregation.
> 
> One thing that Intel does that ath9k does not is transmit packets out
> of sequence number order inside a batch.  (This is legal in the 802.11
> standard).  I figured that one explanation for the TCP SACKs would be
> if, somehow, frames got released to the network stack out of order;
> indeed, many of the "holes" covered by the SACKs are filled quickly
> (within ~4ms, about the length of one aggregation batch).  Note that
> iwlwifi defaults to an aggregation frame limit, hence buffer size, of
> 31 frames.  mac80211 honors this buffer size specification by
> releasing frames to the network stack that are >= 31 sequence numbers
> below the highest received frame.
> 
> It looks like Intel doesn't honor its own frame limit, as I often saw
> it have more than 31 frames outstanding, causing mac80211 on the
> receiver to release many frames early.  Changing iwlwifi's default agg
> limit to 63 frames on both ends dramatically reduced the prevalence of
> SACKs/TCP retransmissions and improved avg TCP performance to ~100
> Mbps (ranging 83-110).
> 
> A few questions:
> 
> (1) Why does iwlwifi default to an aggregation frame limit of 31? I
> didn't see any negative effects from 63 frame limit and performance
> improved dramatically
if I remember correctly, we change from 63 to 31 while we have some 11n
performance issue. even later we found out frame limit is not the main
reason of low tpt, but we did not change it back since at the time we
did not see any performance different, I believe we can use different
frame limit, but I will prefer make it more flexible, maybe something
could be change by either module parameter or debugfs. Also I am not
sure are there any behavior differences between different devices and
different versions of ucode.

> (2) Is there a way to make iwlwifi honor the aggregation limit?  I
> know that agg is controlled by a hardware scheduler, so this may be
> difficult.
Agree, I will try to find more information from our PHY engineer.
 
> (3) mac80211's reorder buffer code could probably also be relaxed.  It
> probably wouldn't hurt to have the buffer be twice the transmitter's
> advertised buffer, and might compensate for devices that don't
> properly honor frame limits.  Also, mac80211 only flushes the reorder
> buffer every 100 ms.  That seems like a LONG time given that batches
> are limited to 4ms -- 100ms is room for at least 10, maybe 20
> retransmissions to attempt to fill in the holes(!).

did you try it and do you have any data?

Thanks
Wey


