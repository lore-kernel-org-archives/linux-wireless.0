Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:50147 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab3DXHBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 03:01:00 -0400
Received: by mail-oa0-f44.google.com with SMTP id h1so1352090oag.3
        for <linux-wireless@vger.kernel.org>; Wed, 24 Apr 2013 00:00:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net>
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net>
Date: Wed, 24 Apr 2013 09:00:59 +0200
Message-ID: <CACna6rx1zeBDBC-wq+LMWcB1tupe6bs8Z4_JGdnd6vQNomzFnQ@mail.gmail.com> (sfid-20130424_091140_215485_894F8E4E)
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
> From: Thommy Jakobsson <thommyj@gmail.com>
>
> Add handling of rx descriptor underflow. This fixes a fault that could
> happen on slow machines, where data is received faster than the CPU can
> handle. In such a case the device will use up all rx descriptors and
> refuse to send any more data before confirming that it is ok. This
> patch enables necessary interrupt to discover such a situation and will
> handle them by dropping everything in the ring buffer.

Thanks for working on this, I didn't really got enough time to follow
your active discussion actively.

I'll try to test this patch on my devices over the next weekend.

-- 
Rafał
