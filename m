Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38328 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab2JJPam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 11:30:42 -0400
Date: Wed, 10 Oct 2012 11:19:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.7] mac80211: use ieee80211_free_txskb to fix possible
 skb leaks
Message-ID: <20121010151936.GB6247@tuxdriver.com> (sfid-20121010_173046_892617_903557C1)
References: <1349699973-90027-1-git-send-email-nbd@openwrt.org>
 <507570E3.9000107@openwrt.org>
 <1349879153.4683.51.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349879153.4683.51.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 10, 2012 at 04:25:53PM +0200, Johannes Berg wrote:
> On Wed, 2012-10-10 at 14:58 +0200, Felix Fietkau wrote:
> > On 2012-10-08 2:39 PM, Felix Fietkau wrote:
> > > A few places free skbs using dev_kfree_skb even though they're called
> > > after ieee80211_subif_start_xmit might have cloned it for tracking tx
> > > status. Use ieee80211_free_txskb here to prevent skb leaks.
> > > 
> > > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> > > Cc: stable@vger.kernel.org
> > Found a few more places that should use ieee80211_free_txskb, will send
> > a v2.
> 
> John already applied this, no?

Yes, please send as a follow-on patch.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
