Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:40924 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972Ab1DMHzv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 03:55:51 -0400
Date: Wed, 13 Apr 2011 09:55:45 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Igor Plyatov <plyatov@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: rt2800usb: page allocation failure
Message-ID: <20110413075545.GA18716@sig21.net>
References: <4DA471DC.7080308@gmail.com>
 <4DA49332.8000403@lwfinger.net>
 <20110412212236.GA8877@sig21.net>
 <4DA4FE7C.8070807@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DA4FE7C.8070807@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 12, 2011 at 08:38:04PM -0500, Larry Finger wrote:
> On 04/12/2011 04:22 PM, Johannes Stezenbach wrote:
> >
> >I don't think the allocation uses the MTU, rather rt2x00queue_alloc_rxskb()
> >uses some hw specific constants.  No idea if these can be reduced,
> >but multi-page GFP_ATOMIC allocations can easily fail.
> 
> That is likely. Those hw specific constants add up to 40 bytes, thus
> the major part is actual buffer. That is set at 3840 bytes, thus I
> don't understand why the request was order 1.

An skb has quite a bit of overhead, there's full
struct skb_shared_info inside, plus some padding.
See dev_alloc_skb() -> __alloc_skb().
If think that pushes it above 4096 bytes.

Johannes
