Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:39497 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311AbZJ3Sv0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 14:51:26 -0400
Subject: Re: [PATCH] libertas if_usb: Fix crash on 64-bit machines
From: David Woodhouse <dwmw2@infradead.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linville@tuxdriver.com,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	dcbw@redhat.com, stern@rowland.harvard.edu, davem@davemloft.net
In-Reply-To: <200910301944.14740.chunkeey@googlemail.com>
References: <1256924714.4030.44.camel@macbook.infradead.org>
	 <4AEB2F13.50102@lwfinger.net>  <200910301944.14740.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Oct 2009 18:51:21 +0000
Message-Id: <1256928681.4030.112.camel@macbook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-10-30 at 19:44 +0100, Christian Lamparter wrote:
> 
> that's just a fill-in macro.
> AFAICT usb_submit_urb does the tricky dma mapping.

Ah, that makes sense. In that case, all we need to do is make
map_urb_for_dma() do the right thing.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

