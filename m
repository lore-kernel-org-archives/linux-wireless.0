Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:50540 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3EEMoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 May 2013 08:44:16 -0400
Received: by mail-oa0-f45.google.com with SMTP id o17so2761493oag.4
        for <linux-wireless@vger.kernel.org>; Sun, 05 May 2013 05:44:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net>
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net>
Date: Sun, 5 May 2013 14:44:14 +0200
Message-ID: <CACna6rxWPOqQPNUaASaj=v=O+Wjt0okjX4jNwE3tv-=etfATCg@mail.gmail.com> (sfid-20130505_144430_841385_78EBBC0C)
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Thommy Jakobsson <thommyj@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, m@bues.ch, piotras@gmail.com,
	Larry.Finger@lwfinger.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/4/23 Thommy Jakobsson <thommyj@gmail.com>:
> Add handling of rx descriptor underflow. This fixes a fault that could
> happen on slow machines, where data is received faster than the CPU can
> handle. In such a case the device will use up all rx descriptors and
> refuse to send any more data before confirming that it is ok. This
> patch enables necessary interrupt to discover such a situation and will
> handle them by dropping everything in the ring buffer.

Thommy: does it mean firmware actually ignores what we write to the
B43_DMA64_RXINDEX (recently renamed to the B43_DMA64_RXSTOPINDEX)? Is
our set_current_rxslot and op64_set_current_rxslot (same for 32bit
version) useless in this situation?

Could this be a off-by-one issue? Maybe we're writing a value too low
by a one and firmware believes the whole ring is empty while it's
full?

I think we may want turning this interrupt anyway, but I wonder if
there is another issue we just hide a bit better.

-- 
Rafał
