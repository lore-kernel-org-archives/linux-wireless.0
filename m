Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:30206 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab0CXCTb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 22:19:31 -0400
Subject: Re: [PATCH] ar9170usb: fix panic triggered by undersized rxstream
 buffer
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Christian Mehlis <mehlis@inf.fu-berlin.de>,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <1269395940.5646.3.camel@jlt3.sipsolutions.net>
References: <201003232151.14531.chunkeey@googlemail.com>
	 <1269395940.5646.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 10:20:18 +0800
Message-ID: <1269397218.4043.84.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-24 at 09:59 +0800, Johannes Berg wrote:
> On Tue, 2010-03-23 at 21:51 +0100, Christian Lamparter wrote:
> > While ar9170's USB transport packet size is currently set to 8KiB,
> > the PHY is capable of receiving AMPDUs with up to 64KiB.
> > Such a large frame will be split over several rx URBs and
> > exceed the previously allocated space for rx stream reconstruction.
> > 
> > This patch increases the buffer size to 64KiB which is
> > in fact the phy & rx stream designed size limit.
> 
> That's a pretty high order allocation, you may want to paged allocation
> -- you'll end up doing a order 5 allocation here!

Yup, order-5 given the struct skb_shared_info overhead in __alloc_skb().
If the URBs are split over, you probably don't need to allocate such a
big chunk of memory in one go. You just need to connect them into a
paged skb later before pushing to mac80211. BTW, I've moved the
skb_linearize() from iwlwifi to mac80211. Will submit the patches today.

Thanks,
-yi

