Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58116
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbYHBFas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 01:30:48 -0400
Date: Fri, 01 Aug 2008 22:30:48 -0700 (PDT)
Message-Id: <20080801.223048.129067423.davem@davemloft.net> (sfid-20080802_073050_882459_437DE62C)
To: ivdoorn@gmail.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
Subject: Re: [PATCH] rt2x00: Fix compile warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <200808020749.08431.IvDoorn@gmail.com>
References: <200808020749.08431.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <ivdoorn@gmail.com>
Date: Sat, 2 Aug 2008 07:49:08 +0200

> rt2x00usb_vendor_request_large_buff is write-only, so it is
> safe to make the argument a const.
> 
> Fixes compile warning:
> drivers/net/wireless/rt2x00/rt73usb.c: In function 'rt73usb_load_firmware':
> drivers/net/wireless/rt2x00/rt73usb.c:916: warning: passing argument 5 of 'rt2x00usb_vendor_request_large_buff' discards qualifiers from pointer target typ
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

Are you sure?

This buffer pointer, via 'tb', eventually gets passed down
to rt2x00usb_vendor_req_buff_lock which conditionally copies
into the buffer.
