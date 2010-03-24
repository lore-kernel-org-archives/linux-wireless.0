Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:41553 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab0CXMbE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 08:31:04 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1529832fgg.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Mar 2010 05:31:02 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [PATCH] ar9170usb: fix panic triggered by undersized rxstream buffer
Date: Wed, 24 Mar 2010 13:30:53 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Christian Mehlis <mehlis@inf.fu-berlin.de>,
	John W Linville <linville@tuxdriver.com>
References: <201003232151.14531.chunkeey@googlemail.com> <1269395940.5646.3.camel@jlt3.sipsolutions.net> <1269397218.4043.84.camel@debian>
In-Reply-To: <1269397218.4043.84.camel@debian>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003241330.53869.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 24 March 2010 03:20:18 Zhu Yi wrote:
> On Wed, 2010-03-24 at 09:59 +0800, Johannes Berg wrote:
> > On Tue, 2010-03-23 at 21:51 +0100, Christian Lamparter wrote:
> > > While ar9170's USB transport packet size is currently set to 8KiB,
> > > the PHY is capable of receiving AMPDUs with up to 64KiB.
> > > Such a large frame will be split over several rx URBs and
> > > exceed the previously allocated space for rx stream reconstruction.
> > > 
> > > This patch increases the buffer size to 64KiB which is
> > > in fact the phy & rx stream designed size limit.
> > 
> > That's a pretty high order allocation, you may want to paged allocation
> > -- you'll end up doing a order 5 allocation here!
> Yup, order-5 given the struct skb_shared_info overhead in __alloc_skb().
> If the URBs are split over, you probably don't need to allocate such a
> big chunk of memory in one go. 

I know, I know, but unfortunately I do need a continuous address space.
The reason is that usually one URB can have up to 5 data frames
(each with ~1600 Octets). That's why the driver memcpys everything
from the rxstream skbs into newly allocated ones for each individual frame.
(The reconstruction  simply adds another memcpy to a temporary buffer,
 until we have everything...).

as far as I can tell, there's only one other options:
 * mix vmalloc with paged skbs API ;-)

   This looks kind of funny. The API abuse is highly questionable and
   probably not something for "stable".

 * early drop, if len > 8KiB

   This has the downside that we lose the data and the rx stream state.
   (E.g.: signal quality & phy data, mac error codes, the lot...)

 * something I don't know?

   please tell me about it!

> You just need to connect them into a paged skb later before pushing to mac80211.
> BTW, I've moved the skb_linearize() from iwlwifi to mac80211. Will submit the patches today.
AFAIK Atheros resolved this issue with AR9271. At least that's what I
heard from Luis about the _new_ scatter/gather IO implementation.

Regards,
	Chr
