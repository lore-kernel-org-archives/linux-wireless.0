Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63127 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab1DXSb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 14:31:28 -0400
Received: by eyx24 with SMTP id 24so551915eyx.19
        for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2011 11:31:27 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [PATCH 1/2] p54: implement multicast filter
Date: Sun, 24 Apr 2011 22:31:19 +0400
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <060ac4fbe5b4c314227ae3867e1dce0919772ccd.1303660092.git.chunkeey@googlemail.com>
In-Reply-To: <060ac4fbe5b4c314227ae3867e1dce0919772ccd.1303660092.git.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201104242231.20272.jcmvbkbc@gmail.com> (sfid-20110424_203131_978992_7AC03356)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> "For best CPU usage and power consumption, having as few
> frames as possible percolate through the stack is
> desirable. Hence, the hardware should filter as much
> as possible."
> 
> Note: Not all firmwares include the multicast filter
> feature and the stack does not filter them either.
> The ARP filter on the other hand was dropped from the
> patch since it does not work correctly:
> 
> Quote from: Max Filippov <jcmvbkbc@gmail.com>
> <http://www.spinics.net/lists/linux-wireless/msg67466.html>
> "In the ARP case, when there's no other traffic on p54spi,
> all ARP requests are dropped. But if there's some egress
> traffic from p54spi, filter seems to work correctly:
> only ARP requests that match filter pass through.
> 
> In the multicast case filter seems to work correctly, but
> it treats broadcast as subject to that filtering too. By
> default only 01:00:5e:00:00:01 gets into priv->mc_maclist,
> so we miss all broadcasts.
> 
> These two filters seem to interfere:
> - if we set ARP filter and multicast filter without bc
> 	=>  we miss all ARPs if there's no egress traffic;
> - if we set ARP filter and multicast filter with bc or
> 	don't set mc filter at all => we get all ARPs.
> 
> This effect does not depend on filter setup order."
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>

wrt p54spi:

Tested-by: Max Filippov <jcmvbkbc@gmail.com>

Thanks.
-- Max
