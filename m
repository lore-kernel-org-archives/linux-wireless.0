Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39498 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab0CXB7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 21:59:18 -0400
Subject: Re: [PATCH] ar9170usb: fix panic triggered by undersized rxstream
 buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	Christian Mehlis <mehlis@inf.fu-berlin.de>,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <201003232151.14531.chunkeey@googlemail.com>
References: <201003232151.14531.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 18:59:00 -0700
Message-ID: <1269395940.5646.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-23 at 21:51 +0100, Christian Lamparter wrote:
> While ar9170's USB transport packet size is currently set to 8KiB,
> the PHY is capable of receiving AMPDUs with up to 64KiB.
> Such a large frame will be split over several rx URBs and
> exceed the previously allocated space for rx stream reconstruction.
> 
> This patch increases the buffer size to 64KiB which is
> in fact the phy & rx stream designed size limit.

That's a pretty high order allocation, you may want to paged allocation
-- you'll end up doing a order 5 allocation here!

johannes


