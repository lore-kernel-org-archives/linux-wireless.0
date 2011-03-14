Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:46559 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894Ab1CNAtp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Mar 2011 20:49:45 -0400
Subject: Re: bug: iwlwifi, aggregation, and mac80211's reorder buffer
From: wwguy <wey-yi.w.guy@intel.com>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: "ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTikYJQcpOnE+Q3=VFioEfpdB+8j+x7+-K_eSU7kd@mail.gmail.com>
References: <AANLkTi=taszKd9-kyijN100oEegnFi=0u5L4WCp7R_sJ@mail.gmail.com>
	 <1299831238.5082.185.camel@wwguy-huron>
	 <AANLkTikYJQcpOnE+Q3=VFioEfpdB+8j+x7+-K_eSU7kd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Mar 2011 17:47:27 -0700
Message-ID: <1300063647.24333.7.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-03-13 at 12:59 -0700, Daniel Halperin wrote:
> On Fri, Mar 11, 2011 at 12:13 AM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> >> (1) Why does iwlwifi default to an aggregation frame limit of 31? I
> >> didn't see any negative effects from 63 frame limit and performance
> >> improved dramatically
> > if I remember correctly, we change from 63 to 31 while we have some 11n
> > performance issue. even later we found out frame limit is not the main
> > reason of low tpt, but we did not change it back since at the time we
> > did not see any performance different, I believe we can use different
> > frame limit, but I will prefer make it more flexible, maybe something
> > could be change by either module parameter or debugfs. Also I am not
> > sure are there any behavior differences between different devices and
> > different versions of ucode.
> 
> 63 hasn't hurt me yet, though the scheduler still does occasionally
> send a 64th frame that shifts the reorder buffer's window.  Is there a
> chance that 64 will work as a max?  63 seems an odd choice.

it is limited by uCode, did not have chance to look at what the reason
is yet. my initial guess without look at the code, 63 = 0x3F which use 6
bits and 64=0x40 is 7 bits, but I am not sure, I will check

Thanks

> 
> >> (3) mac80211's reorder buffer code could probably also be relaxed.  It
> >> probably wouldn't hurt to have the buffer be twice the transmitter's
> >> advertised buffer, and might compensate for devices that don't
> >> properly honor frame limits.  Also, mac80211 only flushes the reorder
> >> buffer every 100 ms.  That seems like a LONG time given that batches
> >> are limited to 4ms -- 100ms is room for at least 10, maybe 20
> >> retransmissions to attempt to fill in the holes(!).
> 
> Removing the check here
> <https://github.com/mirrors/linux-2.6/blob/master/net/mac80211/agg-rx.c#L231>
> essentially forces the receive buffer to be 64 frames long.  This
> works just fine for me (iwl5300 TXer and RXer) and would seem to be
> appropriate for any transmitter window. If the transmitter uses a
> window of, say, 31 frames and also honors its limit, then I think the
> only wasted space would be 33 pointers to skb's at the transmitter
> side. I didn't see any degradation using an ath9k+minstrel_ht
> transmitter with this change.
> 
> Dan


